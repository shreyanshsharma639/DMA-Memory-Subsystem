`timescale 1ns / 1ps

module axi_to_sram_bridge #(
    parameter C_S_AXI_ID_WIDTH   = 1,
    parameter C_S_AXI_DATA_WIDTH = 32,
    parameter C_S_AXI_ADDR_WIDTH = 32,
    parameter FIFO_DEPTH         = 16,
    parameter SRAM_LATENCY       = 15 
)(
    input  logic                          clk,
    input  logic                          rst_n,

    // AXI4 Interface
    input  logic [C_S_AXI_ID_WIDTH-1:0]   S_AXI_AWID,
    input  logic [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR,
    input  logic [7:0]                    S_AXI_AWLEN,
    input  logic [2:0]                    S_AXI_AWSIZE,
    input  logic [1:0]                    S_AXI_AWBURST,
    input  logic                          S_AXI_AWVALID,
    output logic                          S_AXI_AWREADY,

    input  logic [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA,
    input  logic [C_S_AXI_DATA_WIDTH/8-1:0] S_AXI_WSTRB,
    input  logic                          S_AXI_WLAST,
    input  logic                          S_AXI_WVALID,
    output logic                          S_AXI_WREADY,

    output logic [C_S_AXI_ID_WIDTH-1:0]   S_AXI_BID,
    output logic [1:0]                    S_AXI_BRESP,
    output logic                          S_AXI_BVALID,
    input  logic                          S_AXI_BREADY,

    input  logic [C_S_AXI_ID_WIDTH-1:0]   S_AXI_ARID,
    input  logic [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR,
    input  logic [7:0]                    S_AXI_ARLEN,
    input  logic [2:0]                    S_AXI_ARSIZE,
    input  logic [1:0]                    S_AXI_ARBURST,
    input  logic                          S_AXI_ARVALID,
    output logic                          S_AXI_ARREADY,

    output logic [C_S_AXI_ID_WIDTH-1:0]   S_AXI_RID,
    output logic [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA,
    output logic [1:0]                    S_AXI_RRESP,
    output logic                          S_AXI_RLAST,
    output logic                          S_AXI_RVALID,
    input  logic                          S_AXI_RREADY,

    // SRAM Interface
    output logic [14:0]                   sram_addr,
    output logic [31:0]                   sram_din,
    input  logic [31:0]                   sram_dout,
    output logic                          sram_ce_n,
    output logic                          sram_we_n
);

    // Internal Signals
    logic        wfifo_push, wfifo_pop, wfifo_full, wfifo_empty;
    logic [31:0] wfifo_din_data, wfifo_dout_data;
    logic [3:0]  wfifo_din_strb, wfifo_dout_strb;

    logic        rfifo_push, rfifo_pop, rfifo_full, rfifo_empty;
    logic [31:0] rfifo_din, rfifo_dout;

    logic        sram_write_burst_done;
    
    logic        start_sram_read_req; 
    
    logic [14:0] latched_read_start_addr;
    logic [7:0]  latched_read_len;
    
    logic [31:0] sram_read_latch;
    logic [3:0]  latency_counter; 

    // FSM State Types
    typedef enum logic [2:0] {W_IDLE, W_GET_DATA, W_SEND_RESP} w_state_t;
    w_state_t w_state, w_next;
    typedef enum logic [2:0] {SW_IDLE, SW_READ, SW_WAIT_READ, SW_MODIFY, SW_WRITE, SW_WAIT_WRITE} sw_state_t;
    sw_state_t sw_state, sw_next;
    typedef enum logic [1:0] {R_IDLE, R_SEND_DATA} r_state_t;
    r_state_t r_state, r_next;
    typedef enum logic [1:0] {SR_IDLE, SR_READ, SR_WAIT, SR_PUSH} sr_state_t;
    sr_state_t sr_state, sr_next;

    logic [7:0]  w_burst_counter;
    logic [14:0] w_addr_counter;
    logic [14:0] sw_current_addr;
    logic [31:0] rmw_old_data, rmw_new_data;
    logic [7:0] r_burst_counter;
    logic [14:0] sr_addr_counter;
    logic [7:0]  sr_words_left;

    // 1. AXI Write FSM
    always_ff @(posedge clk or negedge rst_n) if(!rst_n) w_state <= W_IDLE; else w_state <= w_next;
    always_comb case(w_state)
        W_IDLE: w_next = (S_AXI_AWVALID) ? W_GET_DATA : W_IDLE;
        W_GET_DATA: w_next = (S_AXI_WVALID && S_AXI_WREADY && w_burst_counter == 0) ? W_SEND_RESP : W_GET_DATA;
        W_SEND_RESP: w_next = (sram_write_burst_done && S_AXI_BREADY) ? W_IDLE : W_SEND_RESP;
        default: w_next = W_IDLE;
    endcase

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            w_burst_counter <= 0; w_addr_counter <= 0;
        end else begin
            if(w_state == W_IDLE && S_AXI_AWVALID) begin
                w_burst_counter <= S_AXI_AWLEN;
                w_addr_counter  <= S_AXI_AWADDR[16:2];
            end else if(w_state == W_GET_DATA && S_AXI_WVALID && S_AXI_WREADY) begin
                if(w_burst_counter > 0) w_burst_counter <= w_burst_counter - 1;
                w_addr_counter <= w_addr_counter + 1;
            end
        end
    end

    assign S_AXI_AWREADY = (w_state == W_IDLE);
    assign S_AXI_WREADY  = (w_state == W_GET_DATA) && !wfifo_full; 
    assign S_AXI_BVALID  = (w_state == W_SEND_RESP && sram_write_burst_done);
    assign S_AXI_BRESP   = 2'b00;
    assign S_AXI_BID     = S_AXI_AWID;
    assign wfifo_push     = (S_AXI_WVALID && S_AXI_WREADY);
    assign wfifo_din_data = S_AXI_WDATA;
    assign wfifo_din_strb = S_AXI_WSTRB;

    logic [14:0] sram_write_base_addr;
    always_ff @(posedge clk) if(w_state == W_IDLE && S_AXI_AWVALID) sram_write_base_addr <= S_AXI_AWADDR[16:2];

    // 2. SRAM Write FSM
    always_ff @(posedge clk or negedge rst_n) if(!rst_n) sw_state <= SW_IDLE; else sw_state <= sw_next;
    
    always_comb begin
        sw_next = sw_state;
        case(sw_state)
            SW_IDLE: begin
                if(!wfifo_empty) begin
                    if(sr_state == SR_IDLE) begin
                        if(wfifo_dout_strb == 4'b1111) sw_next = SW_WRITE;
                        else                           sw_next = SW_READ;
                    end
                end
            end
            SW_READ:       sw_next = SW_WAIT_READ; 
            SW_WAIT_READ:  sw_next = (latency_counter >= SRAM_LATENCY - 1) ? SW_MODIFY : SW_WAIT_READ;
            SW_MODIFY:     sw_next = SW_WRITE;
            SW_WRITE:      sw_next = SW_WAIT_WRITE;
            SW_WAIT_WRITE: sw_next = (latency_counter >= SRAM_LATENCY - 1) ? SW_IDLE : SW_WAIT_WRITE;
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            sw_current_addr <= 0; sram_write_burst_done <= 0;
        end else begin
            if(w_state == W_IDLE && S_AXI_AWVALID) begin
                sw_current_addr <= S_AXI_AWADDR[16:2];
                sram_write_burst_done <= 0;
            end 
            else if(sw_state == SW_WAIT_WRITE && latency_counter >= SRAM_LATENCY - 1) begin
                 sw_current_addr <= sw_current_addr + 1;
            end
            if(w_state == W_SEND_RESP && wfifo_empty && sw_state == SW_IDLE)
                sram_write_burst_done <= 1;
            if(sw_state == SW_WAIT_READ && latency_counter >= SRAM_LATENCY - 1) 
                rmw_old_data <= sram_dout;
        end
    end

    always_comb begin
        rmw_new_data = wfifo_dout_data;
        if(sw_state == SW_MODIFY || sw_state == SW_WRITE || sw_state == SW_WAIT_WRITE) begin
            if(!wfifo_dout_strb[0]) rmw_new_data[7:0]   = rmw_old_data[7:0];
            if(!wfifo_dout_strb[1]) rmw_new_data[15:8]  = rmw_old_data[15:8];
            if(!wfifo_dout_strb[2]) rmw_new_data[23:16] = rmw_old_data[23:16];
            if(!wfifo_dout_strb[3]) rmw_new_data[31:24] = rmw_old_data[31:24];
        end
    end
    assign wfifo_pop = (sw_state == SW_WAIT_WRITE && latency_counter >= SRAM_LATENCY - 1);

    // 3. AXI Read FSM
    always_ff @(posedge clk or negedge rst_n) if(!rst_n) r_state <= R_IDLE; else r_state <= r_next;
    always_comb case(r_state)
        R_IDLE: r_next = (S_AXI_ARVALID) ? R_SEND_DATA : R_IDLE;
        R_SEND_DATA: r_next = (S_AXI_RREADY && S_AXI_RVALID && r_burst_counter == 0) ? R_IDLE : R_SEND_DATA;
    endcase

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_burst_counter <= 0;
            latched_read_start_addr <= 0;
            latched_read_len <= 0;
        end else begin
            if(r_state == R_IDLE && S_AXI_ARVALID) begin
                r_burst_counter <= S_AXI_ARLEN;
                latched_read_start_addr <= S_AXI_ARADDR[16:2];
                latched_read_len <= S_AXI_ARLEN;
            end else begin
                if(r_state == R_SEND_DATA && S_AXI_RREADY && S_AXI_RVALID) begin
                    if(r_burst_counter > 0) r_burst_counter <= r_burst_counter - 1;
                end
            end
        end
    end
    assign S_AXI_ARREADY = (r_state == R_IDLE);
    assign S_AXI_RVALID  = !rfifo_empty;
    assign S_AXI_RDATA   = rfifo_dout;
    assign S_AXI_RLAST   = (r_state == R_SEND_DATA && r_burst_counter == 0);
    assign S_AXI_RRESP   = 2'b00;
    assign S_AXI_RID     = S_AXI_ARID;
    assign rfifo_pop     = (S_AXI_RREADY && S_AXI_RVALID);

    // 4. SRAM Read FSM
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) start_sram_read_req <= 0;
        else begin
            if(r_state == R_IDLE && S_AXI_ARVALID) 
                start_sram_read_req <= 1; 
            else if(sr_state == SR_READ) 
                start_sram_read_req <= 0; 
        end
    end

    always_ff @(posedge clk or negedge rst_n) if(!rst_n) sr_state <= SR_IDLE; else sr_state <= sr_next;
    
    always_comb begin
        sr_next = sr_state;
        case(sr_state)
            SR_IDLE: begin 
                if(start_sram_read_req && sw_state == SW_IDLE && wfifo_empty) sr_next = SR_READ;
                else sr_next = SR_IDLE;
            end
            SR_READ: sr_next = SR_WAIT;
            SR_WAIT: sr_next = (latency_counter >= SRAM_LATENCY - 1) ? SR_PUSH : SR_WAIT;
            SR_PUSH: begin
                if(!rfifo_full) begin
                    if(sr_words_left > 0) begin
                        if(sw_state == SW_IDLE) sr_next = SR_READ;
                        else                    sr_next = SR_PUSH; 
                    end
                    else sr_next = SR_IDLE;
                end
            end
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            latency_counter <= 0;
            sram_read_latch <= 0;
            sr_addr_counter <= 0;
            sr_words_left <= 0;
        end else begin
            if(sr_state == SR_READ || sw_state == SW_READ || sw_state == SW_WRITE) latency_counter <= 0;
            else if(sr_state == SR_WAIT || sw_state == SW_WAIT_READ || sw_state == SW_WAIT_WRITE) latency_counter <= latency_counter + 1;

            if(sr_state == SR_WAIT && latency_counter >= SRAM_LATENCY - 1) sram_read_latch <= sram_dout;

            if(sr_state == SR_IDLE && start_sram_read_req) begin
                sr_addr_counter <= latched_read_start_addr;
                sr_words_left <= latched_read_len;
            end else if(sr_state == SR_PUSH && !rfifo_full) begin
                if(sr_words_left > 0 && sw_state == SW_IDLE) begin
                    sr_words_left   <= sr_words_left - 1;
                    sr_addr_counter <= sr_addr_counter + 1;
                end
            end
        end
    end
    assign rfifo_push = (sr_state == SR_PUSH && !rfifo_full);
    assign rfifo_din  = sram_read_latch;

    // SRAM Muxing
    logic write_active;
    assign write_active = (sw_state != SW_IDLE);

    assign sram_addr = write_active ? sw_current_addr : sr_addr_counter;
    assign sram_din  = rmw_new_data;
    
    assign sram_ce_n = write_active ? 
                       !((sw_state == SW_READ) || (sw_state == SW_WAIT_READ) || (sw_state == SW_WRITE) || (sw_state == SW_WAIT_WRITE)) :
                       !((sr_state == SR_READ) || (sr_state == SR_WAIT));

    assign sram_we_n = write_active ? !(sw_state == SW_WRITE || sw_state == SW_WAIT_WRITE) : 1'b1;

    // Helper FIFO
    sync_fifo #(.DEPTH(FIFO_DEPTH), .DATA_WIDTH(32+4)) u_wfifo (
        .clk(clk), .rst_n(rst_n), .push(wfifo_push), .pop(wfifo_pop),
        .din({wfifo_din_strb, wfifo_din_data}), .dout({wfifo_dout_strb, wfifo_dout_data}),
        .full(wfifo_full), .empty(wfifo_empty)
    );
    sync_fifo #(.DEPTH(FIFO_DEPTH), .DATA_WIDTH(32)) u_rfifo (
        .clk(clk), .rst_n(rst_n), .push(rfifo_push), .pop(rfifo_pop),
        .din(rfifo_din), .dout(rfifo_dout),
        .full(rfifo_full), .empty(rfifo_empty)
    );
endmodule

// Keep sync_fifo
module sync_fifo #(parameter DEPTH=16, DATA_WIDTH=32)(
    input  logic clk, rst_n, input logic push, pop, input logic [DATA_WIDTH-1:0] din, output logic [DATA_WIDTH-1:0] dout, output logic full, empty
);
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    logic [$clog2(DEPTH):0] cnt;
    logic [$clog2(DEPTH)-1:0] wr_ptr, rd_ptr;
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin cnt <= 0; wr_ptr <= 0; rd_ptr <= 0; end
        else begin
            if(push && !full) begin mem[wr_ptr] <= din; wr_ptr <= (wr_ptr == DEPTH-1) ? 0 : wr_ptr + 1; if(!pop) cnt <= cnt + 1; end
            if(pop && !empty) begin rd_ptr <= (rd_ptr == DEPTH-1) ? 0 : rd_ptr + 1; if(!push) cnt <= cnt - 1; end
        end
    end
    assign full = (cnt == DEPTH); assign empty = (cnt == 0); assign dout = mem[rd_ptr];
endmodule
`timescale 1ns / 1ps

module dma_channel #(
    parameter C_M_AXI_ID_WIDTH   = 1,
    parameter C_M_AXI_DATA_WIDTH = 32,
    parameter C_M_AXI_ADDR_WIDTH = 32,
    parameter FIFO_DEPTH         = 16
)(
    input  logic                          clk,
    input  logic                          rst_n,

    // Control Interface (From Register Block / CPU)
    input  logic                          start,        
    input  logic [C_M_AXI_ADDR_WIDTH-1:0] src_addr,
    input  logic [C_M_AXI_ADDR_WIDTH-1:0] dest_addr,
    input  logic [31:0]                   length_bytes, 
    output logic                          busy,         
    output logic                          done,         
    output logic                          error,        

    // AXI4 Master Interface (To Bridge/Memory)
    // Read Address Channel (AR)
    output logic [C_M_AXI_ID_WIDTH-1:0]   M_AXI_ARID,
    output logic [C_M_AXI_ADDR_WIDTH-1:0] M_AXI_ARADDR,
    output logic [7:0]                    M_AXI_ARLEN,
    output logic [2:0]                    M_AXI_ARSIZE,
    output logic [1:0]                    M_AXI_ARBURST,
    output logic                          M_AXI_ARVALID,
    input  logic                          M_AXI_ARREADY,

    // Read Data Channel (R)
    input  logic [C_M_AXI_ID_WIDTH-1:0]   M_AXI_RID,
    input  logic [C_M_AXI_DATA_WIDTH-1:0] M_AXI_RDATA,
    input  logic [1:0]                    M_AXI_RRESP,
    input  logic                          M_AXI_RLAST,
    input  logic                          M_AXI_RVALID,
    output logic                          M_AXI_RREADY,

    // Write Address Channel (AW)
    output logic [C_M_AXI_ID_WIDTH-1:0]   M_AXI_AWID,
    output logic [C_M_AXI_ADDR_WIDTH-1:0] M_AXI_AWADDR,
    output logic [7:0]                    M_AXI_AWLEN,
    output logic [2:0]                    M_AXI_AWSIZE,
    output logic [1:0]                    M_AXI_AWBURST,
    output logic                          M_AXI_AWVALID,
    input  logic                          M_AXI_AWREADY,

    // Write Data Channel (W)
    output logic [C_M_AXI_DATA_WIDTH-1:0] M_AXI_WDATA,
    output logic [C_M_AXI_DATA_WIDTH/8-1:0] M_AXI_WSTRB,
    output logic                          M_AXI_WLAST,
    output logic                          M_AXI_WVALID,
    input  logic                          M_AXI_WREADY,

    // Write Response Channel (B)
    input  logic [C_M_AXI_ID_WIDTH-1:0]   M_AXI_BID,
    input  logic [1:0]                    M_AXI_BRESP,
    input  logic                          M_AXI_BVALID,
    output logic                          M_AXI_BREADY
);

    // Internal Signals & FIFO
    logic        fifo_push, fifo_pop, fifo_full, fifo_empty;
    logic [31:0] fifo_din, fifo_dout;
    logic [4:0]  fifo_count; 

    logic rd_done, wr_done;
    logic rd_error, wr_error;

    assign M_AXI_ARID    = '0;
    assign M_AXI_ARSIZE  = 3'b010; 
    assign M_AXI_ARBURST = 2'b01;  
    assign M_AXI_AWID    = '0;
    assign M_AXI_AWSIZE  = 3'b010; 
    assign M_AXI_AWBURST = 2'b01;  
    assign M_AXI_WSTRB   = 4'b1111; 

    // 1. Read Engine FSM (Source -> FIFO)
    typedef enum logic [1:0] {RD_IDLE, RD_CALC, RD_ADDR, RD_DATA} rd_state_t;
    rd_state_t rd_state, rd_next;

    logic [31:0] rd_bytes_rem;
    logic [31:0] rd_current_addr;
    logic [7:0]  rd_burst_len;  
    logic [7:0]  rd_beat_count;

    // State Register
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) rd_state <= RD_IDLE;
        else       rd_state <= rd_next;
    end

    // Next State Logic
    always_comb begin
        rd_next = rd_state;
        case(rd_state)
            RD_IDLE: if(start) rd_next = RD_CALC;
            RD_CALC: rd_next = RD_ADDR;
            RD_ADDR: if(M_AXI_ARREADY) rd_next = RD_DATA;
            RD_DATA: begin
                // If last beat of burst received
                if(M_AXI_RVALID && M_AXI_RLAST && !fifo_full) begin
                    if(rd_bytes_rem > 4) rd_next = RD_CALC;
                    else                 rd_next = RD_IDLE;
                end
            end
        endcase
    end

    // Datapath
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            rd_bytes_rem <= 0; 
            rd_current_addr <= 0; 
            rd_done <= 0;
            rd_burst_len <= 0;
            rd_beat_count <= 0;
        end else begin
            if(rd_state == RD_IDLE) begin
                rd_done <= 0;
                if(start) begin
                    rd_bytes_rem <= length_bytes;
                    rd_current_addr <= src_addr;
                end
            end
            else if(rd_state == RD_CALC) begin
                if(rd_bytes_rem >= 64) rd_burst_len <= 8'd15; 
                else                   rd_burst_len <= (rd_bytes_rem[31:2]) - 1;
            end
            else if(rd_state == RD_DATA) begin
                if(M_AXI_RVALID && !fifo_full) begin
                    rd_bytes_rem <= rd_bytes_rem - 4;
                    rd_current_addr <= rd_current_addr + 4;
                    
                    if(M_AXI_RLAST && rd_bytes_rem <= 4) 
                        rd_done <= 1;
                end
            end
        end
    end

    assign M_AXI_ARVALID = (rd_state == RD_ADDR);
    assign M_AXI_ARADDR  = rd_current_addr;
    assign M_AXI_ARLEN   = rd_burst_len;
    assign M_AXI_RREADY  = (rd_state == RD_DATA && !fifo_full);

    assign fifo_push = (M_AXI_RVALID && M_AXI_RREADY);
    assign fifo_din  = M_AXI_RDATA;

    // 2. Write Engine FSM (FIFO -> Destination)
    typedef enum logic [2:0] {WR_IDLE, WR_CALC, WR_ADDR, WR_DATA, WR_RESP} wr_state_t;
    wr_state_t wr_state, wr_next;

    logic [31:0] wr_bytes_rem;
    logic [31:0] wr_current_addr;
    logic [7:0]  wr_burst_len;
    logic [7:0]  wr_beat_count;
    logic [31:0] wr_bytes_just_sent;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) wr_state <= WR_IDLE;
        else       wr_state <= wr_next;
    end

    // Helper to calculate bytes sent in current burst for comparison
    assign wr_bytes_just_sent = (wr_burst_len + 1) * 4;

    always_comb begin
        wr_next = wr_state;
        case(wr_state)
            WR_IDLE: if(start) wr_next = WR_CALC;
            WR_CALC: begin
                if( (fifo_count >= (wr_burst_len + 1)) || rd_done ) 
                    wr_next = WR_ADDR;
            end
            WR_ADDR: if(M_AXI_AWREADY) wr_next = WR_DATA;
            WR_DATA: if(M_AXI_WREADY && wr_beat_count == wr_burst_len) wr_next = WR_RESP;
            WR_RESP: begin
                if(M_AXI_BVALID) begin
                    if(wr_bytes_rem > wr_bytes_just_sent) wr_next = WR_CALC;
                    else                                  wr_next = WR_IDLE;
                end
            end
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            wr_bytes_rem <= 0; 
            wr_current_addr <= 0; 
            wr_beat_count <= 0; 
            wr_done <= 0;
            wr_burst_len <= 0;
        end else begin
            if(wr_state == WR_IDLE) begin
                wr_done <= 0;
                if(start) begin
                    wr_bytes_rem <= length_bytes;
                    wr_current_addr <= dest_addr;
                end
            end
            else if(wr_state == WR_CALC) begin
                if(wr_bytes_rem >= 64) wr_burst_len <= 8'd15;
                else                   wr_burst_len <= (wr_bytes_rem[31:2]) - 1;
                wr_beat_count <= 0;
            end
            else if(wr_state == WR_DATA) begin
                if(M_AXI_WREADY) begin
                    wr_beat_count <= wr_beat_count + 1;
                end
            end
            else if(wr_state == WR_RESP && M_AXI_BVALID) begin
                wr_bytes_rem <= wr_bytes_rem - wr_bytes_just_sent;
                wr_current_addr <= wr_current_addr + wr_bytes_just_sent;
                
                if(wr_bytes_rem <= wr_bytes_just_sent) wr_done <= 1;
            end
        end
    end

    assign M_AXI_AWVALID = (wr_state == WR_ADDR);
    assign M_AXI_AWADDR  = wr_current_addr;
    assign M_AXI_AWLEN   = wr_burst_len;
    
    assign M_AXI_WVALID  = (wr_state == WR_DATA);
    assign M_AXI_WDATA   = fifo_dout;
    assign M_AXI_WLAST   = (wr_state == WR_DATA && wr_beat_count == wr_burst_len);
    
    assign M_AXI_BREADY  = (wr_state == WR_RESP);

    assign fifo_pop      = (wr_state == WR_DATA && M_AXI_WREADY);

    // Helper Module: Synchronous FIFO (with Count)
    sync_fifo_cnt #(.DEPTH(FIFO_DEPTH), .DATA_WIDTH(32)) u_fifo (
        .clk(clk), .rst_n(rst_n),
        .push(fifo_push), .pop(fifo_pop),
        .din(fifo_din),
        .dout(fifo_dout),
        .full(fifo_full), .empty(fifo_empty),
        .count(fifo_count)
    );

    // Status Outputs
    assign busy  = (rd_state != RD_IDLE) || (wr_state != WR_IDLE);
    assign done  = wr_done;
    assign error = (M_AXI_RRESP[1] | M_AXI_BRESP[1]); 

endmodule

// FIFO with Count Output
module sync_fifo_cnt #(parameter DEPTH=16, DATA_WIDTH=32)(
    input  logic clk, rst_n,
    input  logic push, pop,
    input  logic [DATA_WIDTH-1:0] din,
    output logic [DATA_WIDTH-1:0] dout,
    output logic full, empty,
    output logic [$clog2(DEPTH):0] count
);
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    logic [$clog2(DEPTH):0] cnt;
    logic [$clog2(DEPTH)-1:0] wr_ptr, rd_ptr;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cnt <= 0; wr_ptr <= 0; rd_ptr <= 0;
        end else begin
            if(push && !full) begin
                mem[wr_ptr] <= din;
                wr_ptr <= (wr_ptr == DEPTH-1) ? 0 : wr_ptr + 1;
                if(!pop) cnt <= cnt + 1;
            end
            if(pop && !empty) begin
                rd_ptr <= (rd_ptr == DEPTH-1) ? 0 : rd_ptr + 1;
                if(!push) cnt <= cnt - 1;
            end
        end
    end
    assign full  = (cnt == DEPTH);
    assign empty = (cnt == 0);
    assign dout  = mem[rd_ptr];
    assign count = cnt;
endmodule
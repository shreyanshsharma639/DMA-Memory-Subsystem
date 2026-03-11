`timescale 1ns / 1ps

module dma_axil_slave #(
    parameter C_S_AXI_DATA_WIDTH = 32,
    parameter C_S_AXI_ADDR_WIDTH = 7 // 128 bytes address space (covers 4 channels)
)(
    input  logic                          clk,
    input  logic                          rst_n,
    
    // AXI-Lite Slave Interface
    input  logic [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR,
    input  logic                          S_AXI_AWVALID,
    output logic                          S_AXI_AWREADY,
    input  logic [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA,
    input  logic [C_S_AXI_DATA_WIDTH/8-1:0] S_AXI_WSTRB,
    input  logic                          S_AXI_WVALID,
    output logic                          S_AXI_WREADY,
    output logic                          S_AXI_BVALID,
    output logic [1:0]                    S_AXI_BRESP,
    input  logic                          S_AXI_BREADY,
    input  logic [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR,
    input  logic                          S_AXI_ARVALID,
    output logic                          S_AXI_ARREADY,
    output logic [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA,
    output logic [1:0]                    S_AXI_RRESP,
    output logic                          S_AXI_RVALID,
    input  logic                          S_AXI_RREADY,

    //Channel Configuration Outputs
    output logic [31:0] o_ch0_src_addr, o_ch0_dest_addr, o_ch0_length, output logic o_ch0_start_pulse,
    output logic [31:0] o_ch1_src_addr, o_ch1_dest_addr, o_ch1_length, output logic o_ch1_start_pulse,
    output logic [31:0] o_ch2_src_addr, o_ch2_dest_addr, o_ch2_length, output logic o_ch2_start_pulse,
    output logic [31:0] o_ch3_src_addr, o_ch3_dest_addr, o_ch3_length, output logic o_ch3_start_pulse,

    //Channel Status Inputs
    input logic i_ch0_busy, i_ch0_done, i_ch0_err,
    input logic i_ch1_busy, i_ch1_done, i_ch1_err,
    input logic i_ch2_busy, i_ch2_done, i_ch2_err,
    input logic i_ch3_busy, i_ch3_done, i_ch3_err
);
    // States
    localparam WR_IDLE = 2'b00, WR_DATA = 2'b01, WR_RESP = 2'b10;
    localparam RD_IDLE = 1'b0, RD_DATA = 1'b1;

    logic [1:0] w_state, w_next;
    logic r_state, r_next;
    logic [6:0] awaddr, araddr;
    logic wr_en;

    // Write FSM
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) w_state <= WR_IDLE;
        else       w_state <= w_next;
    end

    always_comb begin
        case(w_state)
            WR_IDLE: w_next = (S_AXI_AWVALID) ? WR_DATA : WR_IDLE;
            WR_DATA: w_next = (S_AXI_WVALID) ? WR_RESP : WR_DATA;
            WR_RESP: w_next = (S_AXI_BREADY) ? WR_IDLE : WR_RESP;
            default: w_next = WR_IDLE;
        endcase
    end

    assign S_AXI_AWREADY = (w_state == WR_IDLE);
    assign S_AXI_WREADY  = (w_state == WR_DATA);
    assign S_AXI_BVALID  = (w_state == WR_RESP);
    assign S_AXI_BRESP   = 0;
    assign wr_en         = (S_AXI_WVALID && S_AXI_WREADY);
    
    always_ff @(posedge clk) begin
        if(S_AXI_AWVALID && S_AXI_AWREADY) awaddr <= S_AXI_AWADDR;
    end

    // Read FSM
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) r_state <= RD_IDLE;
        else       r_state <= r_next;
    end

    always_comb begin
        case(r_state)
            RD_IDLE: r_next = (S_AXI_ARVALID) ? RD_DATA : RD_IDLE;
            RD_DATA: r_next = (S_AXI_RREADY) ? RD_IDLE : RD_DATA;
        endcase
    end

    assign S_AXI_ARREADY = (r_state == RD_IDLE);
    assign S_AXI_RVALID  = (r_state == RD_DATA);
    assign S_AXI_RRESP   = 0;
    
    always_ff @(posedge clk) begin
        if(S_AXI_ARVALID && S_AXI_ARREADY) araddr <= S_AXI_ARADDR;
    end

    // Registers & Sticky Bits
    logic [31:0] regs [0:31]; 
    logic [3:0] done_sticky, err_sticky;
    logic [31:0] rdata;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            done_sticky <= 0; err_sticky <= 0;
            for(int k=0; k<32; k++) regs[k] <= 0;
        end else begin
            // Capture Status
            if(i_ch0_done) done_sticky[0] <= 1; if(i_ch0_err) err_sticky[0] <= 1;
            if(i_ch1_done) done_sticky[1] <= 1; if(i_ch1_err) err_sticky[1] <= 1;
            if(i_ch2_done) done_sticky[2] <= 1; if(i_ch2_err) err_sticky[2] <= 1;
            if(i_ch3_done) done_sticky[3] <= 1; if(i_ch3_err) err_sticky[3] <= 1;

            // Write Logic
            if(wr_en) begin
                regs[awaddr[6:2]] <= S_AXI_WDATA;
                // Clear sticky bits on START write
                if(awaddr[6:2] == 3  && S_AXI_WDATA[0]) begin done_sticky[0] <= 0; err_sticky[0] <= 0; end
                if(awaddr[6:2] == 11 && S_AXI_WDATA[0]) begin done_sticky[1] <= 0; err_sticky[1] <= 0; end
                if(awaddr[6:2] == 19 && S_AXI_WDATA[0]) begin done_sticky[2] <= 0; err_sticky[2] <= 0; end
                if(awaddr[6:2] == 27 && S_AXI_WDATA[0]) begin done_sticky[3] <= 0; err_sticky[3] <= 0; end
            end
        end
    end

    // Connect Internal Regs to Outputs (Fixed Assignments)
    assign o_ch0_src_addr = regs[0];
    assign o_ch0_dest_addr = regs[1];
    assign o_ch0_length = regs[2];
    assign o_ch0_start_pulse = (wr_en && awaddr[6:2] == 3 && S_AXI_WDATA[0]);
    
    assign o_ch1_src_addr = regs[8];
    assign o_ch1_dest_addr = regs[9];
    assign o_ch1_length = regs[10];
    assign o_ch1_start_pulse = (wr_en && awaddr[6:2] == 11 && S_AXI_WDATA[0]);

    assign o_ch2_src_addr = regs[16];
    assign o_ch2_dest_addr = regs[17];
    assign o_ch2_length = regs[18];
    assign o_ch2_start_pulse = (wr_en && awaddr[6:2] == 19 && S_AXI_WDATA[0]);

    assign o_ch3_src_addr = regs[24];
    assign o_ch3_dest_addr = regs[25];
    assign o_ch3_length = regs[26];
    assign o_ch3_start_pulse = (wr_en && awaddr[6:2] == 27 && S_AXI_WDATA[0]);

    // Read Logic (Status Overlay)
    always_comb begin
        rdata = regs[araddr[6:2]];
        if(araddr[6:2] == 4)  rdata = {29'b0, err_sticky[0], done_sticky[0], i_ch0_busy};
        if(araddr[6:2] == 12) rdata = {29'b0, err_sticky[1], done_sticky[1], i_ch1_busy};
        if(araddr[6:2] == 20) rdata = {29'b0, err_sticky[2], done_sticky[2], i_ch2_busy};
        if(araddr[6:2] == 28) rdata = {29'b0, err_sticky[3], done_sticky[3], i_ch3_busy};
    end
    assign S_AXI_RDATA = rdata;

endmodule
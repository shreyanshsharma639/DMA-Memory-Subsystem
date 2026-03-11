`timescale 1ns / 1ps

module dma_arbiter #(
    parameter C_AXI_ID_WIDTH   = 1,
    parameter C_AXI_DATA_WIDTH = 32,
    parameter C_AXI_ADDR_WIDTH = 32
)(
    input  logic clk,
    input  logic rst_n,
    // SLAVE PORTS (Connect to the 4 DMA Channels - Masters)
    // We use arrays for cleaner code: [3:0]

    //Read Address Channel
    input  logic [C_AXI_ID_WIDTH-1:0]   M_AXI_ARID    [3:0],
    input  logic [C_AXI_ADDR_WIDTH-1:0] M_AXI_ARADDR  [3:0],
    input  logic [7:0]                  M_AXI_ARLEN   [3:0],
    input  logic [2:0]                  M_AXI_ARSIZE  [3:0],
    input  logic [1:0]                  M_AXI_ARBURST [3:0],
    input  logic [3:0]                  M_AXI_ARVALID, // 1 bit per ch
    output logic [3:0]                  M_AXI_ARREADY,

    //Read Data Channel
    output logic [C_AXI_ID_WIDTH-1:0]   M_AXI_RID     [3:0],
    output logic [C_AXI_DATA_WIDTH-1:0] M_AXI_RDATA   [3:0],
    output logic [1:0]                  M_AXI_RRESP   [3:0],
    output logic [3:0]                  M_AXI_RLAST,
    output logic [3:0]                  M_AXI_RVALID,
    input  logic [3:0]                  M_AXI_RREADY,

    //Write Address Channel
    input  logic [C_AXI_ID_WIDTH-1:0]   M_AXI_AWID    [3:0],
    input  logic [C_AXI_ADDR_WIDTH-1:0] M_AXI_AWADDR  [3:0],
    input  logic [7:0]                  M_AXI_AWLEN   [3:0],
    input  logic [2:0]                  M_AXI_AWSIZE  [3:0],
    input  logic [1:0]                  M_AXI_AWBURST [3:0],
    input  logic [3:0]                  M_AXI_AWVALID,
    output logic [3:0]                  M_AXI_AWREADY,

    //Write Data Channel
    input  logic [C_AXI_DATA_WIDTH-1:0] M_AXI_WDATA   [3:0],
    input  logic [C_AXI_DATA_WIDTH/8-1:0] M_AXI_WSTRB [3:0],
    input  logic [3:0]                  M_AXI_WLAST,
    input  logic [3:0]                  M_AXI_WVALID,
    output logic [3:0]                  M_AXI_WREADY,

    //Write Response Channel
    output logic [C_AXI_ID_WIDTH-1:0]   M_AXI_BID     [3:0],
    output logic [1:0]                  M_AXI_BRESP   [3:0],
    output logic [3:0]                  M_AXI_BVALID,
    input  logic [3:0]                  M_AXI_BREADY,

    // MASTER PORT (Connects to the Bridge - Slave)
    //Read Address
    output logic [C_AXI_ID_WIDTH-1:0]   S_AXI_ARID,
    output logic [C_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR,
    output logic [7:0]                  S_AXI_ARLEN,
    output logic [2:0]                  S_AXI_ARSIZE,
    output logic [1:0]                  S_AXI_ARBURST,
    output logic                        S_AXI_ARVALID,
    input  logic                        S_AXI_ARREADY,

    //Read Data
    input  logic [C_AXI_ID_WIDTH-1:0]   S_AXI_RID,
    input  logic [C_AXI_DATA_WIDTH-1:0] S_AXI_RDATA,
    input  logic [1:0]                  S_AXI_RRESP,
    input  logic                        S_AXI_RLAST,
    input  logic                        S_AXI_RVALID,
    output logic                        S_AXI_RREADY,

    //Write Address
    output logic [C_AXI_ID_WIDTH-1:0]   S_AXI_AWID,
    output logic [C_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR,
    output logic [7:0]                  S_AXI_AWLEN,
    output logic [2:0]                  S_AXI_AWSIZE,
    output logic [1:0]                  S_AXI_AWBURST,
    output logic                        S_AXI_AWVALID,
    input  logic                        S_AXI_AWREADY,

    //Write Data
    output logic [C_AXI_DATA_WIDTH-1:0] S_AXI_WDATA,
    output logic [C_AXI_DATA_WIDTH/8-1:0] S_AXI_WSTRB,
    output logic                        S_AXI_WLAST,
    output logic                        S_AXI_WVALID,
    input  logic                        S_AXI_WREADY,

    //Write Response
    input  logic [C_AXI_ID_WIDTH-1:0]   S_AXI_BID,
    input  logic [1:0]                  S_AXI_BRESP,
    input  logic                        S_AXI_BVALID,
    output logic                        S_AXI_BREADY
);
    // Internal Signals
    logic [3:0] rd_grant;
    logic [3:0] wr_grant;
    logic [1:0] rd_grant_idx; // 2-bit index (0-3)
    logic [1:0] wr_grant_idx; // 2-bit index (0-3)
    
    logic rd_trans_done;
    logic wr_trans_done;
	
    // 1. Read Arbiter Logic
    assign rd_trans_done = S_AXI_RLAST && S_AXI_RVALID && S_AXI_RREADY;

    rr_arbiter u_read_arb (
        .clk(clk),
        .rst_n(rst_n),
        .req(M_AXI_ARVALID),    
        .trans_done(rd_trans_done),
        .grant(rd_grant),
        .grant_idx(rd_grant_idx)
    );

    //Read MUX (Multiplexer)
    //Route the Winner (rd_grant) to the Slave Port
    always_comb begin
        // Default: Drive 0
        S_AXI_ARID    = '0;
        S_AXI_ARADDR  = '0;
        S_AXI_ARLEN   = '0;
        S_AXI_ARSIZE  = '0;
        S_AXI_ARBURST = '0;
        S_AXI_ARVALID = 1'b0;
        
        if (|rd_grant) begin
            S_AXI_ARID    = M_AXI_ARID[rd_grant_idx];
            S_AXI_ARADDR  = M_AXI_ARADDR[rd_grant_idx];
            S_AXI_ARLEN   = M_AXI_ARLEN[rd_grant_idx];
            S_AXI_ARSIZE  = M_AXI_ARSIZE[rd_grant_idx];
            S_AXI_ARBURST = M_AXI_ARBURST[rd_grant_idx];
            S_AXI_ARVALID = M_AXI_ARVALID[rd_grant_idx];
        end
    end

    always_comb begin
        M_AXI_ARREADY = 4'b0000;
        if (|rd_grant) begin
            M_AXI_ARREADY[rd_grant_idx] = S_AXI_ARREADY;
        end
    end

    always_comb begin
        S_AXI_RREADY = 1'b0; 
        
        for (int i = 0; i < 4; i++) begin
            M_AXI_RID[i]    = S_AXI_RID;
            M_AXI_RDATA[i]  = S_AXI_RDATA;
            M_AXI_RRESP[i]  = S_AXI_RRESP;
            M_AXI_RLAST[i]  = S_AXI_RLAST;
            M_AXI_RVALID[i] = (rd_grant[i]) ? S_AXI_RVALID : 1'b0;
        end

        if (|rd_grant) begin
            S_AXI_RREADY = M_AXI_RREADY[rd_grant_idx];
        end
    end

    // 2. Write Arbiter Logic
    assign wr_trans_done = S_AXI_BVALID && S_AXI_BREADY;

    rr_arbiter u_write_arb (
        .clk(clk),
        .rst_n(rst_n),
        .req(M_AXI_AWVALID),    // Request on Write Address
        .trans_done(wr_trans_done),
        .grant(wr_grant),
        .grant_idx(wr_grant_idx)
    );
    always_comb begin
        S_AXI_AWID    = '0;
        S_AXI_AWADDR  = '0;
        S_AXI_AWLEN   = '0;
        S_AXI_AWSIZE  = '0;
        S_AXI_AWBURST = '0;
        S_AXI_AWVALID = 1'b0;
        
        S_AXI_WDATA   = '0;
        S_AXI_WSTRB   = '0;
        S_AXI_WLAST   = 1'b0;
        S_AXI_WVALID  = 1'b0;

        if (|wr_grant) begin      
            S_AXI_AWID    = M_AXI_AWID[wr_grant_idx];
            S_AXI_AWADDR  = M_AXI_AWADDR[wr_grant_idx];
            S_AXI_AWLEN   = M_AXI_AWLEN[wr_grant_idx];
            S_AXI_AWSIZE  = M_AXI_AWSIZE[wr_grant_idx];
            S_AXI_AWBURST = M_AXI_AWBURST[wr_grant_idx];
            S_AXI_AWVALID = M_AXI_AWVALID[wr_grant_idx];
			
            S_AXI_WDATA   = M_AXI_WDATA[wr_grant_idx];
            S_AXI_WSTRB   = M_AXI_WSTRB[wr_grant_idx];
            S_AXI_WLAST   = M_AXI_WLAST[wr_grant_idx];
            S_AXI_WVALID  = M_AXI_WVALID[wr_grant_idx];
        end
    end
    always_comb begin
        M_AXI_AWREADY = 4'b0000;
        M_AXI_WREADY  = 4'b0000;
        if (|wr_grant) begin
            M_AXI_AWREADY[wr_grant_idx] = S_AXI_AWREADY;
            M_AXI_WREADY[wr_grant_idx]  = S_AXI_WREADY;
        end
    end

    always_comb begin
        S_AXI_BREADY = 1'b0;

        for (int i = 0; i < 4; i++) begin
            M_AXI_BID[i]    = S_AXI_BID;
            M_AXI_BRESP[i]  = S_AXI_BRESP;
            M_AXI_BVALID[i] = (wr_grant[i]) ? S_AXI_BVALID : 1'b0;
        end

        if (|wr_grant) begin
            S_AXI_BREADY = M_AXI_BREADY[wr_grant_idx];
        end
    end

endmodule

// Generic Round Robin Arbiter Module
module rr_arbiter (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [3:0] req,
    input  logic       trans_done,
    output logic [3:0] grant,
    output logic [1:0] grant_idx
);

    typedef enum logic {IDLE, ACTIVE} state_t;
    state_t state, next_state;

    logic [1:0] pointer;     
    logic [1:0] next_pointer;
    logic [3:0] next_grant;
    logic [1:0] next_grant_idx;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) state <= IDLE;
        else       state <= next_state;
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            grant <= 4'b0000;
            grant_idx <= 2'b00;
            pointer <= 2'b00;
        end else begin
            if (state == IDLE && next_state == ACTIVE) begin
                grant <= next_grant;
                grant_idx <= next_grant_idx;
                pointer <= next_pointer; 
            end
            else if (state == ACTIVE && next_state == IDLE) begin
                grant <= 4'b0000;
            end
        end
    end

    always_comb begin
        next_state = state;
        next_grant = 4'b0000;
        next_grant_idx = 2'b00;
        next_pointer = pointer; 

        case(state)
            IDLE: begin
                if (|req) begin
                    next_state = ACTIVE;
                    case(pointer)
                        2'b00: begin 
                            if(req[1])      begin next_grant=4'b0010; next_grant_idx=2'd1; next_pointer=2'd1; end
                            else if(req[2]) begin next_grant=4'b0100; next_grant_idx=2'd2; next_pointer=2'd2; end
                            else if(req[3]) begin next_grant=4'b1000; next_grant_idx=2'd3; next_pointer=2'd3; end
                            else if(req[0]) begin next_grant=4'b0001; next_grant_idx=2'd0; next_pointer=2'd0; end
                        end
                        2'b01: begin 
                            if(req[2])      begin next_grant=4'b0100; next_grant_idx=2'd2; next_pointer=2'd2; end
                            else if(req[3]) begin next_grant=4'b1000; next_grant_idx=2'd3; next_pointer=2'd3; end
                            else if(req[0]) begin next_grant=4'b0001; next_grant_idx=2'd0; next_pointer=2'd0; end
                            else if(req[1]) begin next_grant=4'b0010; next_grant_idx=2'd1; next_pointer=2'd1; end
                        end
                        2'b10: begin 
                            if(req[3])      begin next_grant=4'b1000; next_grant_idx=2'd3; next_pointer=2'd3; end
                            else if(req[0]) begin next_grant=4'b0001; next_grant_idx=2'd0; next_pointer=2'd0; end
                            else if(req[1]) begin next_grant=4'b0010; next_grant_idx=2'd1; next_pointer=2'd1; end
                            else if(req[2]) begin next_grant=4'b0100; next_grant_idx=2'd2; next_pointer=2'd2; end
                        end
                        2'b11: begin 
                            if(req[0])      begin next_grant=4'b0001; next_grant_idx=2'd0; next_pointer=2'd0; end
                            else if(req[1]) begin next_grant=4'b0010; next_grant_idx=2'd1; next_pointer=2'd1; end
                            else if(req[2]) begin next_grant=4'b0100; next_grant_idx=2'd2; next_pointer=2'd2; end
                            else if(req[3]) begin next_grant=4'b1000; next_grant_idx=2'd3; next_pointer=2'd3; end
                        end
                    endcase
                end
            end

            ACTIVE: begin
                if (trans_done) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule
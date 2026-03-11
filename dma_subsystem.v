`timescale 1ns / 1ps

module dma_subsystem #(
    parameter C_S_AXI_LITE_DATA_WIDTH = 32,
    parameter C_S_AXI_LITE_ADDR_WIDTH = 7,
    parameter SRAM_LATENCY            = 7 
)(
    input  logic clk,
    input  logic rst_n,

    input  logic [C_S_AXI_LITE_ADDR_WIDTH-1:0]  S_AXI_LITE_AWADDR,
    input  logic                                S_AXI_LITE_AWVALID,
    output logic                                S_AXI_LITE_AWREADY,
    input  logic [C_S_AXI_LITE_DATA_WIDTH-1:0]  S_AXI_LITE_WDATA,
    input  logic [C_S_AXI_LITE_DATA_WIDTH/8-1:0]S_AXI_LITE_WSTRB,
    input  logic                                S_AXI_LITE_WVALID,
    output logic                                S_AXI_LITE_WREADY,
    output logic [1:0]                          S_AXI_LITE_BRESP,
    output logic                                S_AXI_LITE_BVALID,
    input  logic                                S_AXI_LITE_BREADY,
    input  logic [C_S_AXI_LITE_ADDR_WIDTH-1:0]  S_AXI_LITE_ARADDR,
    input  logic                                S_AXI_LITE_ARVALID,
    output logic                                S_AXI_LITE_ARREADY,
    output logic [C_S_AXI_LITE_DATA_WIDTH-1:0]  S_AXI_LITE_RDATA,
    output logic [1:0]                          S_AXI_LITE_RRESP,
    output logic                                S_AXI_LITE_RVALID,
    input  logic                                S_AXI_LITE_RREADY,

    output logic irq
);

    logic [31:0] ch_src[3:0], ch_dest[3:0], ch_len[3:0];
    logic        ch_start[3:0], ch_busy[3:0], ch_done[3:0], ch_err[3:0];

    logic [0:0]  m_arid[3:0];    logic [31:0] m_araddr[3:0];
    logic [7:0]  m_arlen[3:0];   logic [2:0]  m_arsize[3:0];
    logic [1:0]  m_arburst[3:0]; 

    logic [3:0]  m_arvalid;   
    logic [3:0]  m_arready;

    logic [0:0]  m_rid[3:0];     logic [31:0] m_rdata[3:0];
    logic [1:0]  m_rresp[3:0];   
    
    logic [3:0]  m_rlast;     
    logic [3:0]  m_rvalid;    
    logic [3:0]  m_rready;
    
    logic [0:0]  m_awid[3:0];    logic [31:0] m_awaddr[3:0];
    logic [7:0]  m_awlen[3:0];   logic [2:0]  m_awsize[3:0];
    logic [1:0]  m_awburst[3:0]; 
    
    logic [3:0]  m_awvalid;   
    logic [3:0]  m_awready;
    
    logic [31:0] m_wdata[3:0];   logic [3:0]  m_wstrb[3:0];
    
    logic [3:0]  m_wlast;      
    logic [3:0]  m_wvalid;    
    logic [3:0]  m_wready;
    
    logic [0:0]  m_bid[3:0];     logic [1:0]  m_bresp[3:0];  
    logic [3:0]  m_bvalid;    
    logic [3:0]  m_bready;

    // AXI Slave (Arbiter -> Bridge)
    logic [0:0] s_arid;   logic [31:0] s_araddr; logic [7:0] s_arlen;
    logic [2:0] s_arsize; logic [1:0] s_arburst; logic s_arvalid; logic s_arready;
    logic [0:0] s_rid;    logic [31:0] s_rdata;  logic [1:0] s_rresp;
    logic s_rlast;        logic s_rvalid;        logic s_rready;
    
    logic [0:0] s_awid;   logic [31:0] s_awaddr; logic [7:0] s_awlen;
    logic [2:0] s_awsize; logic [1:0] s_awburst; logic s_awvalid; logic s_awready;
    logic [31:0] s_wdata; logic [3:0] s_wstrb;
    logic s_wlast;        logic s_wvalid;        logic s_wready;
    logic [0:0] s_bid;    logic [1:0] s_bresp;   logic s_bvalid;  logic s_bready;

    // SRAM Interface
    logic [14:0] mem_addr; logic [31:0] mem_din, mem_dout;
    logic mem_ce_n, mem_we_n;

    // MODULE 1: Control
    dma_axil_slave #(.C_S_AXI_DATA_WIDTH(32), .C_S_AXI_ADDR_WIDTH(7)) u_ctrl (
        .clk(clk), .rst_n(rst_n),
        .S_AXI_AWADDR(S_AXI_LITE_AWADDR), .S_AXI_AWVALID(S_AXI_LITE_AWVALID), .S_AXI_AWREADY(S_AXI_LITE_AWREADY),
        .S_AXI_WDATA(S_AXI_LITE_WDATA), .S_AXI_WSTRB(S_AXI_LITE_WSTRB), .S_AXI_WVALID(S_AXI_LITE_WVALID), .S_AXI_WREADY(S_AXI_LITE_WREADY),
        .S_AXI_BVALID(S_AXI_LITE_BVALID), .S_AXI_BRESP(S_AXI_LITE_BRESP), .S_AXI_BREADY(S_AXI_LITE_BREADY),
        .S_AXI_ARADDR(S_AXI_LITE_ARADDR), .S_AXI_ARVALID(S_AXI_LITE_ARVALID), .S_AXI_ARREADY(S_AXI_LITE_ARREADY),
        .S_AXI_RDATA(S_AXI_LITE_RDATA), .S_AXI_RRESP(S_AXI_LITE_RRESP), .S_AXI_RVALID(S_AXI_LITE_RVALID), .S_AXI_RREADY(S_AXI_LITE_RREADY),
        
        .o_ch0_src_addr(ch_src[0]), .o_ch0_dest_addr(ch_dest[0]), .o_ch0_length(ch_len[0]), .o_ch0_start_pulse(ch_start[0]),
        .i_ch0_busy(ch_busy[0]), .i_ch0_done(ch_done[0]), .i_ch0_err(ch_err[0]),
        .o_ch1_src_addr(ch_src[1]), .o_ch1_dest_addr(ch_dest[1]), .o_ch1_length(ch_len[1]), .o_ch1_start_pulse(ch_start[1]),
        .i_ch1_busy(ch_busy[1]), .i_ch1_done(ch_done[1]), .i_ch1_err(ch_err[1]),
        .o_ch2_src_addr(ch_src[2]), .o_ch2_dest_addr(ch_dest[2]), .o_ch2_length(ch_len[2]), .o_ch2_start_pulse(ch_start[2]),
        .i_ch2_busy(ch_busy[2]), .i_ch2_done(ch_done[2]), .i_ch2_err(ch_err[2]),
        .o_ch3_src_addr(ch_src[3]), .o_ch3_dest_addr(ch_dest[3]), .o_ch3_length(ch_len[3]), .o_ch3_start_pulse(ch_start[3]),
        .i_ch3_busy(ch_busy[3]), .i_ch3_done(ch_done[3]), .i_ch3_err(ch_err[3])
    );

    // MODULE 2: DMA Channels
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : CH
            dma_channel #(.C_M_AXI_ID_WIDTH(1), .C_M_AXI_DATA_WIDTH(32), .C_M_AXI_ADDR_WIDTH(32), .FIFO_DEPTH(16)) u_ch (
                .clk(clk), .rst_n(rst_n),
                .start(ch_start[i]), .src_addr(ch_src[i]), .dest_addr(ch_dest[i]), .length_bytes(ch_len[i]),
                .busy(ch_busy[i]), .done(ch_done[i]), .error(ch_err[i]),
                
                .M_AXI_ARID(m_arid[i]), .M_AXI_ARADDR(m_araddr[i]), .M_AXI_ARLEN(m_arlen[i]), .M_AXI_ARSIZE(m_arsize[i]), .M_AXI_ARBURST(m_arburst[i]), 
                .M_AXI_ARVALID(m_arvalid[i]), .M_AXI_ARREADY(m_arready[i]), // Bit Select
                
                .M_AXI_RID(m_rid[i]), .M_AXI_RDATA(m_rdata[i]), .M_AXI_RRESP(m_rresp[i]),
                .M_AXI_RLAST(m_rlast[i]), .M_AXI_RVALID(m_rvalid[i]), .M_AXI_RREADY(m_rready[i]),
                
                .M_AXI_AWID(m_awid[i]), .M_AXI_AWADDR(m_awaddr[i]), .M_AXI_AWLEN(m_awlen[i]), .M_AXI_AWSIZE(m_awsize[i]), .M_AXI_AWBURST(m_awburst[i]),
                .M_AXI_AWVALID(m_awvalid[i]), .M_AXI_AWREADY(m_awready[i]),
                
                .M_AXI_WDATA(m_wdata[i]), .M_AXI_WSTRB(m_wstrb[i]), 
                .M_AXI_WLAST(m_wlast[i]), .M_AXI_WVALID(m_wvalid[i]), .M_AXI_WREADY(m_wready[i]),
                
                .M_AXI_BID(m_bid[i]), .M_AXI_BRESP(m_bresp[i]), 
                .M_AXI_BVALID(m_bvalid[i]), .M_AXI_BREADY(m_bready[i])
            );
        end
    endgenerate

    // MODULE 3: Arbiter
    dma_arbiter #(.C_AXI_ID_WIDTH(1), .C_AXI_DATA_WIDTH(32), .C_AXI_ADDR_WIDTH(32)) u_arb (
        .clk(clk), .rst_n(rst_n),
        .M_AXI_ARID(m_arid), .M_AXI_ARADDR(m_araddr), .M_AXI_ARLEN(m_arlen), .M_AXI_ARSIZE(m_arsize), .M_AXI_ARBURST(m_arburst), 
        .M_AXI_ARVALID(m_arvalid), .M_AXI_ARREADY(m_arready),
        
        .M_AXI_RID(m_rid), .M_AXI_RDATA(m_rdata), .M_AXI_RRESP(m_rresp), 
        .M_AXI_RLAST(m_rlast), .M_AXI_RVALID(m_rvalid), .M_AXI_RREADY(m_rready),
        
        .M_AXI_AWID(m_awid), .M_AXI_AWADDR(m_awaddr), .M_AXI_AWLEN(m_awlen), .M_AXI_AWSIZE(m_awsize), .M_AXI_AWBURST(m_awburst), 
        .M_AXI_AWVALID(m_awvalid), .M_AXI_AWREADY(m_awready),
        
        .M_AXI_WDATA(m_wdata), .M_AXI_WSTRB(m_wstrb), 
        .M_AXI_WLAST(m_wlast), .M_AXI_WVALID(m_wvalid), .M_AXI_WREADY(m_wready),
        
        .M_AXI_BID(m_bid), .M_AXI_BRESP(m_bresp), 
        .M_AXI_BVALID(m_bvalid), .M_AXI_BREADY(m_bready),

        .S_AXI_ARID(s_arid), .S_AXI_ARADDR(s_araddr), .S_AXI_ARLEN(s_arlen), .S_AXI_ARSIZE(s_arsize), .S_AXI_ARBURST(s_arburst), .S_AXI_ARVALID(s_arvalid), .S_AXI_ARREADY(s_arready),
        .S_AXI_RID(s_rid), .S_AXI_RDATA(s_rdata), .S_AXI_RRESP(s_rresp), .S_AXI_RLAST(s_rlast), .S_AXI_RVALID(s_rvalid), .S_AXI_RREADY(s_rready),
        .S_AXI_AWID(s_awid), .S_AXI_AWADDR(s_awaddr), .S_AXI_AWLEN(s_awlen), .S_AXI_AWSIZE(s_awsize), .S_AXI_AWBURST(s_awburst), .S_AXI_AWVALID(s_awvalid), .S_AXI_AWREADY(s_awready),
        .S_AXI_WDATA(s_wdata), .S_AXI_WSTRB(s_wstrb), .S_AXI_WLAST(s_wlast), .S_AXI_WVALID(s_wvalid), .S_AXI_WREADY(s_wready),
        .S_AXI_BID(s_bid), .S_AXI_BRESP(s_bresp), .S_AXI_BVALID(s_bvalid), .S_AXI_BREADY(s_bready)
    );

    // MODULE 4: Bridge
    axi_to_sram_bridge #(
        .C_S_AXI_ID_WIDTH(1), 
        .C_S_AXI_DATA_WIDTH(32), 
        .C_S_AXI_ADDR_WIDTH(32), 
        .FIFO_DEPTH(16), 
        .SRAM_LATENCY(SRAM_LATENCY) 
    ) u_bridge (
        .clk(clk), .rst_n(rst_n),
        .S_AXI_ARID(s_arid), .S_AXI_ARADDR(s_araddr), .S_AXI_ARLEN(s_arlen), .S_AXI_ARSIZE(s_arsize), .S_AXI_ARBURST(s_arburst), .S_AXI_ARVALID(s_arvalid), .S_AXI_ARREADY(s_arready),
        .S_AXI_RID(s_rid), .S_AXI_RDATA(s_rdata), .S_AXI_RRESP(s_rresp), .S_AXI_RLAST(s_rlast), .S_AXI_RVALID(s_rvalid), .S_AXI_RREADY(s_rready),
        .S_AXI_AWID(s_awid), .S_AXI_AWADDR(s_awaddr), .S_AXI_AWLEN(s_awlen), .S_AXI_AWSIZE(s_awsize), .S_AXI_AWBURST(s_awburst), .S_AXI_AWVALID(s_awvalid), .S_AXI_AWREADY(s_awready),
        .S_AXI_WDATA(s_wdata), .S_AXI_WSTRB(s_wstrb), .S_AXI_WLAST(s_wlast), .S_AXI_WVALID(s_wvalid), .S_AXI_WREADY(s_wready),
        .S_AXI_BID(s_bid), .S_AXI_BRESP(s_bresp), .S_AXI_BVALID(s_bvalid), .S_AXI_BREADY(s_bready),
        .sram_addr(mem_addr), .sram_din(mem_din), .sram_dout(mem_dout), .sram_ce_n(mem_ce_n), .sram_we_n(mem_we_n)
    );

    // MODULE 5: Memory
    sram_top u_sram (
        .clk(clk), .rst_n(rst_n),
        .addr(mem_addr), .din(mem_din), .dout(mem_dout), .ce_n(mem_ce_n), .we_n(mem_we_n)
    );

    assign irq = ch_done[0] | ch_done[1] | ch_done[2] | ch_done[3];

endmodule
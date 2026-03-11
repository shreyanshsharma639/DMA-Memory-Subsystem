`timescale 1ns / 1ps

module tb_dma_subsystem;

    localparam C_S_AXI_LITE_DATA_WIDTH = 32;
    localparam C_S_AXI_LITE_ADDR_WIDTH = 7;
    localparam CLK_PERIOD              = 10;

    logic clk;
    logic rst_n;
    logic irq;

    logic [C_S_AXI_LITE_ADDR_WIDTH-1:0]  S_AXI_LITE_AWADDR;
    logic                                S_AXI_LITE_AWVALID;
    logic                                S_AXI_LITE_AWREADY;
    logic [C_S_AXI_LITE_DATA_WIDTH-1:0]  S_AXI_LITE_WDATA;
    logic [C_S_AXI_LITE_DATA_WIDTH/8-1:0]S_AXI_LITE_WSTRB;
    logic                                S_AXI_LITE_WVALID;
    logic                                S_AXI_LITE_WREADY;
    logic [1:0]                          S_AXI_LITE_BRESP;
    logic                                S_AXI_LITE_BVALID;
    logic                                S_AXI_LITE_BREADY;
    logic [C_S_AXI_LITE_ADDR_WIDTH-1:0]  S_AXI_LITE_ARADDR;
    logic                                S_AXI_LITE_ARVALID;
    logic                                S_AXI_LITE_ARREADY;
    logic [C_S_AXI_LITE_DATA_WIDTH-1:0]  S_AXI_LITE_RDATA;
    logic [1:0]                          S_AXI_LITE_RRESP;
    logic                                S_AXI_LITE_RVALID;
    logic                                S_AXI_LITE_RREADY;

    dma_subsystem u_dut (
        .clk(clk), .rst_n(rst_n), .irq(irq),
        .S_AXI_LITE_AWADDR(S_AXI_LITE_AWADDR), .S_AXI_LITE_AWVALID(S_AXI_LITE_AWVALID), .S_AXI_LITE_AWREADY(S_AXI_LITE_AWREADY),
        .S_AXI_LITE_WDATA(S_AXI_LITE_WDATA), .S_AXI_LITE_WSTRB(S_AXI_LITE_WSTRB), .S_AXI_LITE_WVALID(S_AXI_LITE_WVALID), .S_AXI_LITE_WREADY(S_AXI_LITE_WREADY),
        .S_AXI_LITE_BRESP(S_AXI_LITE_BRESP), .S_AXI_LITE_BVALID(S_AXI_LITE_BVALID), .S_AXI_LITE_BREADY(S_AXI_LITE_BREADY),
        .S_AXI_LITE_ARADDR(S_AXI_LITE_ARADDR), .S_AXI_LITE_ARVALID(S_AXI_LITE_ARVALID), .S_AXI_LITE_ARREADY(S_AXI_LITE_ARREADY),
        .S_AXI_LITE_RDATA(S_AXI_LITE_RDATA), .S_AXI_LITE_RRESP(S_AXI_LITE_RRESP), .S_AXI_LITE_RVALID(S_AXI_LITE_RVALID), .S_AXI_LITE_RREADY(S_AXI_LITE_RREADY)
    );

    always begin clk = 0; #(CLK_PERIOD/2); clk = 1; #(CLK_PERIOD/2); end

    task axi_reg_write(input [6:0] addr, input [31:0] data);
        begin
            @(posedge clk);
            S_AXI_LITE_AWADDR <= addr; S_AXI_LITE_AWVALID <= 1;
            S_AXI_LITE_WDATA <= data; S_AXI_LITE_WSTRB <= 4'hF; S_AXI_LITE_WVALID <= 1; S_AXI_LITE_BREADY <= 1;
            fork
                begin do @(posedge clk); while (!S_AXI_LITE_AWREADY); S_AXI_LITE_AWVALID <= 0; end
                begin do @(posedge clk); while (!S_AXI_LITE_WREADY); S_AXI_LITE_WVALID <= 0; end
            join
            do @(posedge clk); while (!S_AXI_LITE_BVALID); S_AXI_LITE_BREADY <= 0;
        end
    endtask

    task backdoor_write_word(input [31:0] byte_addr, input [31:0] data);
        logic [14:0] word_addr; integer bank, row, col;
        begin
            word_addr = byte_addr[16:2]; bank = word_addr[14:11]; row = word_addr[10:3]; col = word_addr[2:0];
            if (bank == 0) u_dut.u_sram.BANK_GEN[0].bank_inst.memory_array[row][col] = data;
            else if (bank == 1) u_dut.u_sram.BANK_GEN[1].bank_inst.memory_array[row][col] = data;
        end
    endtask

    task backdoor_check_word(input [31:0] byte_addr, input [31:0] expected_data);
        logic [14:0] word_addr; integer bank, row, col; logic [31:0] actual;
        begin
            word_addr = byte_addr[16:2]; bank = word_addr[14:11]; row = word_addr[10:3]; col = word_addr[2:0];
            if (bank == 0) actual = u_dut.u_sram.BANK_GEN[0].bank_inst.memory_array[row][col];
            else if (bank == 1) actual = u_dut.u_sram.BANK_GEN[1].bank_inst.memory_array[row][col];
            else actual = 32'hDEADDEAD;

            if (actual === expected_data) $display("[PASS] Addr 0x%h contains 0x%h", byte_addr, actual);
            else $display("[FAIL] Addr 0x%h. Exp: 0x%h, Got: 0x%h", byte_addr, expected_data, actual);
        end
    endtask

    task force_sram_active();
        integer i;
        begin
            $display("[TB] Forcing SRAM Banks to ACTIVE State...");
            for (i = 0; i < 16; i = i + 1) begin
                u_dut.u_sram.u_pmu.current_state[i] = 2'b10; // ACTIVE
            end
            #10; 
        end
    endtask

    initial begin
        S_AXI_LITE_AWVALID = 0; S_AXI_LITE_WVALID = 0; S_AXI_LITE_BREADY = 0;
        S_AXI_LITE_ARVALID = 0; S_AXI_LITE_RREADY = 0;
        rst_n = 0; #100; rst_n = 1; #100;

        $display("---------------------------------------------");
        $display(" STARTING FULL DMA SYSTEM VERIFICATION");
        $display("---------------------------------------------");

        force_sram_active();

        $display("[TB] Pre-loading SRAM Source Data...");
        backdoor_write_word(32'h0000_1000, 32'hAABB_CCDD);
        backdoor_write_word(32'h0000_1004, 32'h1122_3344);
        backdoor_write_word(32'h0000_1008, 32'h5566_7788);
        backdoor_write_word(32'h0000_100C, 32'h99AA_BBCC);
        backdoor_write_word(32'h0000_2000, 32'h0000_0000);

        $display("[TB] Configuring Channel 0...");
        axi_reg_write(7'h00, 32'h0000_1000);
        axi_reg_write(7'h04, 32'h0000_2000);
        axi_reg_write(7'h08, 32'd16);
        
        $display("[TB] Starting Channel 0...");
        axi_reg_write(7'h0C, 32'h0000_0001);

        $display("[TB] Waiting for Interrupt...");
        fork
            begin wait(irq == 1); $display("[TB] Interrupt Received!"); end
            begin #30000; $display("[TB] TIMEOUT!"); $finish; end
        join_any
        disable fork;

        $display("[TB] Verifying Destination Data...");
        #100;
        backdoor_check_word(32'h0000_2000, 32'hAABB_CCDD);
        backdoor_check_word(32'h0000_2004, 32'h1122_3344);
        backdoor_check_word(32'h0000_2008, 32'h5566_7788);
        backdoor_check_word(32'h0000_200C, 32'h99AA_BBCC);
        
        #500;
        $display("---------------------------------------------");
        $display(" SYSTEM TEST FINISHED");
        $display("---------------------------------------------");
        $finish;
    end
endmodule
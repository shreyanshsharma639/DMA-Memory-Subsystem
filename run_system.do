vlib work 
vdel -all
vlib work 

vlog -sv controller.v +acc
vlog -sv power_management_unit.v +acc

vlog -sv memory_bank_2.v +acc
vlog -sv sram_top2.v +acc 

vlog -sv dma_axil_slave.v +acc 
vlog -sv axi_to_sram_bridge.v +acc 
vlog -sv dma_channel.v +acc 
vlog -sv dma_arbiter.v +acc 

vlog -sv dma_subsystem.v +acc 
vlog -sv dma_subsystem_tb.v +acc 


vsim work.tb_dma_subsystem 

add wave -divider {System Status}
add wave -radix binary /tb_dma_subsystem/clk
add wave -radix binary /tb_dma_subsystem/rst_n
add wave -radix binary /tb_dma_subsystem/irq

# Group 2: CPU/Control Interface (AXI-Lite)
add wave -divider {AXI-Lite Control}
add wave -radix hex /tb_dma_subsystem/S_AXI_LITE_AWADDR
add wave -radix hex /tb_dma_subsystem/S_AXI_LITE_WDATA
add wave -radix binary /tb_dma_subsystem/S_AXI_LITE_WVALID
add wave -radix binary /tb_dma_subsystem/S_AXI_LITE_WREADY
add wave -radix binary /tb_dma_subsystem/S_AXI_LITE_BVALID

# Group 3: Channel 0 Internal Status (The one we are testing)
add wave -divider {Channel 0 Status}
add wave -radix hex /tb_dma_subsystem/u_dut/u_ctrl/o_ch0_src_addr
add wave -radix hex /tb_dma_subsystem/u_dut/u_ctrl/o_ch0_dest_addr
add wave -radix hex /tb_dma_subsystem/u_dut/u_ctrl/o_ch0_length
add wave -radix binary /tb_dma_subsystem/u_dut/u_ctrl/o_ch0_start_pulse
add wave -radix binary /tb_dma_subsystem/u_dut/u_ctrl/i_ch0_busy
add wave -radix binary /tb_dma_subsystem/u_dut/u_ctrl/i_ch0_done

# Group 4: Arbiter Activity (Who has the bus?)
add wave -divider {Arbiter Grants}
add wave -radix binary /tb_dma_subsystem/u_dut/u_arb/u_read_arb/grant
add wave -radix binary /tb_dma_subsystem/u_dut/u_arb/u_write_arb/grant

# Group 5: Memory Interface (The final destination)
add wave -divider {SRAM Interface}
add wave -radix hex /tb_dma_subsystem/u_dut/u_bridge/sram_addr
add wave -radix hex /tb_dma_subsystem/u_dut/u_bridge/sram_din
add wave -radix hex /tb_dma_subsystem/u_dut/u_bridge/sram_dout
add wave -radix binary /tb_dma_subsystem/u_dut/u_bridge/sram_ce_n
add wave -radix binary /tb_dma_subsystem/u_dut/u_bridge/sram_we_n

# 5. Configure and Run
configure wave -namecolwidth 300
configure wave -valuecolwidth 100
run -all
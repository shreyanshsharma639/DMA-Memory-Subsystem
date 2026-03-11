DMA + Memory Subsystem
Project Overview
This project implements a high efficiency hardware subsystem designed for rapid data movement and power optimization. It features a 4 Channel DMA (Direct Memory Access) controller integrated with a custom designed 1MB eDRAM memory array.
The primary objective is to demonstrate high performance autonomous data orchestration. By offloading data transfer tasks from the main processor, the system increases overall SoC (System on Chip) throughput while utilizing advanced power gating and arbitration techniques to maintain a minimal energy footprint.
The Role of DMA in Modern Systems
In standard architectures, the CPU is often bottlenecked by moving data between peripherals and memory. This is a suboptimal use of high performance compute resources.
	•	Efficiency: A DMA acts as a secondary processor dedicated solely to data transport.
	•	Autonomy: The CPU provides the "What" (source, destination, size), and the DMA handles the "How" (bus handshaking, burst management).
	•	Parallelism: While the DMA is populating memory buffers, the CPU can concurrently execute complex application logic.
Technical Novelty: 1MB Custom Low Power eDRAM
The core innovation of this design is the custom 1MB eDRAM (Embedded DRAM) subsystem, engineered to replace standard generic SRAM with a more density efficient and power aware architecture.
Banked Memory Architecture
The 1MB memory space is partitioned into 16 independent 64KB banks.
	•	Throughput Optimization: Unlike monolithic memory, a banked structure allows for concurrent operations. For example, the system can perform a Precharge on Bank 0 while simultaneously accessing data in Bank 5.
	•	Conflict Reduction: By distributing data across banks, the design minimizes Row Address Strobe (RAS) conflicts, ensuring the DMA engines maintain maximum bus occupancy.
Physical Timing Control
The custom memory controller manages the physical characteristics of the DRAM cells through deterministic hardware cycles:
	•	Precharge: 2 Cycles (Preparing the internal bitlines for a new access)
	•	Decode: 1 Cycle (Activates the specific row selection logic)
	•	Access: 3 Cycles (Stabilizes data for reliable sensing and latching)
Predictive Power Management (PMU)
The Power Management Unit serves as the "intelligent controller" for energy conservation.
	•	Anticipatory Wakeup: The PMU monitors the DMA Arbiter's grant signals. It identifies which bank is targeted for an upcoming transfer and initiates a 50 cycle wakeup sequence from Deep Sleep before the data arrives.
	•	Leakage Mitigation: By holding inactive banks in a low leakage Standby or Deep Sleep state, the design drastically reduces the static power footprint without a performance penalty.
Architectural Breakdown
4 Channel Concurrent DMA Methodology
The system employs four independent DMA channels to support high degree parallelism.
	•	Why 4 Channels? This configuration allows the system to manage multiple data streams simultaneously.
	•	FIFO Architecture: Each channel is equipped with a 16 word synchronous FIFO buffer. These buffers act as "shock absorbers" that decouple the high speed AXI bus from the specific timing requirements of the eDRAM.
	•	Trade offs: 4 channels were selected as the optimal balance between high concurrency and area efficiency on the Virtex 7 fabric.
Round Robin Arbitration
To resolve bus contention when multiple channels request memory access, a Round Robin Arbiter is implemented.
	•	Fairness: Every channel is guaranteed a slot in the rotation, preventing any single high bandwidth task from "starving" other channels.
	•	Dynamic Priority: The arbiter tracks the "Last Served" channel and shifts priority in a circular fashion.
AXI Protocol Implementation
	•	AXI Lite Slave (Control Plane): A lightweight interface used by the CPU for register configuration (Src, Dest, Length).
	•	AXI 4 Full Master (Data Plane): The high speed "highway" for data movement. Supports Burst Mode to maximize effective bandwidth.
Implementation Results
The design was fully implemented and routed on a Xilinx Virtex 7 (7v585tffg1157-3) FPGA using Vivado 2025.2.
Timing Summary (100 MHz Target)
Metric
Value
Worst Negative Slack (WNS)
6.149 ns
Worst Hold Slack (WHS)
0.087 ns
Total Endpoints
1,856
Theoretical Max Frequency
~260.3 MHz
Power Analysis (Post Route)
Component
Power (W)
Total On Chip Power
0.258 W
Static/Leakage Power
0.243 W
Dynamic Logic Power
0.015 W
Clock and Resource Utilization
Resource Type
Used
Available
Utilization %
Slice LUTs
1,272
364,200
0.35%
Registers
1,399
728,400
0.19%
Global Clock Buffers
1
32
3.13%
Visual Documentation
System Schematic
Power Breakdown
Simulation Waveforms
Key Takeaways
	1	High Efficiency: Total system power consumption is limited to 0.258W.
	2	Timing Excellence: A 6.149ns positive slack ensures immunity to hardware delays and environmental variations.
	3	Advanced RMW: Supports sub word AXI writes without data corruption via an integrated Read Modify Write cycle.
	4	Scalable Logic: The modular 4 channel design can be easily expanded for higher performance requirements.
How to Run
	1	Open Xilinx Vivado.
	2	Add all files in the /rtl directory and the testbench in /tb.
	3	Load the constraints/top_constraints.xdc file.
	4	Execute Synthesis and Implementation to generate the full hardware reports.
If you've made it this far and still don't understand what's happening, don't worry — most people just look at the blinking lights on the FPGA anyway.

{\rtf1\ansi\ansicpg1252\cocoartf2868
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica-Bold;\f1\froman\fcharset0 Times-Bold;\f2\fswiss\fcharset0 Helvetica;
\f3\froman\fcharset0 Times-Roman;\f4\fswiss\fcharset0 ArialMT;}
{\colortbl;\red255\green255\blue255;\red24\green24\blue24;\red0\green0\blue0;\red246\green249\blue252;
}
{\*\expandedcolortbl;;\cssrgb\c12157\c12157\c12157;\cssrgb\c0\c0\c0;\cssrgb\c97255\c98039\c99216;
}
{\*\listtable{\list\listtemplateid1\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat0\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid1\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid1}
{\list\listtemplateid2\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat0\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid101\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid2}
{\list\listtemplateid3\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat0\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid201\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid3}
{\list\listtemplateid4\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat0\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid301\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid4}
{\list\listtemplateid5\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat0\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid401\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid5}
{\list\listtemplateid6\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat0\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid501\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid6}
{\list\listtemplateid7\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat0\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid601\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid7}
{\list\listtemplateid8\listhybrid{\listlevel\levelnfc0\levelnfcn0\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{decimal\}}{\leveltext\leveltemplateid701\'01\'00;}{\levelnumbers\'01;}\fi-360\li720\lin720 }{\listname ;}\listid8}
{\list\listtemplateid9\listhybrid{\listlevel\levelnfc0\levelnfcn0\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{decimal\}}{\leveltext\leveltemplateid801\'01\'00;}{\levelnumbers\'01;}\fi-360\li720\lin720 }{\listname ;}\listid9}}
{\*\listoverridetable{\listoverride\listid1\listoverridecount0\ls1}{\listoverride\listid2\listoverridecount0\ls2}{\listoverride\listid3\listoverridecount0\ls3}{\listoverride\listid4\listoverridecount0\ls4}{\listoverride\listid5\listoverridecount0\ls5}{\listoverride\listid6\listoverridecount0\ls6}{\listoverride\listid7\listoverridecount0\ls7}{\listoverride\listid8\listoverridecount0\ls8}{\listoverride\listid9\listoverridecount0\ls9}}
\paperw11900\paperh16840\margl1440\margr1440\vieww25400\viewh16060\viewkind0
\deftab720
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs64 \cf2 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 DMA + Memory Subsystem
\f1\fs48 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f0 \cf2 \strokec2 Project Overview
\f1\fs36 \cf0 \strokec3 \
\pard\pardeftab720\sa320\partightenfactor0

\f2\b0\fs29\fsmilli14667 \cf2 \strokec2 This project implements a high efficiency hardware subsystem designed for rapid data movement and power optimization. It features a 4 Channel DMA (Direct Memory Access) controller integrated with a custom designed 1MB eDRAM memory array.
\f3\fs24 \cf0 \strokec3 \

\f2\fs29\fsmilli14667 \cf2 \strokec2 The primary objective is to demonstrate high performance autonomous data orchestration. By offloading data transfer tasks from the main processor, the system increases overall SoC (System on Chip) throughput while utilizing advanced power gating and arbitration techniques to maintain a minimal energy footprint.
\f3\fs24 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs37\fsmilli18667 \cf2 \strokec2 The Role of DMA in Modern Systems
\f1\fs28 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f2\b0\fs29\fsmilli14667 \cf2 \strokec2 In standard architectures, the CPU is often bottlenecked by moving data between peripherals and memory. This is a suboptimal use of high performance compute resources.
\f3\fs24 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls1\ilvl0
\f2\fs29\fsmilli14667 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Efficiency: A DMA acts as a secondary processor dedicated solely to data transport.
\f4 \cf0 \strokec3 \
\ls1\ilvl0
\f2 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Autonomy: The CPU provides the "What" (source, destination, size), and the DMA handles the "How" (bus handshaking, burst management).
\f4 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa160\partightenfactor0
\ls1\ilvl0
\f2 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Parallelism: While the DMA is populating memory buffers, the CPU can concurrently execute complex application logic.
\f4 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs48 \cf2 \strokec2 Technical Novelty: 1MB Custom Low Power eDRAM
\f1\fs36 \cf0 \strokec3 \
\pard\pardeftab720\sa320\partightenfactor0

\f2\b0\fs29\fsmilli14667 \cf2 \strokec2 The core innovation of this design is the custom 1MB eDRAM (Embedded DRAM) subsystem, engineered to replace standard generic SRAM with a more density efficient and power aware architecture.
\f3\fs24 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs37\fsmilli18667 \cf2 \strokec2 Banked Memory Architecture
\f1\fs28 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f2\b0\fs29\fsmilli14667 \cf2 \strokec2 The 1MB memory space is partitioned into 16 independent 64KB banks.
\f3\fs24 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls2\ilvl0
\f2\fs29\fsmilli14667 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Throughput Optimization: Unlike monolithic memory, a banked structure allows for concurrent operations. For example, the system can perform a Precharge on Bank 0 while simultaneously accessing data in Bank 5.
\f4 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa160\partightenfactor0
\ls2\ilvl0
\f2 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Conflict Reduction: By distributing data across banks, the design minimizes Row Address Strobe (RAS) conflicts, ensuring the DMA engines maintain maximum bus occupancy.
\f4 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs37\fsmilli18667 \cf2 \strokec2 Physical Timing Control
\f1\fs28 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f2\b0\fs29\fsmilli14667 \cf2 \strokec2 The custom memory controller manages the physical characteristics of the DRAM cells through deterministic hardware cycles:
\f3\fs24 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls3\ilvl0
\f2\fs29\fsmilli14667 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Precharge: 2 Cycles (Preparing the internal bitlines for a new access)
\f4 \cf0 \strokec3 \
\ls3\ilvl0
\f2 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Decode: 1 Cycle (Activates the specific row selection logic)
\f4 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa160\partightenfactor0
\ls3\ilvl0
\f2 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Access: 3 Cycles (Stabilizes data for reliable sensing and latching)
\f4 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs37\fsmilli18667 \cf2 \strokec2 Predictive Power Management (PMU)
\f1\fs28 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f2\b0\fs29\fsmilli14667 \cf2 \strokec2 The Power Management Unit serves as the "intelligent controller" for energy conservation.
\f3\fs24 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls4\ilvl0
\f2\fs29\fsmilli14667 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Anticipatory Wakeup: The PMU monitors the DMA Arbiter's grant signals. It identifies which bank is targeted for an upcoming transfer and initiates a 50 cycle wakeup sequence from Deep Sleep before the data arrives.
\f4 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa160\partightenfactor0
\ls4\ilvl0
\f2 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Leakage Mitigation: By holding inactive banks in a low leakage Standby or Deep Sleep state, the design drastically reduces the static power footprint without a performance penalty.
\f4 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs48 \cf2 \strokec2 Architectural Breakdown
\f1\fs36 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f0\fs37\fsmilli18667 \cf2 \strokec2 4 Channel Concurrent DMA Methodology
\f1\fs28 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f2\b0\fs29\fsmilli14667 \cf2 \strokec2 The system employs four independent DMA channels to support high degree parallelism.
\f3\fs24 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls5\ilvl0
\f2\fs29\fsmilli14667 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Why 4 Channels? This configuration allows the system to manage multiple data streams simultaneously (e.g., streaming video, networking packets, and system logs) without serial bottlenecking.
\f4 \cf0 \strokec3 \
\ls5\ilvl0
\f2 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 FIFO Architecture: Each channel is equipped with a 16 word synchronous FIFO buffer. These buffers act as "shock absorbers" that decouple the high speed AXI bus from the specific timing requirements of the eDRAM, ensuring smooth, non blocking bursts.
\f4 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa160\partightenfactor0
\ls5\ilvl0
\f2 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Trade offs: 4 channels were selected as the optimal balance between high concurrency and area efficiency on the Virtex 7 fabric.
\f4 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs37\fsmilli18667 \cf2 \strokec2 Round Robin Arbitration
\f1\fs28 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f2\b0\fs29\fsmilli14667 \cf2 \strokec2 To resolve bus contention when multiple channels request memory access, a Round Robin Arbiter is implemented.
\f3\fs24 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls6\ilvl0
\f2\fs29\fsmilli14667 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Fairness: Every channel is guaranteed a slot in the rotation, preventing any single high bandwidth task from "starving" other channels.
\f4 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa160\partightenfactor0
\ls6\ilvl0
\f2 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Dynamic Priority: The arbiter tracks the "Last Served" channel and shifts priority in a circular fashion, maximizing memory bus utilization.
\f4 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs37\fsmilli18667 \cf2 \strokec2 AXI Protocol Implementation
\f1\fs28 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls7\ilvl0
\f2\b0\fs29\fsmilli14667 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 AXI Lite Slave (Control Plane): A lightweight interface used by the CPU for register configuration. It handles the setup of source addresses, destination addresses, and transfer counts.
\f4 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa160\partightenfactor0
\ls7\ilvl0
\f2 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	\uc0\u8226 	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 AXI 4 Full Master (Data Plane): The high speed "highway" for data movement. It fully supports Burst Mode, enabling the transfer of long data streams with a single address overhead, which maximizes effective bandwidth.
\f4 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs48 \cf2 \strokec2 Implementation Results
\f1\fs36 \cf0 \strokec3 \
\pard\pardeftab720\sa320\partightenfactor0

\f2\b0\fs29\fsmilli14667 \cf2 \strokec2 The design was fully implemented and routed on a Xilinx Virtex 7 (7v585tffg1157-3) FPGA using Vivado 2025.2.
\f3\fs24 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs37\fsmilli18667 \cf2 \strokec2 Timing Summary (100 MHz Target)
\f1\fs28 \cf0 \strokec3 \
\pard\pardeftab720\sa320\partightenfactor0

\f2\b0\fs29\fsmilli14667 \cf2 \strokec2 The design successfully closed timing with substantial margin, indicating a very robust RTL architecture.
\f3\fs24 \cf0 \strokec3 \

\itap1\trowd \taflags1 \trgaph108\trleft-108 \trbrdrt\brdrnil \trbrdrl\brdrnil \trbrdrr\brdrnil 
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx4320
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx8640
\pard\intbl\itap1\pardeftab720\sa160\partightenfactor0

\f0\b\fs29\fsmilli14667 \cf2 \strokec2 Metric
\f3\b0\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\sa160\partightenfactor0

\f0\b\fs29\fsmilli14667 \cf2 \strokec2 Value
\f3\b0\fs24 \cf0 \strokec3 \cell \row

\itap1\trowd \taflags1 \trgaph108\trleft-108 \trbrdrl\brdrnil \trbrdrr\brdrnil 
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx4320
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx8640
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 Worst Negative Slack (WNS)
\f3\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 6.149 ns
\f3\fs24 \cf0 \strokec3 \cell \row

\itap1\trowd \taflags1 \trgaph108\trleft-108 \trbrdrl\brdrnil \trbrdrr\brdrnil 
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx4320
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx8640
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 Worst Hold Slack (WHS)
\f3\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 0.087 ns
\f3\fs24 \cf0 \strokec3 \cell \row

\itap1\trowd \taflags1 \trgaph108\trleft-108 \trbrdrl\brdrnil \trbrdrr\brdrnil 
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx4320
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx8640
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 Total Endpoints
\f3\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 1,856
\f3\fs24 \cf0 \strokec3 \cell \row

\itap1\trowd \taflags1 \trgaph108\trleft-108 \trbrdrl\brdrnil \trbrdrt\brdrnil \trbrdrr\brdrnil 
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx4320
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx8640
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 Theoretical Max Frequency
\f3\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 ~260.3 MHz
\f3\fs24 \cf0 \strokec3 \cell \lastrow\row
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs37\fsmilli18667 \cf2 \strokec2 Power Analysis (Post Route)
\f1\fs28 \cf0 \strokec3 \
\pard\pardeftab720\sa320\partightenfactor0

\f2\b0\fs29\fsmilli14667 \cf2 \strokec2 The predictive power gating logic resulted in a highly efficient energy profile for a 1MB memory system.
\f3\fs24 \cf0 \strokec3 \

\itap1\trowd \taflags1 \trgaph108\trleft-108 \trbrdrt\brdrnil \trbrdrl\brdrnil \trbrdrr\brdrnil 
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx4320
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx8640
\pard\intbl\itap1\pardeftab720\sa160\partightenfactor0

\f0\b\fs29\fsmilli14667 \cf2 \strokec2 Component
\f3\b0\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\sa160\partightenfactor0

\f0\b\fs29\fsmilli14667 \cf2 \strokec2 Power (W)
\f3\b0\fs24 \cf0 \strokec3 \cell \row

\itap1\trowd \taflags1 \trgaph108\trleft-108 \trbrdrl\brdrnil \trbrdrr\brdrnil 
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx4320
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx8640
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 Total On Chip Power
\f3\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 0.258 W
\f3\fs24 \cf0 \strokec3 \cell \row

\itap1\trowd \taflags1 \trgaph108\trleft-108 \trbrdrl\brdrnil \trbrdrr\brdrnil 
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx4320
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx8640
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 Static/Leakage Power
\f3\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 0.243 W
\f3\fs24 \cf0 \strokec3 \cell \row

\itap1\trowd \taflags1 \trgaph108\trleft-108 \trbrdrl\brdrnil \trbrdrt\brdrnil \trbrdrr\brdrnil 
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx4320
\clvertalt \clcbpat4 \clwWidth5740\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx8640
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 Dynamic Logic Power
\f3\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 0.015 W
\f3\fs24 \cf0 \strokec3 \cell \lastrow\row
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs37\fsmilli18667 \cf2 \strokec2 Clock and Resource Utilization
\f1\fs28 \cf0 \strokec3 \

\itap1\trowd \taflags1 \trgaph108\trleft-108 \trbrdrt\brdrnil \trbrdrl\brdrnil \trbrdrr\brdrnil 
\clvertalt \clcbpat4 \clwWidth2620\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx2160
\clvertalt \clcbpat4 \clwWidth2620\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx4320
\clvertalt \clcbpat4 \clwWidth2620\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx6480
\clvertalt \clcbpat4 \clwWidth2620\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx8640
\pard\intbl\itap1\pardeftab720\sa160\partightenfactor0

\f0\fs29\fsmilli14667 \cf2 \strokec2 Resource Type
\f3\b0\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\sa160\partightenfactor0

\f0\b\fs29\fsmilli14667 \cf2 \strokec2 Used
\f3\b0\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\sa160\partightenfactor0

\f0\b\fs29\fsmilli14667 \cf2 \strokec2 Available
\f3\b0\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\sa160\partightenfactor0

\f0\b\fs29\fsmilli14667 \cf2 \strokec2 Utilization %
\f3\b0\fs24 \cf0 \strokec3 \cell \row

\itap1\trowd \taflags1 \trgaph108\trleft-108 \trbrdrl\brdrnil \trbrdrr\brdrnil 
\clvertalt \clcbpat4 \clwWidth2620\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx2160
\clvertalt \clcbpat4 \clwWidth2620\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx4320
\clvertalt \clcbpat4 \clwWidth2620\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx6480
\clvertalt \clcbpat4 \clwWidth2620\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx8640
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 Slice LUTs
\f3\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 1,272
\f3\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 364,200
\f3\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 0.35%
\f3\fs24 \cf0 \strokec3 \cell \row

\itap1\trowd \taflags1 \trgaph108\trleft-108 \trbrdrl\brdrnil \trbrdrr\brdrnil 
\clvertalt \clcbpat4 \clwWidth2620\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx2160
\clvertalt \clcbpat4 \clwWidth2620\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx4320
\clvertalt \clcbpat4 \clwWidth2620\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx6480
\clvertalt \clcbpat4 \clwWidth2620\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx8640
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 Registers
\f3\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 1,399
\f3\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 728,400
\f3\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 0.19%
\f3\fs24 \cf0 \strokec3 \cell \row

\itap1\trowd \taflags1 \trgaph108\trleft-108 \trbrdrl\brdrnil \trbrdrt\brdrnil \trbrdrr\brdrnil 
\clvertalt \clcbpat4 \clwWidth2620\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx2160
\clvertalt \clcbpat4 \clwWidth2620\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx4320
\clvertalt \clcbpat4 \clwWidth2620\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx6480
\clvertalt \clcbpat4 \clwWidth2620\clftsWidth3 \clbrdrt\brdrs\brdrw20\brdrcf3 \clbrdrl\brdrs\brdrw20\brdrcf3 \clbrdrb\brdrs\brdrw20\brdrcf3 \clbrdrr\brdrs\brdrw20\brdrcf3 \clpadt160 \clpadl240 \clpadb160 \clpadr240 \gaph\cellx8640
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 Global Clock Buffers
\f3\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 1
\f3\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 32
\f3\fs24 \cf0 \strokec3 \cell 
\pard\intbl\itap1\pardeftab720\partightenfactor0

\f2\fs29\fsmilli14667 \cf2 \strokec2 3.13%
\f3\fs24 \cf0 \strokec3 \cell \lastrow\row
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs48 \cf2 \strokec2 Visual Documentation
\f1\fs36 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f0\fs37\fsmilli18667 \cf2 \strokec2 System Schematic
\f1\fs28 \cf0 \strokec3 \
\pard\pardeftab720\sa320\partightenfactor0

\f2\b0\fs29\fsmilli14667 \cf2 \strokec2 This diagram shows the logical interconnection between the AXI interfaces, the Arbiter, and the 16 bank memory array.
\f3\fs24 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs37\fsmilli18667 \cf2 \strokec2 Power Breakdown
\f1\fs28 \cf0 \strokec3 \
\pard\pardeftab720\sa320\partightenfactor0

\f2\b0\fs29\fsmilli14667 \cf2 \strokec2 This visualization confirms the lean nature of the logic, with the majority of the power footprint managed through the PMU.
\f3\fs24 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs37\fsmilli18667 \cf2 \strokec2 Simulation Waveforms
\f1\fs28 \cf0 \strokec3 \
\pard\pardeftab720\sa320\partightenfactor0

\f2\b0\fs29\fsmilli14667 \cf2 \strokec2 Waveforms demonstrating successful AXI handshaking, multi channel arbitration, and bank wakeup sequences.
\f3\fs24 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs48 \cf2 \strokec2 Key Takeaways
\f1\fs36 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls8\ilvl0
\f2\b0\fs29\fsmilli14667 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	1	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 High Efficiency: Total system power consumption is limited to 0.258W.
\f4 \cf0 \strokec3 \
\ls8\ilvl0
\f2 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	2	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Timing Excellence: A 6.149ns positive slack ensures immunity to hardware delays and environmental variations.
\f4 \cf0 \strokec3 \
\ls8\ilvl0
\f2 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	3	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Advanced RMW: Supports sub word AXI writes without data corruption via an integrated Read Modify Write cycle.
\f4 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa160\partightenfactor0
\ls8\ilvl0
\f2 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	4	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Scalable Logic: The modular 4 channel design can be easily expanded for higher performance requirements.
\f4 \cf0 \strokec3 \
\pard\pardeftab720\sa160\partightenfactor0

\f0\b\fs48 \cf2 \strokec2 How to Run
\f1\fs36 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\partightenfactor0
\ls9\ilvl0
\f2\b0\fs29\fsmilli14667 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	1	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Open Xilinx Vivado.
\f4 \cf0 \strokec3 \
\ls9\ilvl0
\f2 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	2	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Add all files in the /rtl directory and the testbench in /tb.
\f4 \cf0 \strokec3 \
\ls9\ilvl0
\f2 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	3	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Load the constraints/top_constraints.xdc file.
\f4 \cf0 \strokec3 \
\pard\tx220\tx720\pardeftab720\li720\fi-720\sa160\partightenfactor0
\ls9\ilvl0
\f2 \cf2 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 {\listtext	4	}\expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 Execute Synthesis and Implementation to generate the full hardware reports.
\f4 \cf0 \strokec3 \
\pard\pardeftab720\sa320\partightenfactor0

\f2 \cf2 \strokec2 If you've made it this far and still don't understand what's happening, don't worry \'97 most people just look at the blinking lights on the FPGA anyway.
\f3\fs24 \cf0 \strokec3 \
}
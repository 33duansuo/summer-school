// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Fri Aug 30 09:22:38 2024
// Host        : honer running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub d:/FPGA2/project_1/project_1.gen/sources_1/ip/vio_0/vio_0_stub.v
// Design      : vio_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a75tfgg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2023.2" *)
module vio_0(clk, probe_in0, probe_in1, probe_in2, probe_in3)
/* synthesis syn_black_box black_box_pad_pin="probe_in0[15:0],probe_in1[15:0],probe_in2[1:0],probe_in3[6:0]" */
/* synthesis syn_force_seq_prim="clk" */;
  input clk /* synthesis syn_isclock = 1 */;
  input [15:0]probe_in0;
  input [15:0]probe_in1;
  input [1:0]probe_in2;
  input [6:0]probe_in3;
endmodule

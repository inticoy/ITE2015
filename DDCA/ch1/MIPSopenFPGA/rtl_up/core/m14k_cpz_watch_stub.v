// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//      Description: m14k_cpz_watch_stub
//             Stub module to replace Watch logic

//	$Id: \$
//	mips_repository_id: m14k_cpz_watch_stub.mv, v 1.7 
//

//      	mips_start_of_legal_notice
//      	**********************************************************************
//		
//	Copyright (c) 2019 MIPS Tech, LLC, 300 Orchard City Dr., Suite 170, 
//	Campbell, CA 95008 USA.  All rights reserved.
//	This document contains information and code that is proprietary to 
//	MIPS Tech, LLC and MIPS' affiliates, as applicable, ("MIPS").  If this 
//	document is obtained pursuant to a MIPS Open license, the sole 
//	licensor under such license is MIPS Tech, LLC. This document and any 
//	information or code therein are protected by patent, copyright, 
//	trademarks and unfair competition laws, among others, and are 
//	distributed under a license restricting their use. MIPS has 
//	intellectual property rights, including patents or pending patent 
//	applications in the U.S. and in other countries, relating to the 
//	technology embodied in the product that is described in this document. 
//	Any distribution release of this document may include or be 
//	accompanied by materials developed by third parties. Any copying, 
//	reproducing, modifying or use of this information (in whole or in part) 
//	that is not expressly permitted in writing by MIPS or an authorized 
//	third party is strictly prohibited.  Any document provided in source 
//	format (i.e., in a modifiable form such as in FrameMaker or 
//	Microsoft Word format) may be subject to separate use and distribution 
//	restrictions applicable to such document. UNDER NO CIRCUMSTANCES MAY A 
//	DOCUMENT PROVIDED IN SOURCE FORMAT BE DISTRIBUTED TO A THIRD PARTY IN 
//	SOURCE FORMAT WITHOUT THE EXPRESS WRITTEN PERMISSION OF, OR LICENSED 
//	FROM, MIPS.  MIPS reserves the right to change the information or code 
//	contained in this document to improve function, design or otherwise.  
//	MIPS does not assume any liability arising out of the application or 
//	use of this information, or of any error or omission in such 
//	information. DOCUMENTATION AND CODE ARE PROVIDED "AS IS" AND ANY 
//	WARRANTIES, WHETHER EXPRESS, STATUTORY, IMPLIED OR OTHERWISE, 
//	INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY, 
//	FITNESS FOR A PARTICULAR PURPOSE OR NON-INFRINGEMENT, ARE EXCLUDED, 
//	EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD TO BE LEGALLY 
//	INVALID IN A COMPETENT JURISDICTION. Except as expressly provided in 
//	any written license agreement from MIPS or an authorized third party, 
//	the furnishing or distribution of this document does not give recipient 
//	any license to any intellectual property rights, including any patent 
//	rights, that cover the information in this document.  
//	Products covered by, and information or code, contained this document 
//	are controlled by U.S. export control laws and may be subject to the 
//	expert or import laws in other countries. The information contained 
//	in this document shall not be exported, reexported, transferred, or 
//	released, directly or indirectly, in violation of the law of any 
//	country or international law, regulation, treaty, executive order, 
//	statute, amendments or supplements thereto. Nuclear, missile, chemical 
//	weapons, biological weapons or nuclear maritime end uses, whether 
//	direct or indirect, are strictly prohibited.  Should a conflict arise 
//	regarding the export, reexport, transfer, or release of the information 
//	contained in this document, the laws of the United States of America 
//	shall be the governing law.  
//	U.S Government Rights - Commercial software.  Government users are 
//	subject to the MIPS Tech, LLC standard license agreement and applicable 
//	provisions of the FAR and its supplements.
//	MIPS and MIPS Open are trademarks or registered trademarks of MIPS in 
//	the United States and other countries.  All other trademarks referred 
//	to herein are the property of their respective owners.  
//      
//      
//	**********************************************************************
//	mips_end_of_legal_notice
//      
////////////////////////////////////////////////////////////////////////////////

// Comments for verilint
// This is a stub module so most of the inputs are unused
//verilint 240 off  // Unused input

`include "m14k_const.vh"
module m14k_cpz_watch_stub(
	gscanenable,
	greset,
	gclk,
	mfcp0_m,
	mtcp0_m,
	mpc_cp0r_m,
	mpc_cp0sr_m,
	cpz,
	mmu_asid,
	mmu_dva_m,
	mpc_squash_i,
	mpc_pexc_i,
	hot_ignore_watch,
	mpc_ivaval_i,
	edp_iva_i,
	edp_alu_m,
	mpc_busty_m,
	hot_delay_watch,
	delay_watch,
	ignore_watch,
	cpz_mmutype,
	mpc_fixup_m,
	mpc_run_i,
	mpc_run_ie,
	mpc_run_m,
	mpc_exc_e,
	mpc_exc_m,
	mpc_exc_w,
	watch32,
	cpz_iwatchhit,
	cpz_dwatchhit,
	set_watch_pend_w,
	watch_present,
	cpz_watch_present__1,
	cpz_watch_present__2,
	cpz_watch_present__3,
	cpz_watch_present__4,
	cpz_watch_present__5,
	cpz_watch_present__6,
	cpz_watch_present__7,
	mpc_atomic_m,
	dcc_dvastrobe);


input			gscanenable;	// Scan enable 
input			greset;		// Power on and reset for chip
input		 gclk;		// clock
input 			mfcp0_m;	// cp0 control
input 			mtcp0_m;	// cp0 control
input [4:0]		mpc_cp0r_m;	// coprocessor zero register specifier
input [2:0]		mpc_cp0sr_m;	// coprocessor zero shadow register specifier
input [31:0]		cpz;		// cpz write data
input [`M14K_ASID] 	mmu_asid;       // Address Space Identifier
input [31:0] 		mmu_dva_m;       // Address Space Identifier
input			mpc_squash_i;
input			mpc_pexc_i;
input			hot_ignore_watch;
input			mpc_ivaval_i;
input [31:0]		edp_iva_i;
input [31:0]		edp_alu_m;
input [2:0]		mpc_busty_m;		
input			hot_delay_watch;
input			delay_watch;
input			ignore_watch;
input			cpz_mmutype;
input			mpc_fixup_m;
input   		mpc_run_i;
input   		mpc_run_ie;
input   		mpc_run_m;
input   		mpc_exc_e;
input 	        	mpc_exc_m;
input   		mpc_exc_w;

output [31:0]   	watch32;
output			cpz_iwatchhit;
output			cpz_dwatchhit;
output          	set_watch_pend_w;
output 			watch_present;
output 			cpz_watch_present__1;
output 			cpz_watch_present__2;
output 			cpz_watch_present__3;
output 			cpz_watch_present__4;
output 			cpz_watch_present__5;
output 			cpz_watch_present__6;
output 			cpz_watch_present__7;
input			mpc_atomic_m;		// Atomic instruction entered into M stage for load
input	  		dcc_dvastrobe;      	// Data Virtual Address strobe for WATCH

// BEGIN Wire declarations made by MVP
wire cpz_watch_present__1;
wire cpz_watch_present__4;
wire cpz_watch_present__7;
wire [31:0] /*[31:0]*/ watch32;
wire cpz_watch_present__3;
wire cpz_iwatchhit;
wire cpz_watch_present__6;
wire set_watch_pend_w;
wire watch_present;
wire cpz_watch_present__2;
wire cpz_watch_present__5;
wire cpz_dwatchhit;
// END Wire declarations made by MVP


	assign watch_present = 1'b0;
	
	assign cpz_watch_present__1 = 1'b0;
	assign cpz_watch_present__2 = 1'b0;
	assign cpz_watch_present__3 = 1'b0;
	assign cpz_watch_present__4 = 1'b0;
	assign cpz_watch_present__5 = 1'b0;
	assign cpz_watch_present__6 = 1'b0;
	assign cpz_watch_present__7 = 1'b0;

	assign watch32 [31:0] = 32'b0;
	assign cpz_iwatchhit = 1'b0;
	assign cpz_dwatchhit = 1'b0;
	assign set_watch_pend_w = 1'b0;
	
// Artifact code to give the testbench a cannonical reference point independent of 
// how watch is configured
//
 `ifdef MIPS_SIMULATION 
 //VCS coverage off 
//
wire 			chan_present_0 = 1'b0;
wire 			chan_present_1 = 1'b0;
wire 			chan_present_2 = 1'b0;
wire 			chan_present_3 = 1'b0;
wire 			chan_present_4 = 1'b0;
wire 			chan_present_5 = 1'b0;
wire 			chan_present_6 = 1'b0;
wire 			chan_present_7 = 1'b0;

wire [31:0] 		NextWatchHi32_0 = 32'b0;
wire [31:0] 		NextWatchHi32_1 = 32'b0;
wire [31:0] 		NextWatchHi32_2 = 32'b0;
wire [31:0] 		NextWatchHi32_3 = 32'b0;
wire [31:0] 		NextWatchHi32_4 = 32'b0;
wire [31:0] 		NextWatchHi32_5 = 32'b0;
wire [31:0] 		NextWatchHi32_6 = 32'b0;
wire [31:0] 		NextWatchHi32_7 = 32'b0;
	
wire [31:0] 		WatchHi32_0 = 32'b0;
wire [31:0] 		WatchHi32_1 = 32'b0;
wire [31:0] 		WatchHi32_2 = 32'b0;
wire [31:0] 		WatchHi32_3 = 32'b0;
wire [31:0] 		WatchHi32_4 = 32'b0;
wire [31:0] 		WatchHi32_5 = 32'b0;
wire [31:0] 		WatchHi32_6 = 32'b0;
wire [31:0] 		WatchHi32_7 = 32'b0;
	
wire [31:0] 		NextWatchLo32_0 = 32'b0;
wire [31:0] 		NextWatchLo32_1 = 32'b0;
wire [31:0] 		NextWatchLo32_2 = 32'b0;
wire [31:0] 		NextWatchLo32_3 = 32'b0;
wire [31:0] 		NextWatchLo32_4 = 32'b0;
wire [31:0] 		NextWatchLo32_5 = 32'b0;
wire [31:0] 		NextWatchLo32_6 = 32'b0;
wire [31:0] 		NextWatchLo32_7 = 32'b0;
	
wire [31:0] 		WatchLo32_0 = 32'b0;
wire [31:0] 		WatchLo32_1 = 32'b0;
wire [31:0] 		WatchLo32_2 = 32'b0;
wire [31:0] 		WatchLo32_3 = 32'b0;
wire [31:0] 		WatchLo32_4 = 32'b0;
wire [31:0] 		WatchLo32_5 = 32'b0;
wire [31:0] 		WatchLo32_6 = 32'b0;
wire [31:0] 		WatchLo32_7 = 32'b0;
	
wire [7:0] 		SetWatchTaken = 8'b0;
	
wire 			setwp_m = 1'b0;
wire 			setdwp_m = 1'b0;

wire                    watchlo_ld = 1'b0;

 //VCS coverage on  
 `endif 
//
//
	
//verilint 240 on  // Unused input
endmodule	// m14k_watch_reg

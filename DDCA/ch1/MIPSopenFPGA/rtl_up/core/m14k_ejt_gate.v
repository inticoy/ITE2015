// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_ejt_gate
//           Simple Break Bus Gate Module
//
//      $Id: \$
//      mips_repository_id: m14k_ejt_gate.mv, v 1.3 
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

`include "m14k_const.vh"
module m14k_ejt_gate(
	edp_iva_i,
	mmu_dva_m,
	mmu_asid,
	cpz_guestid,
	cpz_guestid_i,
	cpz_guestid_m,
	dcc_ejdata,
	mpc_lsbe_m,
	mpc_be_w,
	pwrsave_en,
	gt_ivaaddr,
	gt_dvaaddr,
	gt_asid,
	gt_guestid,
	gt_guestid_i,
	gt_guestid_m,
	gt_data,
	gt_bytevalid_m,
	gt_bytevalid_w);


/* Inputs */

	input	[31:0]	edp_iva_i;	// Virtual addr of inst
	input 	[31:0]	mmu_dva_m;	// Virtual addr of load/store

	input	[7:0]	mmu_asid;	// Current mmu_asid
	input	[7:0]	cpz_guestid;	// Current guestid
	input	[7:0]	cpz_guestid_i;	// Current guestid
	input	[7:0]	cpz_guestid_m;	// Current guestid
	input	[31:0]	dcc_ejdata;	// Muxed store+load data bus
	input	[3:0]	mpc_lsbe_m;	// Bytes valid for L/S in M stage
	input	[3:0]	mpc_be_w;	// Bytes valid for load in W stage
	input		pwrsave_en;	// When 1 low pwr is enabled

/* Outputs */

	output	[31:0]	gt_ivaaddr;	// Virtual addr of inst
	output 	[31:0]	gt_dvaaddr;	// Virtual addr of load/store

	output	[7:0]	gt_asid;	// Current mmu_asid
	output	[7:0]	gt_guestid;	// Current guestid
	output	[7:0]	gt_guestid_i;	// Current guestid
	output	[7:0]	gt_guestid_m;	// Current guestid
	output	[31:0]	gt_data;	// Muxed store+load data bus
	output	[3:0]	gt_bytevalid_m;	// Bytes valid for L/S in M stage
	output	[3:0]	gt_bytevalid_w;	// Bytes valid for load in W stage

// BEGIN Wire declarations made by MVP
wire [3:0] /*[3:0]*/ gt_bytevalid_m;
wire [31:0] /*[31:0]*/ gt_ivaaddr;
wire [31:0] /*[31:0]*/ gt_data;
wire [7:0] /*[7:0]*/ gt_asid;
wire [7:0] /*[7:0]*/ gt_guestid;
wire [3:0] /*[3:0]*/ gt_bytevalid_w;
wire [7:0] /*[7:0]*/ gt_guestid_m;
wire [7:0] /*[7:0]*/ gt_guestid_i;
wire [31:0] /*[31:0]*/ gt_dvaaddr;
// END Wire declarations made by MVP


/* Code */

	assign gt_ivaaddr 	[31:0]	= pwrsave_en ? 32'b0 : edp_iva_i;
	assign gt_dvaaddr	[31:0]	= pwrsave_en ? 32'b0 : mmu_dva_m;
	
	assign gt_asid		[7:0]	= pwrsave_en ? 8'b0  : mmu_asid;
	assign gt_guestid	[7:0]	= pwrsave_en ? 8'b0  : cpz_guestid;
	assign gt_guestid_m	[7:0]	= pwrsave_en ? 8'b0  : cpz_guestid_m;
	assign gt_guestid_i	[7:0]	= pwrsave_en ? 8'b0  : cpz_guestid_i;

	assign gt_data		[31:0]	= pwrsave_en ? 32'b0 : dcc_ejdata;
	assign gt_bytevalid_m	[3:0]	= pwrsave_en ? 4'b0  : mpc_lsbe_m;
	assign gt_bytevalid_w	[3:0]	= pwrsave_en ? 4'b0  : mpc_be_w;

endmodule


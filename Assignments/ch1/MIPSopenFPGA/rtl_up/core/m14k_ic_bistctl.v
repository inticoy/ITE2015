// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_ic_bistctl
//            Place-holder module for instantiation of cache bist controller
//
//	$Id: \$
//	mips_repository_id: m14k_ic_bistctl.mv, v 1.1 
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

// Comments for verilint...Since this is a placeholder module for bist,
//  some inputs are unused.
//verilint 240 off // Unused input

`include "m14k_const.vh"
module m14k_ic_bistctl(
	cbist_to,
	tag_bist_from,
	ws_bist_from,
	data_bist_from,
	cbist_from,
	tag_bist_to,
	ws_bist_to,
	data_bist_to);


	parameter	BIST_TO_WIDTH = 1;		// top-level cache bist input width
	parameter	BIST_FROM_WIDTH = 1;		// top-level cache bist output width
	parameter	TAG_BIST_TO_WIDTH = 1;	// bist width to cache tag array
	parameter	TAG_BIST_FROM_WIDTH = 1;	// bist width from cache tag array
        parameter       WS_BIST_TO_WIDTH = 1;
        parameter       WS_BIST_FROM_WIDTH = 1;
	parameter	DATA_BIST_TO_WIDTH = 1;	// bist width to cache data aray
	parameter	DATA_BIST_FROM_WIDTH = 1;	// bist width from cache data aray

	/* Inputs */
	input [BIST_TO_WIDTH-1:0]		cbist_to;	// top-level cache bist input signals
	input [TAG_BIST_FROM_WIDTH-1:0]	tag_bist_from;	// bist signals from cache tag
        input [WS_BIST_FROM_WIDTH-1:0]  ws_bist_from;
	input [DATA_BIST_FROM_WIDTH-1:0]	data_bist_from;	// bist signals from cache data

	/* Outputs */
	output [BIST_FROM_WIDTH-1:0]		cbist_from;	// top-level cache bist output signals
	output [TAG_BIST_TO_WIDTH-1:0]	tag_bist_to;	// bist signals to cache tag
        output [WS_BIST_TO_WIDTH-1:0]           ws_bist_to;
	output [DATA_BIST_TO_WIDTH-1:0]	data_bist_to;	// bist signals to cache data

// BEGIN Wire declarations made by MVP
wire [TAG_BIST_TO_WIDTH-1:0] /*[0:0]*/ tag_bist_to;
wire [DATA_BIST_TO_WIDTH-1:0] /*[0:0]*/ data_bist_to;
wire [BIST_FROM_WIDTH-1:0] /*[0:0]*/ cbist_from;
wire [WS_BIST_TO_WIDTH-1:0] /*[0:0]*/ ws_bist_to;
// END Wire declarations made by MVP


	/* Inouts */

	// End of I/O


	/* Internal Block Wires */



	assign cbist_from [BIST_FROM_WIDTH-1:0] = {BIST_FROM_WIDTH{1'b0}};
	assign tag_bist_to [TAG_BIST_TO_WIDTH-1:0] = {BIST_FROM_WIDTH{1'b0}};
        assign ws_bist_to [WS_BIST_TO_WIDTH-1:0] = {BIST_FROM_WIDTH{1'b0}};
	assign data_bist_to [DATA_BIST_TO_WIDTH-1:0] = {BIST_FROM_WIDTH{1'b0}};

//verilint 240 on // Unused input
endmodule	// bistctl_cache

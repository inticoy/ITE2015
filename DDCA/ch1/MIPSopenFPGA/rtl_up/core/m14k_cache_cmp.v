// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// 	Description:  m14k_cache_cmp
// 	    Cache tag compare logic
//	
//	$Id: \$
//	mips_repository_id: m14k_cache_cmp.mv, v 1.1 
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
module m14k_cache_cmp(
	tag_cmp_data,
	tag_cmp_pa,
	tag_cmp_v,
	spram_support,
	valid,
	line_sel,
	hit_way,
	cachehit);


	/* parameters, overriden per instance */

	// synopsys template
	parameter		WIDTH=1;		// WIDTH of PA
	parameter		ASSOC=1;		// Cache Associativity


	/* Inputs */
	input [WIDTH-1:0]	tag_cmp_data;		// PA from TLB
	input [ASSOC*WIDTH-1:0]	tag_cmp_pa;	// PA's coming out of tagram
	input [(ASSOC)-1:0]	tag_cmp_v;		// Valid Bits per line

	input 			spram_support;     // Last way is really SPRAM disable comparison

	/* Outputs */
	output [3:0]		valid;	// Valid bit per line
	output [3:0]		line_sel;	// Line Matched and was valid
	output [3:0]		hit_way;		// Match Lines
	output			cachehit;	// Hit Flag on Specifie

// BEGIN Wire declarations made by MVP
wire [3:0] /*[3:0]*/ valid;
wire cachehit;
wire [3:0] /*[3:0]*/ hit_way;
wire [3:0] /*[3:0]*/ line_sel;
wire [3:0] /*[3:0]*/ spram;
// END Wire declarations made by MVP


	/* End of I/O */

	// Any word valid on each line??
	assign valid [3:0] = tag_cmp_v;

	// Disable comparison on SPRAM way
	// spram_support is statically tied off in spram logic module
	// this logic should be optimized away
	assign spram[3:0] = spram_support ? {(ASSOC==4), (ASSOC==3), (ASSOC==2), (ASSOC==1)} : 4'b0;
	
   
	wire [4*WIDTH-1:0] wide_tag_cmp_pa = {tag_cmp_pa};
 
	wire [WIDTH-1:0]	cache_pa_0 = wide_tag_cmp_pa[WIDTH-1:0];
	wire [WIDTH-1:0]	cache_pa_1 = wide_tag_cmp_pa[2*WIDTH-1:WIDTH];
	wire [WIDTH-1:0]	cache_pa_2 = wide_tag_cmp_pa[3*WIDTH-1:2*WIDTH];
	wire [WIDTH-1:0]	cache_pa_3 = wide_tag_cmp_pa[4*WIDTH-1:3*WIDTH];

	wire [3:0] compare;	
	assign	compare[0] = valid[0] && !spram[0] && (tag_cmp_data == cache_pa_0);
	assign	compare[1] = (ASSOC > 1) && valid[1] && !spram[1] && (tag_cmp_data == cache_pa_1);
	assign	compare[2] = (ASSOC > 2) && valid[2] && !spram[2] && (tag_cmp_data == cache_pa_2);
	assign	compare[3] = (ASSOC > 3) && valid[3] && !spram[3] && (tag_cmp_data == cache_pa_3);

   

	assign line_sel [3:0] = compare;

	// Hit way is a bit earlier than line_sel because it
	// doesn't include the cacheop forcing of the way
	assign hit_way [3:0] = compare;

	assign cachehit = | compare;

endmodule // m14k_cache_cmp


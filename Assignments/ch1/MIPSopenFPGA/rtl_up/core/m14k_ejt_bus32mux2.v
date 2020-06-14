// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_ejt_bus32mux2
//           Glitch-free EJTAG TAP mux 2 to 1 for 32 bit bus, 
//	     The gf_mux is used for the muxing.
//
//	$Id: \$
//	mips_repository_id: m14k_ejt_bus32mux2.mv, v 1.1 
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
module m14k_ejt_bus32mux2(
	y,
	s,
	a,
	b);


// Output and Inputs 
output	[31:0]	y;		// Output [31:0]
input		s;		// Select A when asserted, and B when deassert.
input	[31:0]	a;		// Input A[31:0]
input	[31:0]	b;		// Input B[31:0]



// Muxing function 
m14k_gf_mux2 bit_00i(.y(y[ 0]), .s(s), .a(a[ 0]), .b(b[ 0]));
m14k_gf_mux2 bit_01i(.y(y[ 1]), .s(s), .a(a[ 1]), .b(b[ 1]));
m14k_gf_mux2 bit_02i(.y(y[ 2]), .s(s), .a(a[ 2]), .b(b[ 2]));
m14k_gf_mux2 bit_03i(.y(y[ 3]), .s(s), .a(a[ 3]), .b(b[ 3]));
m14k_gf_mux2 bit_04i(.y(y[ 4]), .s(s), .a(a[ 4]), .b(b[ 4]));
m14k_gf_mux2 bit_05i(.y(y[ 5]), .s(s), .a(a[ 5]), .b(b[ 5]));
m14k_gf_mux2 bit_06i(.y(y[ 6]), .s(s), .a(a[ 6]), .b(b[ 6]));
m14k_gf_mux2 bit_07i(.y(y[ 7]), .s(s), .a(a[ 7]), .b(b[ 7]));
m14k_gf_mux2 bit_08i(.y(y[ 8]), .s(s), .a(a[ 8]), .b(b[ 8]));
m14k_gf_mux2 bit_09i(.y(y[ 9]), .s(s), .a(a[ 9]), .b(b[ 9]));
m14k_gf_mux2 bit_10i(.y(y[10]), .s(s), .a(a[10]), .b(b[10]));
m14k_gf_mux2 bit_11i(.y(y[11]), .s(s), .a(a[11]), .b(b[11]));
m14k_gf_mux2 bit_12i(.y(y[12]), .s(s), .a(a[12]), .b(b[12]));
m14k_gf_mux2 bit_13i(.y(y[13]), .s(s), .a(a[13]), .b(b[13]));
m14k_gf_mux2 bit_14i(.y(y[14]), .s(s), .a(a[14]), .b(b[14]));
m14k_gf_mux2 bit_15i(.y(y[15]), .s(s), .a(a[15]), .b(b[15]));
m14k_gf_mux2 bit_16i(.y(y[16]), .s(s), .a(a[16]), .b(b[16]));
m14k_gf_mux2 bit_17i(.y(y[17]), .s(s), .a(a[17]), .b(b[17]));
m14k_gf_mux2 bit_18i(.y(y[18]), .s(s), .a(a[18]), .b(b[18]));
m14k_gf_mux2 bit_19i(.y(y[19]), .s(s), .a(a[19]), .b(b[19]));
m14k_gf_mux2 bit_20i(.y(y[20]), .s(s), .a(a[20]), .b(b[20]));
m14k_gf_mux2 bit_21i(.y(y[21]), .s(s), .a(a[21]), .b(b[21]));
m14k_gf_mux2 bit_22i(.y(y[22]), .s(s), .a(a[22]), .b(b[22]));
m14k_gf_mux2 bit_23i(.y(y[23]), .s(s), .a(a[23]), .b(b[23]));
m14k_gf_mux2 bit_24i(.y(y[24]), .s(s), .a(a[24]), .b(b[24]));
m14k_gf_mux2 bit_25i(.y(y[25]), .s(s), .a(a[25]), .b(b[25]));
m14k_gf_mux2 bit_26i(.y(y[26]), .s(s), .a(a[26]), .b(b[26]));
m14k_gf_mux2 bit_27i(.y(y[27]), .s(s), .a(a[27]), .b(b[27]));
m14k_gf_mux2 bit_28i(.y(y[28]), .s(s), .a(a[28]), .b(b[28]));
m14k_gf_mux2 bit_29i(.y(y[29]), .s(s), .a(a[29]), .b(b[29]));
m14k_gf_mux2 bit_30i(.y(y[30]), .s(s), .a(a[30]), .b(b[30]));
m14k_gf_mux2 bit_31i(.y(y[31]), .s(s), .a(a[31]), .b(b[31]));



// The End

endmodule

//
//	mvp_mux16
//      Description: 16-1 encode select mux Model parameterized by width
//
//	$Id: \$
//	mips_repository_id: mvp_mux16.v, v 3.2 
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
//verilint 550 off  // Mux is inferred

`include "m14k_const.vh"
module mvp_mux16(
	z,
	sel,
	d0,
	d1,
	d2,
	d3,
	d4,
	d5,
	d6,
	d7,
	d8,
	d9,
	d10,
	d11,
	d12,
	d13,
	d14,
	d15
);
// synopsys template
parameter WIDTH = 1;

output	[WIDTH-1:0]	z;

input	[3:0]		sel;
input	[WIDTH-1:0]	d0;
input	[WIDTH-1:0]	d1;
input	[WIDTH-1:0]	d2;
input	[WIDTH-1:0]	d3;
input	[WIDTH-1:0]	d4;
input	[WIDTH-1:0]	d5;
input	[WIDTH-1:0]	d6;
input	[WIDTH-1:0]	d7;
input	[WIDTH-1:0]	d8;
input	[WIDTH-1:0]	d9;
input	[WIDTH-1:0]	d10;
input	[WIDTH-1:0]	d11;
input	[WIDTH-1:0]	d12;
input	[WIDTH-1:0]	d13;
input	[WIDTH-1:0]	d14;
input	[WIDTH-1:0]	d15;

wire	[WIDTH-1:0]	z10;
wire	[WIDTH-1:0]	z11;
wire	[WIDTH-1:0]	z12;
wire	[WIDTH-1:0]	z13;

mvp_mux4 #(WIDTH) mux10 ( .y(z10), .sel(sel[1:0]), .a(d0),  .b(d1),  .c(d2),  .d(d3));
mvp_mux4 #(WIDTH) mux11 ( .y(z11), .sel(sel[1:0]), .a(d4),  .b(d5),  .c(d6),  .d(d7));
mvp_mux4 #(WIDTH) mux12 ( .y(z12), .sel(sel[1:0]), .a(d8),  .b(d9),  .c(d10), .d(d11));
mvp_mux4 #(WIDTH) mux13 ( .y(z13), .sel(sel[1:0]), .a(d12), .b(d13), .c(d14), .d(d15));

mvp_mux4 #(WIDTH) mux14 ( .y(z), .sel(sel[3:2]), .a(z10), .b(z11), .c(z12), .d(z13));

endmodule

// Comments for verilint
//verilint 550 on

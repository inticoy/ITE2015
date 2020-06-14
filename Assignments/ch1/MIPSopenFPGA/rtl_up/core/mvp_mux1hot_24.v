//	Description: mvp_mux1hot_23
//		23-1 one hot mux Model parameterized by width
//
//      $Id: \$
//      mips_repository_id: mvp_mux1hot_24.v, v 1.1 
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
module mvp_mux1hot_24(
	y,
	sel0,
	d0,
	sel1,
	d1,
	sel2,
	d2,
	sel3,
	d3,
	sel4,
	d4,
	sel5,
	d5,
	sel6,
	d6,
	sel7,
	d7,
	sel8,
	d8,
	sel9,
	d9,
	sel10,
	d10,
	sel11,
	d11,
	sel12,
	d12,
	sel13,
	d13,
	sel14,
	d14,
	sel15,
	d15,
	sel16,
	d16,
	sel17,
	d17,
	sel18,
	d18,
	sel19,
	d19,
	sel20,
	d20,
	sel21,
	d21,
	sel22,
	d22,
	sel23,
	d23
);
// synopsys template
parameter WIDTH = 1;

output [WIDTH-1:0]	y;

input			sel0;
input			sel1;
input			sel2;
input			sel3;
input			sel4;
input			sel5;
input			sel6;
input			sel7;
input			sel8;
input			sel9;
input			sel10;
input			sel11;
input			sel12;
input			sel13;
input			sel14;
input			sel15;
input			sel16;
input			sel17;
input			sel18;
input			sel19;
input			sel20;
input			sel21;
input			sel22;
input			sel23;
input  [WIDTH-1:0]	d0;
input  [WIDTH-1:0]	d1;
input  [WIDTH-1:0]	d2;
input  [WIDTH-1:0]	d3;
input  [WIDTH-1:0]	d4;
input  [WIDTH-1:0]	d5;
input  [WIDTH-1:0]	d6;
input  [WIDTH-1:0]	d7;
input  [WIDTH-1:0]	d8;
input  [WIDTH-1:0]	d9;
input  [WIDTH-1:0]	d10;
input  [WIDTH-1:0]	d11;
input  [WIDTH-1:0]	d12;
input  [WIDTH-1:0]	d13;
input  [WIDTH-1:0]	d14;
input  [WIDTH-1:0]	d15;
input  [WIDTH-1:0]	d16;
input  [WIDTH-1:0]	d17;
input  [WIDTH-1:0]	d18;
input  [WIDTH-1:0]	d19;
input  [WIDTH-1:0]	d20;
input  [WIDTH-1:0]	d21;
input  [WIDTH-1:0]	d22;
input  [WIDTH-1:0]	d23;


 assign y = 
	{WIDTH{sel0}} & d0 |
	{WIDTH{sel1}} & d1 |
	{WIDTH{sel2}} & d2 |
	{WIDTH{sel3}} & d3 |
	{WIDTH{sel4}} & d4 |
	{WIDTH{sel5}} & d5 |
	{WIDTH{sel6}} & d6 |
	{WIDTH{sel7}} & d7 |
	{WIDTH{sel8}} & d8 |
	{WIDTH{sel9}} & d9 |
	{WIDTH{sel10}} & d10 |
	{WIDTH{sel11}} & d11 |
	{WIDTH{sel12}} & d12 |
	{WIDTH{sel13}} & d13 |
	{WIDTH{sel14}} & d14 |
	{WIDTH{sel15}} & d15 |
	{WIDTH{sel16}} & d16 |
	{WIDTH{sel17}} & d17 |
	{WIDTH{sel18}} & d18 |
	{WIDTH{sel19}} & d19 |
	{WIDTH{sel20}} & d20 |
	{WIDTH{sel21}} & d21 |
	{WIDTH{sel22}} & d22 |
	{WIDTH{sel23}} & d23 ;


endmodule


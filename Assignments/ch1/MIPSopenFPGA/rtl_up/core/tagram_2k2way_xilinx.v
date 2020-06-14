//
//	tagram_2k2way_xilinx : Cilinx TAG-RAM for 2k per way - 2 way
//
//	$Id: \$
//	mips_repository_id: tagram_2k2way_xilinx.v, v 3.4 
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
module tagram_2k2way_xilinx(
	clk,
	line_idx,
	rd_str,
	wr_str,
        early_ce, 
	greset,
	wr_mask,
	wr_data,
	rd_data,
	hci,
	bist_to,
	bist_from);


	/* Inputs */
	input		clk;		// Clock
	input [6:0]	line_idx;	// Read Array Index

	input 		rd_str;		// Read Strobe
	input 		wr_str;		// Write Strobe

	input [1:0]	wr_mask;	// Write Mask
	input [23:0]	wr_data;		// Data for Tag Write
	input [0:0]	bist_to;

        input                                   early_ce;
	input					greset;
	/* Outputs */
	output [47:0]	rd_data;		// output from read
	output [0:0]	bist_from;
        output 		hci;

        assign hci = 1'b0;
	assign bist_from[0] = 1'b0;
	wire [31:0] wide_wr_data = {8'b0, wr_data};
	wire [63:0] wide_rd_data;
	wire [47:0] rd_data = {wide_rd_data[55:32], wide_rd_data[23:0]};

	wire    [1:0]   en;
`ifdef M14K_EARLY_RAM_CE
        assign  en = {2{early_ce}};
`else
        assign  en = {2{wr_str}} & wr_mask | {2{rd_str}};
`endif

	// 256 x 16 (We only need 128 x 16 but this is what Xilinx got)
	RAMB4K_S16 ram__tag_inst0 (
		.WE	(wr_str && wr_mask[0]),
		.EN	(en[0]),
		.RST	(1'b0),
		.CLK	(clk),
		.ADDR	({1'b0,line_idx}),
		.DI	(wide_wr_data[15:0]),
		.DO	(wide_rd_data[15:0])
		);

	RAMB4K_S16 ram__tag_inst1 (
		.WE	(wr_str && wr_mask[0]),
		.EN	(en[0]),
		.RST	(1'b0),
		.CLK	(clk),
		.ADDR	({1'b0,line_idx}),
		.DI	(wide_wr_data[31:16]),
		.DO	(wide_rd_data[31:16])
		);

	RAMB4K_S16 ram__tag_inst2 (
		.WE	(wr_str && wr_mask[1]),
		.EN	(en[1]),
		.RST	(1'b0),
		.CLK	(clk),
		.ADDR	({1'b0,line_idx}),
		.DI	(wide_wr_data[15:0]),
		.DO	(wide_rd_data[47:32])
		);

	RAMB4K_S16 ram__tag_inst3 (
		.WE	(wr_str && wr_mask[1]),
		.EN	(en[1]),
		.RST	(1'b0),
		.CLK	(clk),
		.ADDR	({1'b0,line_idx}),
		.DI	(wide_wr_data[31:16]),
		.DO	(wide_rd_data[63:48])
		);

endmodule



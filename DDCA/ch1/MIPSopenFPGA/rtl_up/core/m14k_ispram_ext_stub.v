// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// Description: m14k_ispram_ext_stub
//       Stub module
//
// $Id: \$
// mips_repository_id: m14k_ispram_ext_stub.mv, v 1.8 
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

`timescale 1ns/1ps
`include "m14k_const.vh"
module m14k_ispram_ext_stub(
	ISP_TagWrStr,
	ISP_Addr,
	ISP_DataTagValue,
	ISP_TagCmpValue,
	ISP_RdStr,
	ISP_DataWrStr,
	SI_ColdReset,
	SI_ClkIn,
	SI_gClkOut,
	SI_Sleep,
	gscanenable,
	gmbinvoke,
	ISP_Present,
	ISP_DataRdValue,
	ISP_TagRdValue,
	ISP_Hit,
	ISP_Stall,
	ISP_ParityEn,
	ISP_WPar,
	ISP_ParPresent,
	ISP_RPar,
	ISP_toisp,
	ISP_fromisp);


        input ISP_TagWrStr;		// ISPRAM Tag Write Strob
	input [19:2]	ISP_Addr;	// Index into tag array
	input [31:0]	ISP_DataTagValue;
	input [23:0]	ISP_TagCmpValue;
	input		ISP_RdStr;	
        input           ISP_DataWrStr;
        input		SI_ColdReset;
        input		SI_ClkIn;
	input		SI_gClkOut;
	input		SI_Sleep;
        input           gscanenable;
        input		gmbinvoke;
    
	// Outputs
	output 		ISP_Present;        // Static output indicating spram is present
	output [31:0]	ISP_DataRdValue;	// Read data
	output [23:0]	ISP_TagRdValue;	// read tag
	output		ISP_Hit;	// This reference hit and was valid
	output 		ISP_Stall;          // Read has not completed

	input		ISP_ParityEn;		// Parity enable for ISPRAM 
	input	[3:0]	ISP_WPar;		// Parity bit for ISPRAM write data 
	output		ISP_ParPresent;		// ISPRAM has parity support
	output	[3:0]	ISP_RPar;		// Parity bits read from ISPRAM

	// external ISP signals
        input  [`M14K_ISP_EXT_TOISP_WIDTH-1:0]   ISP_toisp;   // External input to ISP module
        output [`M14K_ISP_EXT_FROMISP_WIDTH-1:0] ISP_fromisp; // Output from ISP module to external system    

// BEGIN Wire declarations made by MVP
wire [3:0] /*[3:0]*/ ISP_RPar;
wire ISP_ParPresent;
wire ISP_Present;
wire ISP_Stall;
wire [23:0] /*[23:0]*/ ISP_TagRdValue;
wire [31:0] /*[31:0]*/ ISP_DataRdValue;
wire [7:0] /*[7:0]*/ SP_GuestID;
wire [`M14K_ISP_EXT_FROMISP_WIDTH-1:0] /*[0:0]*/ ISP_fromisp;
wire ISP_Hit;
// END Wire declarations made by MVP

    

	assign SP_GuestID[7:0] = 8'h0;

	assign ISP_fromisp[`M14K_ISP_EXT_FROMISP_WIDTH-1:0] = {`M14K_ISP_EXT_FROMISP_WIDTH{1'b0}};
    
	assign ISP_Present = 1'b0;
	assign ISP_DataRdValue [31:0] = 32'h0;
	assign ISP_TagRdValue [23:0] = 24'h0;
	assign ISP_Hit = 1'b0;
	assign ISP_Stall = 1'b0;
	assign ISP_ParPresent = 1'b0;
	assign ISP_RPar [3:0] = 4'b0;

endmodule

// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// Description: m14k_spram_top
//              Module that conditionally instantiates ISPRAM and DSPRAM blocks
//              Can be replaced by m14k_unispram_custom for a unified SPRAM
//
//	$Id: \$
//	mips_repository_id: m14k_spram_top.mv, v 1.10 
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
module m14k_spram_top(
	ISP_TagWrStr,
	ISP_Addr,
	ISP_DataTagValue,
	ISP_TagCmpValue,
	ISP_RdStr,
	ISP_DataWrStr,
	DSP_TagAddr,
	DSP_TagRdStr,
	DSP_TagWrStr,
	DSP_TagCmpValue,
	DSP_DataAddr,
	DSP_DataWrValue,
	DSP_DataRdStr,
	DSP_DataWrStr,
	DSP_DataWrMask,
	DSP_Lock,
	SI_ClkIn,
	SI_gClkOut,
	SI_Sleep,
	SI_ColdReset,
	gscanenable,
	gmbinvoke,
	ISP_Present,
	ISP_DataRdValue,
	ISP_TagRdValue,
	ISP_Hit,
	ISP_Stall,
	DSP_Present,
	DSP_DataRdValue,
	DSP_TagRdValue,
	DSP_Hit,
	DSP_Stall,
	ISP_toisp,
	ISP_fromisp,
	DSP_todsp,
	DSP_fromdsp,
	DSP_ParityEn,
	ISP_ParityEn,
	DSP_WPar,
	ISP_WPar,
	DSP_ParPresent,
	ISP_ParPresent,
	DSP_RPar,
	ISP_RPar);


/*hookios*//* IO declarations added by hookup */
/* End of hookup IO declarations */
/* Wire declarations added by hookup */
/* End of hookup wire declarations */


        input 		ISP_TagWrStr;	// ISPRAM Tag Write Strob
	input [19:2]	ISP_Addr;	// Index into tag array
	input [31:0]	ISP_DataTagValue;
	input [23:0]	ISP_TagCmpValue;
	input		ISP_RdStr;	
        input    	ISP_DataWrStr;
    
	input [19:2]	DSP_TagAddr;	// Index into tag array
	input		DSP_TagRdStr;	// Tag Read Strobe
	input		DSP_TagWrStr;	// Tag Write Strobe
        input [23:0] 	DSP_TagCmpValue;    // Data for tag compare {PA[31:10], 2'b0}
 	
	
	input [19:2]	DSP_DataAddr;       // Index into data array
	input [31:0]	DSP_DataWrValue;	// Data in
	input		DSP_DataRdStr;	// Data Read Strobe
	input 		DSP_DataWrStr;	// Data Write Strobe 
	input [3:0]	DSP_DataWrMask;
	input		DSP_Lock;	// Start a RMW sequence for DSPRAM

	input		SI_ClkIn;		// Clock
	input		SI_gClkOut;
	input		SI_Sleep;
	input		SI_ColdReset;          // Reset
        input		gscanenable;
        input		gmbinvoke;

	/* Outputs */
	output 		ISP_Present;        // Static output indicating spram is present
	output [31:0]	ISP_DataRdValue;	// Read data
	output [23:0]	ISP_TagRdValue;	// read tag
	output		ISP_Hit;	// This reference hit and was valid
	output 		ISP_Stall;          // Read has not completed

	output 		DSP_Present;        // Static output indicating spram is present
	output [31:0]	DSP_DataRdValue;	// Read data
	output [23:0]	DSP_TagRdValue;	// read tag
	output		DSP_Hit;	// This reference hit and was valid
	output 		DSP_Stall;          // Read has not completed

	// external ISP signals
        input  [`M14K_ISP_EXT_TOISP_WIDTH-1:0]    ISP_toisp;   // External input to ISP module
        output [`M14K_ISP_EXT_FROMISP_WIDTH-1:0]  ISP_fromisp; // Output from ISP module to external system    
    
	// external DSP signals
	input  [`M14K_DSP_EXT_TODSP_WIDTH-1:0]    DSP_todsp; // External input to DSP module
	output  [`M14K_DSP_EXT_FROMDSP_WIDTH-1:0] DSP_fromdsp; // Output from DSP module to external system    
	
	input		DSP_ParityEn;		// Parity enable for DSPRAM 
	input		ISP_ParityEn;		// Parity enable for ISPRAM 
	input	[3:0]	DSP_WPar;		// Parity bit for DSPRAM write data 
	input	[3:0]	ISP_WPar;		// Parity bit for ISPRAM write data 
	output		DSP_ParPresent;		// DSPRAM has parity support
	output		ISP_ParPresent;		// ISPRAM has parity support
	output	[3:0]	DSP_RPar;		// Parity bits read from DSPRAM
	output	[3:0]	ISP_RPar;		// Parity bits read from ISPRAM

// BEGIN Wire declarations made by MVP
wire [7:0] /*[7:0]*/ DSP_GuestID;
wire [7:0] /*[7:0]*/ ISP_GuestID;
// END Wire declarations made by MVP

 

	assign ISP_GuestID[7:0] = 8'h0;
	assign DSP_GuestID[7:0] = 8'h0;


/*hookup*/
`M14K_DSPRAM_EXT_MODULE dspram (
	.DSP_DataAddr(DSP_DataAddr),
	.DSP_DataRdStr(DSP_DataRdStr),
	.DSP_DataRdValue(DSP_DataRdValue),
	.DSP_DataWrMask(DSP_DataWrMask),
	.DSP_DataWrStr(DSP_DataWrStr),
	.DSP_DataWrValue(DSP_DataWrValue),
	.DSP_Hit(DSP_Hit),
	.DSP_Lock(DSP_Lock),
	.DSP_ParPresent(DSP_ParPresent),
	.DSP_ParityEn(DSP_ParityEn),
	.DSP_Present(DSP_Present),
	.DSP_RPar(DSP_RPar),
	.DSP_Stall(DSP_Stall),
	.DSP_TagAddr(DSP_TagAddr),
	.DSP_TagCmpValue(DSP_TagCmpValue),
	.DSP_TagRdStr(DSP_TagRdStr),
	.DSP_TagRdValue(DSP_TagRdValue),
	.DSP_TagWrStr(DSP_TagWrStr),
	.DSP_WPar(DSP_WPar),
	.DSP_fromdsp(DSP_fromdsp),
	.DSP_todsp(DSP_todsp),
	.SI_ClkIn(SI_ClkIn),
	.SI_ColdReset(SI_ColdReset),
	.SI_Sleep(SI_Sleep),
	.SI_gClkOut(SI_gClkOut),
	.gmbinvoke(gmbinvoke),
	.gscanenable(gscanenable));

/*hookup*/
`M14K_ISPRAM_EXT_MODULE ispram (
	.ISP_Addr(ISP_Addr),
	.ISP_DataRdValue(ISP_DataRdValue),
	.ISP_DataTagValue(ISP_DataTagValue),
	.ISP_DataWrStr(ISP_DataWrStr),
	.ISP_Hit(ISP_Hit),
	.ISP_ParPresent(ISP_ParPresent),
	.ISP_ParityEn(ISP_ParityEn),
	.ISP_Present(ISP_Present),
	.ISP_RPar(ISP_RPar),
	.ISP_RdStr(ISP_RdStr),
	.ISP_Stall(ISP_Stall),
	.ISP_TagCmpValue(ISP_TagCmpValue),
	.ISP_TagRdValue(ISP_TagRdValue),
	.ISP_TagWrStr(ISP_TagWrStr),
	.ISP_WPar(ISP_WPar),
	.ISP_fromisp(ISP_fromisp),
	.ISP_toisp(ISP_toisp),
	.SI_ClkIn(SI_ClkIn),
	.SI_ColdReset(SI_ColdReset),
	.SI_Sleep(SI_Sleep),
	.SI_gClkOut(SI_gClkOut),
	.gmbinvoke(gmbinvoke),
	.gscanenable(gscanenable));    

endmodule

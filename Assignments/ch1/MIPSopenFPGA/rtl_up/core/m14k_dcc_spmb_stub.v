// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//	Description: m14k_dcc_spmb_stub
//           stub module for Data SPRAM Controller Memory BIST module. 
//
//	$Id: \$
//	mips_repository_id: m14k_dcc_spmb_stub.mv, v 1.7 
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

//verilint 240 off  // Unused input
`include "m14k_const.vh"
module m14k_dcc_spmb_stub(
	gclk,
	greset,
	gmbinvoke,
	gscanenable,
	cpz_dsppresent,
	dsp_size,
	mbdspdatain,
	dspmbinvoke,
	mbdspaddr,
	mbdspread,
	mbdspwrite,
	mbdspbytesel,
	mbdspdata,
	gmbspfail,
	dcc_spmbdone,
	gmb_sp_algorithm);


parameter PARITY =  `M14K_PARITY_ENABLE;

// Calculated parameter

parameter D_BITS = (PARITY == 1) ? `M14K_D_PAR_BITS : `M14K_D_NOPAR_BITS;
parameter D_BYTES = (PARITY == 1) ? `M14K_D_PAR_BYTES : `M14K_D_NOPAR_BYTES;

//Define inputs
	input 		gclk;
	input 		greset;
	input		gmbinvoke;
	input		gscanenable;	// Scan control signal for delay registers
	input   	cpz_dsppresent;	// DSPRAM is present
	input [20:12]	dsp_size;	// DSPRAM line size 

	input [D_BITS-1:0]	mbdspdatain;	// data from DSPRAM

//Define outputs
	output		dspmbinvoke;
	
	output [19:2]   mbdspaddr;	// High group of address for BIST
	
	output		mbdspread;	// readstrb for DSPRAM
	
	output		mbdspwrite;	// writestrb for DSPRAM
	
	output [3:0]	mbdspbytesel;	// One hot byte select for byte write enable
	
	output [D_BITS-1:0] 	mbdspdata;	// 32bit data for write in I-cache

	output		gmbspfail;  	// Asserted to indicate that date test failed
	
	output		dcc_spmbdone;	// Asserted to indicate that all test is done
	input	[7:0]	gmb_sp_algorithm; // Alogrithm selection for DSPRAM BIST controller

// BEGIN Wire declarations made by MVP
wire [3:0] /*[3:0]*/ mbdspbytesel;
wire mbdspwrite;
wire dspmbinvoke;
wire gmbspfail;
wire mbdspread;
wire [19:2] /*[19:2]*/ mbdspaddr;
wire dcc_spmbdone;
wire [D_BITS-1:0] /*[35:0]*/ mbdspdata;
// END Wire declarations made by MVP


assign dspmbinvoke = 1'b0;
assign mbdspaddr[19:2] = 18'b0;
assign mbdspread = 1'b0;
assign mbdspwrite = 1'b0;
assign mbdspbytesel[3:0] = 4'b0;
assign mbdspdata[D_BITS-1:0] = {D_BITS{1'b0}};
assign gmbspfail = 1'b0;
assign dcc_spmbdone = 1'b1;

  
 //VCS coverage off 
// 
	// Wire used by TB to determine whether MBIST module is present
wire SelectDspmb;

assign SelectDspmb = 1'b0;

  //VCS coverage on  
  
// 

 
//verilint 240 on  // Unused input
endmodule

// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//	Description: m14k_icc_mb_stub
//             Instruction Cache Controller Memory BIST stub module.
//
//	$Id: \$
//	mips_repository_id: m14k_icc_mb_stub.mv, v 1.3 
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

// Comments for verilint...Since the ports on this module need to match others,
//  some inputs are unused.
//verilint 240 off  // Unused input

`include "m14k_const.vh"
module m14k_icc_mb_stub(
	gclk,
	greset,
	gmbinvoke,
	gscanenable,
	cpz_icpresent,
	cpz_icnsets,
	cpz_icssize,
	mbdidatain,
	mbtitagin,
	mbwiwsin,
	mbdiwayselect,
	mbtiwayselect,
	imbinvoke,
	mbdiaddr,
	mbtiaddr,
	mbwiaddr,
	mbdiread,
	mbtiread,
	mbwiread,
	mbdiwrite,
	mbtiwrite,
	mbwiwrite,
	mbdidata,
	mbtidata,
	mbwidata,
	gmbdifail,
	gmbtifail,
	gmbwifail,
	icc_mbdone,
	gmb_ic_algorithm);


parameter PARITY =  `M14K_PARITY_ENABLE;

// Calculated parameter

parameter T_BITS = (PARITY == 1) ? `M14K_T_PAR_BITS : `M14K_T_NOPAR_BITS;
parameter D_BITS = (PARITY == 1) ? `M14K_D_PAR_BITS : `M14K_D_NOPAR_BITS;

//Define inputs
	input 		gclk;
	input 		greset;
	input		gmbinvoke;
	input		gscanenable;	// Scan control signal for delay registers
	input   	cpz_icpresent;	// I-cahce is present
	input [2:0]	cpz_icnsets;	// I-cache:  number of sets
	input [1:0]	cpz_icssize;	// I-cache associativity 
					// {0,1,2,3} = Direct-mapped, 2,3,4-way 

	input [D_BITS-1:0]	mbdidatain;	// 32 bit data from way select mux (data RAM)
	input [T_BITS-1:0]	mbtitagin;	// 24 bit tag from way select mux (tag RAM)
	input [5:0]	mbwiwsin;	// 10 bit WS from way select mux (WS RAM)

//Define outputs
	output [3:0]	mbdiwayselect;	// select signal for 4 to 1 mux: select 32 out of 
						// 128 bits data from I-Cahce to be compared
	output [3:0]	mbtiwayselect;	// select signal for 4 to 1 mux: select 32 out of 
						// 128 bits data from I-Cahce to be compared
	
	output		imbinvoke;
	output [13:2]   mbdiaddr;	        // High group of address for BIST
	output [13:4]	mbtiaddr;		// High group of address for BIST
	output [13:4]	mbwiaddr;		// High group of address for BIST
	
	output		mbdiread;		// readstrb for data RAM
	output		mbtiread;		// readstrb for tag RAM
	output		mbwiread;		// readstrb for WS RAM
	
	output		mbdiwrite;		// writestrb for data RAM
	output		mbtiwrite;		// writestrb for tag RAM
	output		mbwiwrite;		// writestrb for WS RAM
	
	output [D_BITS-1:0] 	mbdidata;		// 32bit data for write in I-cache
	output [T_BITS-1:0] 	mbtidata;		// 24bit tag for write in I-cache
	output [5:0] 	mbwidata;		// 6bit WS for write in I-cache
	
	output		gmbdifail;  		// Asserted to indicate that date test failed
	output		gmbtifail;  		// Asserted to indicate that tag test failed
	output		gmbwifail;  		// Asserted to indicate that WS test failed
	output		icc_mbdone;		// Asserted to indicate that all test is done
        input   [7:0]   gmb_ic_algorithm; // Alogrithm selection for I$ BIST controller

// BEGIN Wire declarations made by MVP
wire [3:0] /*[3:0]*/ mbdiwayselect;
wire mbdiwrite;
wire gmbtifail;
wire mbtiwrite;
wire icc_mbdone;
wire [13:2] /*[13:2]*/ mbdiaddr;
wire mbwiwrite;
wire [13:4] /*[13:4]*/ mbwiaddr;
wire [T_BITS-1:0] /*[24:0]*/ mbtidata;
wire mbwiread;
wire [D_BITS-1:0] /*[35:0]*/ mbdidata;
wire gmbwifail;
wire [5:0] /*[5:0]*/ mbwidata;
wire gmbdifail;
wire mbtiread;
wire [13:4] /*[13:4]*/ mbtiaddr;
wire mbdiread;
wire imbinvoke;
wire [3:0] /*[3:0]*/ mbtiwayselect;
// END Wire declarations made by MVP




   // tie off outputs
   assign mbdiwayselect [3:0]	= 4'd0;
   assign mbtiwayselect [3:0]	= 4'd0;
   assign mbdiaddr [13:2]	= 12'd0;
   assign mbtiaddr [13:4]	= 10'd0;
   assign mbwiaddr [13:4]	= 10'd0;
   assign mbdiread		= 1'd0;
   assign mbtiread		= 1'd0;
   assign mbwiread		= 1'd0;
   assign mbdiwrite		= 1'd0;
   assign mbtiwrite		= 1'd0;
   assign mbwiwrite		= 1'd0;
   assign mbdidata [D_BITS-1:0] 	= {D_BITS{1'b0}};
   assign mbtidata [T_BITS-1:0] 	= {T_BITS{1'b0}};
   assign mbwidata [5:0] 	= 6'd0;
   assign gmbdifail		= 1'd0;
   assign gmbtifail		= 1'd0;
   assign gmbwifail		= 1'd0;
   assign icc_mbdone		= 1'd1;
   assign imbinvoke		= 1'd0;

  
 //VCS coverage off 
// 
	// Wire used by TB to determine whether MBIST module is present
	wire SelectIccmb;
   assign SelectIccmb		= 1'b0;
  //VCS coverage on  
  
// 

//verilint 240 on  // Unused input
endmodule

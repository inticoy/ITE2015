// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_dcc_mb_stub
//            Data Cache Controller Memory BIST stub module. 
//
//	$Id: \$
//	mips_repository_id: m14k_dcc_mb_stub.mv, v 1.3 
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
module m14k_dcc_mb_stub(
	gclk,
	greset,
	gmbinvoke,
	gscanenable,
	cpz_dcpresent,
	cpz_dcnsets,
	cpz_dcssize,
	mbdddatain,
	mbtdtagin,
	mbwdwsin,
	mbddwayselect,
	mbtdwayselect,
	dmbinvoke,
	mbddaddr,
	mbtdaddr,
	mbwdaddr,
	mbddread,
	mbtdread,
	mbwdread,
	mbddwrite,
	mbtdwrite,
	mbwdwrite,
	mbddbytesel,
	mbdddata,
	mbtddata,
	mbwddata,
	gmbddfail,
	gmbtdfail,
	gmbwdfail,
	dcc_mbdone,
	gmb_dc_algorithm);


parameter PARITY =  `M14K_PARITY_ENABLE;

// Calculated parameter

parameter T_BITS = (PARITY == 1) ? `M14K_T_PAR_BITS : `M14K_T_NOPAR_BITS;
parameter D_BITS = (PARITY == 1) ? `M14K_D_PAR_BITS : `M14K_D_NOPAR_BITS;
parameter D_BYTES = (PARITY == 1) ? `M14K_D_PAR_BYTES : `M14K_D_NOPAR_BYTES;

//Define inputs
	input 		gclk;
	input 		greset;
	input		gmbinvoke;
	input		gscanenable;	// Scan control signal for delay registers
	input   	cpz_dcpresent;	// I-cahce is present
	input [2:0]	cpz_dcnsets;	// I-cache:  number of sets<F19>
	input [1:0]	cpz_dcssize;	// I-cache associatdvity 
					// {0,1,2,3} = Direct-mapped, 2,3,4-way 

	input [D_BITS-1:0]	mbdddatain;	// 32 bit data from way select mux (data RAM)
	input [T_BITS-1:0]	mbtdtagin;	// 24 bit tag from way select mux (tag RAM)
	input [13:0]	mbwdwsin;	// 10 bit WS from way select mux (WS RAM)

//Define outputs
	output [3:0]	mbddwayselect;	// select signal for 4 to 1 mux: select 32 out of 
					// 128 bits data from D-Cache to be compared
	output [3:0]	mbtdwayselect;	// select signal for 4 to 1 mux: select 24 out of 
					// 96 bits data from D-Tag to be compared
	output		dmbinvoke;	
	output [13:2]   mbddaddr;	// High group of address for BIST
	output [13:4]	mbtdaddr;	// High group of address for BIST
	output [13:4]	mbwdaddr;	// High group of address for BIST
	
	output		mbddread;	// readstrb for data RAM
	output		mbtdread;	// readstrb for tag RAM
	output		mbwdread;	// readstrb for WS RAM
	
	output		mbddwrite;	// writestrb for data RAM
	output		mbtdwrite;	// writestrb for tag RAM
	output		mbwdwrite;	// writestrb for WS RAM
	
	
	output [3:0]	mbddbytesel;	// One hot byte select for byte write enable
	output [D_BITS-1:0] 	mbdddata;	// 32bit data for write in I-cache
	output [T_BITS-1:0] 	mbtddata;	// 24bit tag for write in I-cache
	output [13:0] 	mbwddata;	// 6bit WS for write in I-cache

	
	output		gmbddfail;  	// Asserted to inddcate that date test failed
	output		gmbtdfail;  	// Asserted to inddcate that tag test failed
	output		gmbwdfail;  	// Asserted to inddcate that WS test failed
	
	output		dcc_mbdone;	// Asserted to inddcate that all test is done

        input   [7:0]   gmb_dc_algorithm; // Alogrithm selection for I$ BIST controller

// BEGIN Wire declarations made by MVP
wire mbwdwrite;
wire [13:4] /*[13:4]*/ mbtdaddr;
wire [13:0] /*[13:0]*/ mbwddata;
wire mbtdwrite;
wire [D_BITS-1:0] /*[35:0]*/ mbdddata;
wire [T_BITS-1:0] /*[24:0]*/ mbtddata;
wire dcc_mbdone;
wire dmbinvoke;
wire gmbtdfail;
wire [3:0] /*[3:0]*/ mbddbytesel;
wire mbddwrite;
wire gmbddfail;
wire mbtdread;
wire mbwdread;
wire [13:4] /*[13:4]*/ mbwdaddr;
wire gmbwdfail;
wire mbddread;
wire [3:0] /*[3:0]*/ mbtdwayselect;
wire [13:2] /*[13:2]*/ mbddaddr;
wire [3:0] /*[3:0]*/ mbddwayselect;
// END Wire declarations made by MVP



   assign mbddwayselect  [3:0]	= 4'd0;
   assign mbtdwayselect  [3:0]	= 4'd0;
   assign mbddaddr  [13:2]     = 12'd0;
   assign mbtdaddr  [13:4]	= 10'd0;
   assign mbwdaddr  [13:4]	= 10'd0;
   assign mbddread 		= 1'd0;
   assign mbtdread 		= 1'd0;
   assign mbwdread 		= 1'd0;
   assign mbddwrite 		= 1'd0;
   assign mbtdwrite 		= 1'd0;
   assign mbwdwrite 		= 1'd0;
   assign mbddbytesel  [3:0]	= 4'd0;
   assign mbdddata  [D_BITS-1:0] 	= {D_BITS{1'b0}};
   assign mbtddata  [T_BITS-1:0] 	= {T_BITS{1'b0}};
   assign mbwddata  [13:0] 	= 14'd0;

   assign gmbddfail 		= 1'd0;
   assign gmbtdfail 		= 1'd0;
   assign gmbwdfail 		= 1'd0;
   assign dcc_mbdone 		= 1'd1;
   assign dmbinvoke		= 1'd0;

	
  
 //VCS coverage off 
// 
	// Wire used by TB to determine whether MBIST module is present
   wire		SelectDccmb;
   assign SelectDccmb		= 1'b0;
  //VCS coverage on  
  
// 


//verilint 240 on  // Unused input
endmodule

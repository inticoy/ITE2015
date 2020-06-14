// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//      Description: m14k_ejt_tap_fdcstub
//      EJTAG TAP FDCSTUB module
//
//      $Id: \$
//      mips_repository_id: m14k_ejt_tap_fdcstub.mv, v 1.4 
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

//verilint 528 off  // Variable set but not used.

module m14k_ejt_tap_fdcstub(
	gclk,
	gfclk,
	greset,
	gscanenable,
	cdmm_fdcread,
	cdmm_fdcgwrite,
	cdmm_fdc_hit,
	mmu_cdmm_kuc_m,
	AHB_EAddr,
	cdmm_wdata_xx,
	cpz_kuc_m,
	fdc_rdata_nxt,
	fdc_present,
	fdc_rxdata_tck,
	fdc_rxdata_rdy_tck,
	fdc_rxdata_ack_gclk,
	fdc_txdata_gclk,
	fdc_txdata_rdy_gclk,
	fdc_txdata_ack_tck,
	fdc_txtck_used_tck,
	fdc_rxint_tck,
	fdc_rxint_ack_gclk,
	ej_fdc_int,
	fdc_busy_xx);


   input         gclk;
   input         gfclk;
   input 	 greset;      
   input         gscanenable;         

     input 	cdmm_fdcread;
     input	cdmm_fdcgwrite;
     input	cdmm_fdc_hit;
     input	mmu_cdmm_kuc_m;
     input   [14:2]  AHB_EAddr;
     input [31:0] cdmm_wdata_xx;      
     input       cpz_kuc_m;
   output [31:0] fdc_rdata_nxt; // CDMM read data
   output	fdc_present;
   
   // Async signals to/from TCK module
   input [35:0]  fdc_rxdata_tck;       // Data value
   input 	 fdc_rxdata_rdy_tck;   // Data is ready
   output 	 fdc_rxdata_ack_gclk;  // Data has been accepted

   output [35:0] fdc_txdata_gclk;      // Data value
   output 	 fdc_txdata_rdy_gclk;  // Data is ready
   input 	 fdc_txdata_ack_tck;   // Data has been accepted

   input 	 fdc_txtck_used_tck;   // Tx TCK buffer occupied
   input 	 fdc_rxint_tck;        // FDC Interrupt Request
   output 	 fdc_rxint_ack_gclk;   // Int. Req. seen

   output 	 ej_fdc_int;       // Fast Debug Channel Interrupt
   output 	 fdc_busy_xx;          // Wakeup to transfer fast debug channel data

// BEGIN Wire declarations made by MVP
wire fdc_rxdata_ack_gclk;
wire ej_fdc_int;
wire fdc_busy_xx;
wire [35:0] /*[35:0]*/ fdc_txdata_gclk;
wire [31:0] /*[31:0]*/ fdc_rdata_nxt;
wire fdc_rxint_ack_gclk;
wire fdc_present;
wire fdc_txdata_rdy_gclk;
// END Wire declarations made by MVP


//
wire fdc_rx_read = 1'b0;
wire fdc_rxfull = 1'b0;
wire rx_array_empty = 1'b0;
wire tx_array_empty = 1'b0;
wire [35:0] rx_data_out = 36'b0;
wire tx_array_full = 1'b0;
wire fdc_rxfull_tap0 = 1'b0;
//

assign fdc_rdata_nxt[31:0] = 32'b0;
assign fdc_present =1'b0;
assign fdc_rxdata_ack_gclk = 1'b0;
assign fdc_txdata_gclk[35:0] = 36'b0;
assign fdc_txdata_rdy_gclk = 1'b0;
assign fdc_rxint_ack_gclk = 1'b0;
assign ej_fdc_int = 1'b0;
assign fdc_busy_xx =1'b0;
//verilint 240 on  // Unused input
endmodule
   
//verilint 528 on  // Variable set but not used.

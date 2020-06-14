// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//      Description: m14k_ejt_tap_pcsam
//      EJTAG TAP PC SAMPLE module 
//
//      $Id: \$
//      mips_repository_id: m14k_ejt_tap_pcsamstub.mv, v 1.3 
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


module m14k_ejt_tap_pcsamstub(
	gclk,
	greset,
	gscanenable,
	cpz_guestid,
	cpz_epc_w,
	mpc_cleard_strobe,
	mpc_exc_w,
	mmu_asid,
	icc_pm_icmiss,
	edp_iva_i,
	pc_sync_period,
	pc_sync_period_diff,
	pcse,
	new_pcs_ack_tck,
	pc_im,
	pcsam_val,
	new_pcs_gclk,
	pcs_present);



// Global Signals
  input         gclk;
  input   	greset;         // reset
  input         gscanenable;         

  
// Signals from ALU 
  input [7:0]   cpz_guestid; 
  input [31:0]  cpz_epc_w;      // PC of the graduating instruction from W stage
  input		mpc_cleard_strobe; //monitoring bit for instruction completion
  input		mpc_exc_w;      //Exception in W-stage
  input [7:0]   mmu_asid;
  input         icc_pm_icmiss;  // Perf. monitor I$ miss 
  input  [31:0] edp_iva_i;      // Instn virtual address (I-stage)
  
// Ej Signals  
  input [2:0]   pc_sync_period;       // 3 bits from debug ctl register which 
                                      // specify the sync period
  input         pc_sync_period_diff;  // indicates write to pc sync period 
                                      // used to reset the pc sample counter
  input         pcse;                 // PC Sample Write Enable Bit
  input         new_pcs_ack_tck;      // tck domain accepts the new pcsam_val
  input         pc_im;                // config PC sampling to capture all excuted addresses or only those that miss the instruction cache
  // Outputs  
  output [55:0] pcsam_val; // PC Value which has been sampled
  output        new_pcs_gclk;    // gclk domain has a new pcsam_val
  output	pcs_present;

// BEGIN Wire declarations made by MVP
wire new_pcs_gclk;
wire pcs_present;
wire [55:0] /*[55:0]*/ pcsam_val;
// END Wire declarations made by MVP

 
assign pcsam_val[55:0] = 56'b0;
assign new_pcs_gclk =1'b0;
assign pcs_present =1'b0;

//verilint 240 on  // Unused input
endmodule

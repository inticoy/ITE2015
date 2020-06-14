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
//      mips_repository_id: m14k_ejt_tap_pcsam.mv, v 1.4 
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


module m14k_ejt_tap_pcsam(
	gclk,
	greset,
	gscanenable,
	cpz_epc_w,
	mpc_cleard_strobe,
	mpc_exc_w,
	mmu_asid,
	cpz_guestid,
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
  input [31:0]  cpz_epc_w;      // PC of the graduating instruction from W stage
  input		mpc_cleard_strobe; //monitoring bit for instruction completion
  input		mpc_exc_w;      //Exception in W-stage
  input [7:0]   mmu_asid;
  input [7:0]   cpz_guestid;
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
wire pcse_deasserted;
wire pcse_reg;
wire [55:0] /*[55:0]*/ sampled_pc;
wire [55:0] /*[55:0]*/ pcsam_reg;
wire [55:0] /*[55:0]*/ pcsam_imiss;
wire [12:0] /*[12:0]*/ counter;
wire counter_reset;
wire pcs_present;
wire pending_sample_pc;
wire counter_overflow;
wire sample_en_pc;
// END Wire declarations made by MVP


  wire		sample_st_send;
  wire          inst_complete_w;
  wire		sample_st_pend;
  wire		sync_wakeup;
  assign pcs_present = 1'b1;
   mvp_cregister_wide #(56) _pcsam_reg_55_0_(pcsam_reg[55:0],gscanenable, inst_complete_w && pcse, gclk,
                                     {cpz_guestid[7:0],8'b0,mmu_asid[7:0], cpz_epc_w[31:0]});
   mvp_cregister_wide #(56) _pcsam_imiss_55_0_(pcsam_imiss[55:0],gscanenable, pc_im && icc_pm_icmiss && pcse, gclk,
				    {cpz_guestid[7:0],8'b0,mmu_asid[7:0], edp_iva_i[31:0]});
   assign sampled_pc[55:0] = pc_im ? pcsam_imiss[55:0] : pcsam_reg[55:0];
   mvp_register #(1) _pcse_reg(pcse_reg, gclk, pcse);
   assign pcse_deasserted = !pcse && pcse_reg;


   // counter related logic to detect overflow and increment counter
   // pcse starts/stops the counter, but when its disabled, we take an extra cycle to clear the count
   assign counter_overflow = (counter[12:5] == (8'd1 << pc_sync_period));
   assign counter_reset = greset || counter_overflow || pcse_deasserted  || pc_sync_period_diff;
   mvp_cregister_wide #(13) _counter_12_0_(counter[12:0],gscanenable,  pcse_reg || greset, gclk,
                                  counter_reset ? 13'd1 : counter[12:0] + 13'd1);

   // When counter fires, set pending_sample until it is sampled
   mvp_cregister #(1) _pending_sample_pc(pending_sample_pc,greset || counter_overflow  || sample_en_pc, gclk,
                              !greset && counter_overflow  && !sample_en_pc);

   // Enable sampling only when there is something valid to sample and when we are allowed to change the value
   // NOTE: We *are* allowed to change the sample even if ack is asserted - we just cant transfer to tck until the protocol has completed.
   assign inst_complete_w = mpc_cleard_strobe && !mpc_exc_w ;
   assign sample_en_pc = (pending_sample_pc || counter_overflow ) && !sample_st_send;

   m14k_ejt_async_snd #(56,1) pcsam_async_snd (
                                              .gscanenable(gscanenable),
                                              .gclk( gclk),
                                              .gfclk( gclk),            // Do not need wakeup logic on gfclk
                                              .reset(greset),
                                              .reset_unsync(1'b0),
                                              .sync_data_in(sampled_pc[55:0]),
                                              .sync_sample(sample_en_pc),
                                              .sync_sample_st_send(sample_st_send),
                                              .sync_sample_st_pend(sample_st_pend),
                                              .sync_wakeup(sync_wakeup),
                                              .async_data_out(pcsam_val),
                                              .async_data_rdy(new_pcs_gclk),
                                              .async_data_ack(new_pcs_ack_tck)
                                              );


//verilint 528 off      // Variable set but not used
wire unused_ok;
  assign unused_ok = &{1'b0,
                sync_wakeup,
                sample_st_pend};
//verilint 528 on       // Variable set but not used
  
endmodule

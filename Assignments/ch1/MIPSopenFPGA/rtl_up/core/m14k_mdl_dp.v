// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// Description: m14k_mdl_dp 
//      MDU_lite Datapath Module
//
// $Id: \$
// mips_repository_id: m14k_mdl_dp.mv, v 1.2 
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
module m14k_mdl_dp(
	gclk,
	gscanenable,
	edp_abus_e,
	edp_bbus_e,
	mdu_active,
	dm_cond,
	hi_cond,
	lo_cond,
	b_inv_sel,
	c_in,
	shft_in,
	up_dwn_sel,
	rp_dm_qp_sel,
	hilo_rp_zero_sel,
	sum_qp_sel,
	zero_rp_sum_sel,
	shift_rp_sel,
	shift_qp_sel,
	qpnxt_abus_sel,
	qpnxt_qp_sel,
	qp_rpnxt_rp_sel,
	hi_lo_sel,
	mdu_res_w,
	carry_out,
	rp_sum_sgn,
	shift_out,
	dm_sgn,
	qp_sgn,
	qp_lsb,
	qp_lsb_early);



   /* Inputs */

   // All xxxUpdate input are active high.
   // All Select signals for multiplexer's select first one on 1 and second on 0.
   // 3-wayu select user bit 1 for first, and bit 0 for next two.

   // External inputs
   input 	 gclk;			// Global clock
   input 	 gscanenable;		// gscanenable
   input [31:0]  edp_abus_e;		// Register RS from register file
   input [31:0]  edp_bbus_e;		// Register RT from register file

   // Register update controls
   input 	 mdu_active;		// Gating signal for ucregisters
   input 	 dm_cond;		// Register update to dm.
   input 	 hi_cond;		// Register update to hi
   input 	 lo_cond;		// Register update to lo

   // Logic block controls
   input 	 b_inv_sel;		// Invert all bits on B input to adder
   input 	 c_in;			// Carry in to adder
   input 	 shft_in;		// Bit to shift in on Up/Down shift
   input 	 up_dwn_sel;		// Shift direction selecter

   // Multiplexer controls
   input [1:0] 	 rp_dm_qp_sel;		// B input selector
   input [1:0] 	 hilo_rp_zero_sel;	// A input selector
   input 	 sum_qp_sel;		// qp_sum selector
   input [1:0] 	 zero_rp_sum_sel;	// rp_sum selector
   input 	 shift_rp_sel;		// rp_nxt selector
   input 	 shift_qp_sel;		// qp_nxt selector
   input 	 qpnxt_abus_sel;	// qp_abus_nxt selector
   input 	 qpnxt_qp_sel;		// lo_nxt selector
   input [1:0] 	 qp_rpnxt_rp_sel;	// hi_nxt selector
   input 	 hi_lo_sel;		// hilo selector
   
   /* Outputs */
   
   // External outputs
   output [31:0] mdu_res_w;		// Destination register RD to register file
   
   // state machine result inputs
   output 	 carry_out;		// Carry out from adder
   output 	 rp_sum_sgn; 	 	// MSB of rp before shift
   output 	 shift_out;		// Drop out from shifter on down shift
   output 	 dm_sgn;		// dm sign bit
   output 	 qp_sgn;		// qp sign bit
   output 	 qp_lsb;		// qp LSB bit (for Booth)
   output 	 qp_lsb_early;		// qp LSB bit (for Booth)

// BEGIN Wire declarations made by MVP
wire [31:0] /*[31:0]*/ qp;
wire [31:0] /*[31:0]*/ rp;
wire [31:0] /*[31:0]*/ qp_shift;
wire [31:0] /*[31:0]*/ rp_nxt;
wire qp_lsb_early;
wire [31:0] /*[31:0]*/ hi;
wire shift_out;
wire [31:0] /*[31:0]*/ rp_sum;
wire [31:0] /*[31:0]*/ b_in;
wire [31:0] /*[31:0]*/ hilo;
wire qp_sgn;
wire [31:0] /*[31:0]*/ lo;
wire [31:0] /*[31:0]*/ qp_sum;
wire [31:0] /*[31:0]*/ rp_shift;
wire [31:0] /*[31:0]*/ hi_nxt;
wire [31:0] /*[31:0]*/ qp_nxt;
wire [31:0] /*[31:0]*/ pre_inv_b_in;
wire [31:0] /*[31:0]*/ a_in;
wire dm_sgn;
wire [31:0] /*[31:0]*/ dm;
wire [31:0] /*[31:0]*/ lo_nxt;
wire rp_sum_sgn;
wire [31:0] /*[31:0]*/ qp_abus_nxt;
wire qp_lsb;
wire [31:0] /*[31:0]*/ mdu_res_w;
// END Wire declarations made by MVP

   
   /* Inouts */

   /* End I/O's */

   /* Wires */
   wire [31:0] 	 sum;

   //
   // Datapass Top -> Down 
   //

   // Divisor/Multiplicand register. Is loaded directly from edp_bbus_e with RT.
   mvp_cregister_wide #(32) _dm_31_0_(dm[31:0],gscanenable, dm_cond, gclk, edp_bbus_e);
   assign dm_sgn = dm[31];

   // A input to Adder.
   assign a_in [31:0] = hilo_rp_zero_sel[1] ? hilo :
		   hilo_rp_zero_sel[0] ? rp : 32'd0;

   // B input to Adder before possible invert.
   assign pre_inv_b_in [31:0] = rp_dm_qp_sel[1] ? rp :
			 rp_dm_qp_sel[0] ? dm : qp;

   // Invert B input if subtraction is needed
   assign b_in [31:0] = b_inv_sel ? ~pre_inv_b_in : pre_inv_b_in;

   // 32-bit FullAdder
   // c_in are controlled from controller mdc_lite.
   // carry_out is send to controller mdc_lite.
   `M14K_MDL_ADD mdl_add ( .a(a_in),
			 .b(b_in),
			 .ci(c_in),
			 .s(sum),
			 .co(carry_out)
			 );
   
   // Select which calculated result to use for Remainder/Product (HI).
   assign rp_sum [31:0] = zero_rp_sum_sel[1] ? 32'd0 :
		   zero_rp_sum_sel[0] ? rp : sum;
   assign rp_sum_sgn = rp_sum[31];

   // Select which calculated result to use for Quotient/Product (LO).
   // edp_abus_e is RS input to MDU.
   assign qp_sum [31:0] = sum_qp_sel ? sum : qp;

   // Shift rp_sum:qp_sum Up or down to generate rp_shift:qp_shift.
   // UP (divide algorithm): shft_in to LSB controlled from controller mdl_ctl (shift_out not used).
   // DOWN (multiply algorithm): shft_in to MSB, send LSB to controller as shift_out.
   assign rp_shift [31:0] = up_dwn_sel ? {rp_sum[30:0], qp_sum[31]} : {shft_in, rp_sum[31:1]};
   assign qp_shift [31:0] = up_dwn_sel ? {qp_sum[30:0], shft_in} : {rp_sum[0], qp_sum[31:1]};
   assign shift_out = qp_sum[0];

   // Select wheater to use Shifted or calculated result for next version of Rp and Qp.
   assign rp_nxt [31:0] = shift_rp_sel ? rp_shift : rp_sum;
   assign qp_nxt [31:0] = shift_qp_sel ? qp_shift : qp_sum;

   // Sekect between qp_nxt and Abus for Qp.
   assign qp_abus_nxt [31:0] = qpnxt_abus_sel ? qp_nxt : edp_abus_e;
   
   // Remainder/Product (HI) register.
   mvp_ucregister_wide #(32) _rp_31_0_(rp[31:0],gscanenable, mdu_active, gclk, rp_nxt);

   // Quotient/Product (LO) register.
   mvp_ucregister_wide #(32) _qp_31_0_(qp[31:0],gscanenable, mdu_active, gclk, qp_abus_nxt);
   assign qp_sgn = qp[31];
   assign qp_lsb = qp[0];
   assign qp_lsb_early = qp_abus_nxt[0];

   // Select what to use if HI is reloaded. rp is used on MTHI.
   assign hi_nxt [31:0] = qp_rpnxt_rp_sel[1] ? qp :
		  qp_rpnxt_rp_sel[0] ? rp_nxt : rp;

   // Select what to use if LO is reloaded. 
   assign lo_nxt [31:0] = qpnxt_qp_sel ? qp_nxt : qp;

   // HI and LO registers. Conditionally loaded.
   mvp_cregister_wide #(32) _hi_31_0_(hi[31:0],gscanenable, hi_cond, gclk, hi_nxt);
   mvp_cregister_wide #(32) _lo_31_0_(lo[31:0],gscanenable, lo_cond, gclk, lo_nxt);

   // Select between HI and LO register MACC commands or for Move From HI/LO.
   assign hilo [31:0] = hi_lo_sel ? hi : lo;

   // Final output assign.
   assign mdu_res_w [31:0] = hilo;

endmodule

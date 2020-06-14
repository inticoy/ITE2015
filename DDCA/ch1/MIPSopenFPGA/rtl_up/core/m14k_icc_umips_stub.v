// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_icc_umips_stub 
//             Stub module to replace UMIPS decompressor
//             Parameterized by width
//
//      $Id: \$
//      mips_repository_id: m14k_icc_umips_stub.mv, v 1.27 
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

// Comments for verilint
// This is a stub module so most of the inputs are unused
//verilint 240 off  // Unused input
//verilint 175 off  // Unused parameter

`include "m14k_const.vh"
module m14k_icc_umips_stub(
	gscanenable,
	raw_instn_in,
	instn_in,
	cpz_rbigend_i,
	cpz_mx,
	umipsmode_i,
	umips_active,
	edp_ival_p,
	mpc_run_ie,
	mpc_fixupi,
	mpc_isachange0_i,
	mpc_isachange1_i,
	mpc_atomic_e,
	mpc_hw_ls_i,
	mpc_sel_hw_e,
	mpc_hold_epi_vec,
	mpc_epi_vec,
	mpc_int_pref,
	mpc_chain_take,
	mpc_tint,
	kill_i,
	ibe_kill_macro,
	mpc_annulds_e,
	precise_ibe,
	mpc_nonseq_e,
	kill_e,
	greset,
	hit_fb,
	hold_imiss_n,
	imbinvoke,
	data_line_sel,
	spram_sel,
	icc_imiss_i,
	icc_umipsconfig,
	mpc_itqualcond_i,
	cdmm_mputrigresraw_i,
	biu_ibe,
	poten_be,
	poten_parerr,
	gclk,
	cpz_vz,
	instn_out,
	icc_umipsri_e,
	icc_macro_e,
	icc_macroend_e,
	icc_nobds_e,
	icc_macrobds_e,
	icc_pcrel_e,
	icc_umipspresent,
	icc_halfworddethigh_i,
	icc_halfworddethigh_fifo_i,
	umipsfifo_imip,
	umipsfifo_ieip2,
	umipsfifo_ieip4,
	umipsfifo_null_i,
	umipsfifo_null_raw,
	umipsfifo_stat,
	macro_jr,
	umips_rdpgpr,
	icc_dspver_i,
	umips_sds,
	isachange1_i_reg,
	isachange0_i_reg,
	slip_n_nhalf,
	icc_umips_instn_i,
	raw_instn_in_postws,
	isachange_waysel,
	icc_dwstb_reg,
	requalify_parerr);

// synopsys template
	parameter WIDTH=5;
	parameter MEMIDX=0;     // dummy parameter to match "ports" with smodule
	
	/* Inputs */
        input			gscanenable;
	input [(48*WIDTH-1):0]	raw_instn_in;	// Raw Data from I$/FB
	input [47:0]		instn_in;
        input			cpz_rbigend_i;
	input		cpz_mx;		// indicates dsp sw enable
	input			umipsmode_i;
	input			umips_active;	// operating in UMIPS mode
	input [3:1]		edp_ival_p;

	input			mpc_run_ie;
	input			mpc_fixupi;
	input			mpc_isachange0_i;  // Indicates isa change happening during abnormal pipeline process
	input			mpc_isachange1_i;  // Indicates isa change happening during abnormal pipeline process
	input			mpc_atomic_e;		// atomic instruction at e stage
	input			mpc_hw_ls_i;		// iap/iae at i stage
	input			mpc_sel_hw_e;		// iap/iae at e stage
	input			mpc_hold_epi_vec;	// iae vector indicator
	input			mpc_epi_vec;		// 
	input			mpc_int_pref;		// interrupt prefetched indicator
	input			mpc_chain_take;		// tail chain taken
	input			mpc_tint;		// interrupt accepted
	input			kill_i;			// i stage instruction killed
	input			ibe_kill_macro;		// kill macro signal is current instn is an ibe
	input			mpc_annulds_e;		// delay slot instruction killed
	input			precise_ibe;		// incoming bus error
	input			mpc_nonseq_e;		// instruction stream is non sequential
	input			kill_e;			// e stage instruction killed
	input			greset;

	input			hit_fb;
	input			hold_imiss_n;
	input			imbinvoke;
	input [3:0]		data_line_sel;
	input [3:0]		spram_sel;
	input			icc_imiss_i;
	input [1:0]		icc_umipsconfig;
	input			mpc_itqualcond_i;
	input			cdmm_mputrigresraw_i;
	input			biu_ibe;
	input			poten_be;
	input			poten_parerr;

	input		 gclk;
	input		 cpz_vz;
	
	/* Outputs */
	output [(48*WIDTH-1):0]	instn_out;
	output	icc_umipsri_e;	// Reserved instn detected (including macro ri)
	output	icc_macro_e;	// Macro instn detected
	output	icc_macroend_e; // last macro issued on e-stage
	output	icc_nobds_e;	// No delay slot (umips branch or compact jump)
	output	icc_macrobds_e; // jraddiusp in e-stage
        output	icc_pcrel_e;	// PC relative instn
	output	icc_umipspresent;
	output	icc_halfworddethigh_i; 		// high half of i-stage instruction is 16b
	output	icc_halfworddethigh_fifo_i;	// instruction in fifo is 16b
	output	umipsfifo_imip;			// memory incr indicator (p-stage)
	output	umipsfifo_ieip2;		// PC incr+2 control
	output	umipsfifo_ieip4;		// PC incr+4 control
	output	umipsfifo_null_i;		// umips instruction slip occured
	output umipsfifo_null_raw;//raw instruction slip. only used for tracing. no loading at core level.
	output [3:0] umipsfifo_stat;		// umips fifo fullness
	output	macro_jr;			// macro is performing jump
	output [4:0] umips_rdpgpr;
	output [4:0] icc_dspver_i;
	output	umips_sds;			// short delay slot
	output isachange1_i_reg;
	output isachange0_i_reg;
	output slip_n_nhalf;
	output [31:0] icc_umips_instn_i;
	output [31:0] raw_instn_in_postws;	// raw un-recoded instn
	output [3:0] isachange_waysel;
	input icc_dwstb_reg;
	input requalify_parerr;

// BEGIN Wire declarations made by MVP
wire icc_macrobds_e;
wire [4:0] /*[4:0]*/ icc_dspver_i;
wire umipsfifo_null_i;
wire [3:0] /*[3:0]*/ umipsfifo_stat;
wire icc_macro_e;
wire [239:0] /*[239:0]*/ instn_out240;
wire slip_n_nhalf;
wire icc_macroend_e;
wire [31:0] /*[31:0]*/ raw_instn_in_postws;
wire icc_umipsri_e;
wire umipsfifo_ieip2;
wire icc_nobds_e;
wire umips_sds;
wire [31:0] /*[31:0]*/ icc_umips_instn_i;
wire umipsfifo_ieip4;
wire isachange0_i_reg;
wire [3:0] /*[3:0]*/ isachange_waysel;
wire umipsfifo_imip;
wire [(48*WIDTH-1):0] /*[239:0]*/ instn_out;
wire umipsfifo_null_raw;
wire icc_halfworddethigh_fifo_i;
wire [4:0] /*[4:0]*/ umips_rdpgpr;
wire isachange1_i_reg;
wire icc_umipspresent;
wire macro_jr;
wire icc_halfworddethigh_i;
wire [239:0] /*[239:0]*/ instn_in240;
wire icc_pcrel_e;
// END Wire declarations made by MVP

	assign raw_instn_in_postws [31:0] = 32'b0;
	assign isachange_waysel [3:0] = 4'b0;

	// End of I/O

	assign instn_in240 [239:0] = {raw_instn_in};
	
	assign instn_out240 [239:0] = instn_in240;
	
	assign instn_out [(48*WIDTH-1):0] = instn_out240[(48*WIDTH-1):0];

	assign icc_umipsri_e = 1'b0;
	assign icc_macro_e = 1'b0;
	assign icc_macroend_e = 1'b0;
	assign icc_nobds_e = 1'b0;
	assign icc_macrobds_e = 1'b0;
	assign icc_umipspresent = 1'b0;
	assign icc_halfworddethigh_i = 1'b0;
	assign icc_halfworddethigh_fifo_i = 1'b0;
	assign icc_pcrel_e = 1'b0;
	assign umipsfifo_imip = 1'b0;
	assign umipsfifo_ieip2 = 1'b0;
	assign umipsfifo_ieip4 = 1'b0;
	assign umipsfifo_null_i = 1'b0;
	assign umipsfifo_null_raw = 1'b0;
	assign umipsfifo_stat[3:0] = 4'b0;
	assign umips_rdpgpr[4:0] = 5'b00000;
	assign icc_dspver_i[4:0] = 5'b0;
	assign umips_sds = 1'b0;
	assign macro_jr = 1'b0;
	assign isachange1_i_reg = 1'b0;
	assign isachange0_i_reg = 1'b0;
	assign slip_n_nhalf = 1'b0;
	assign icc_umips_instn_i[31:0] = 32'b0;

	  
 //VCS coverage off 
	//
	//
	// dummy signals for umips instn tracing hotwires
	wire [12:0] sidebits = 13'b0;
        wire [31:0] ci0_f = 32'b0;
        wire [31:0] ci1_f = 32'b0;
        wire [31:0] ci2_f = 32'b0;
        wire [31:0] ci3_f = 32'b0;
        wire [31:0] ci4_f = 32'b0;
	//
 //VCS coverage on 
	 
	// 
	
//verilint 240 on  // Unused input
//verilint 175 on  // Unused parameter
endmodule // m14k_icc_umips_stub



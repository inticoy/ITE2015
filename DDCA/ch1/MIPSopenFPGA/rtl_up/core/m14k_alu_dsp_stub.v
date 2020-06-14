// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
////////////////////////////////////////////////////////////////////////////////
//
//	Description: m14k_alu_dsp
//		Datapath block for 32 bit ALU dsp instructions	
//
//	$Id: \$
//	mips_repository_id: m14k_alu_dsp_stub.mv, v 1.8 
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
`include "m14k_dsp_const.vh"

module m14k_alu_dsp_stub(
	gclk,
	greset,
	gscanenable,
	alu_run_rf,
	alu_run_ag,
	alu_run_ex,
	alu_run_ms,
	alu_run_er,
	alu_stall_ex,
	alu_inst_valid_rf,
	alu_inst_valid_ag,
	alu_inst_valid_ex,
	alu_inst_valid_ms,
	alu_inst_valid_er,
	alu_nullify_ag,
	alu_nullify_ex,
	alu_nullify_ms,
	alu_nullify_er,
	dec_ir_ag,
	dec_ir_rf,
	mfttr_minus_one_ag,
	mpc_predec_e,
	mpc_dspinfo_e,
	MDU_info_e,
	dp_rs_ex,
	dp_rt_ex,
	dp_cpipe_ex,
	dp_add_ex,
	dp_shift_ex,
	dp_shift_plus_ex,
	dp_bshift_ex,
	dp_add_c31_ex,
	dp_add_c32_ex,
	dp_overflow_ex,
	dp_opa_sign_ex,
	dp_opb_sign_ex,
	dp_shft_rnd_ex,
	dp_shft_rnd_plus_ex,
	alu_tcid1hot_rf,
	alu_tcid1hot_ag,
	alu_tcid_ag,
	alu_tcid1hot_ex,
	alu_tcid_ex,
	alu_tcid1hot_ms,
	alu_tcid_ms,
	alu_tcid1hot_er,
	alu_tcid_er,
	alu_cp0_rtc_ag,
	alu_cp0_rtc_ex,
	alu_cp0_wtc_er,
	MDU_pend_ouflag_wr_xx,
	MDU_ouflag_vld_xx,
	MDU_ouflag_hilo_xx,
	MDU_ouflag_mulq_muleq_xx,
	MDU_ouflag_extl_extr_xx,
	MDU_ouflag_age_xx,
	MDU_ouflag_tcid_xx,
	MDU_data_ack_ms,
	dsp_add_ag,
	dsp_sub_ag,
	dsp_carryin_ag,
	dsp_modsub_ag,
	dsp_present_xx,
	dsp_valid_rf,
	dsp_mdu_valid_rf,
	dsp_data_ms,
	dsp_stallreq_ag,
	alu_dsp_pos_r_ex,
	dsp_dspc_pos_ag,
	dsp_pos_ge32_ag,
	dsp_alu_sat_xx,
	dsp_dspc_ou_wren);


/*hookios*/


input           gclk;		// Global Clock
input		greset;		// Global Reset
input           gscanenable;	// Global Scanenable


input		alu_run_rf;	// rf stage run signal
input           alu_run_ag;	// ag stage run signal
input           alu_run_ex;	// ex stage run signal
input		alu_run_ms;	// ms stage run signal
input		alu_run_er;	// er stage run signal

input		alu_stall_ex;		// ex stage stall signal

input		alu_inst_valid_rf;	// instruction valid in RF stage
input		alu_inst_valid_ag;	// instruction valid in AG stage
input		alu_inst_valid_ex;	// Instruction valid in EX stage
input		alu_inst_valid_ms;	// Instruction valid in MS stage
input		alu_inst_valid_er;	// instruction valid in ER stage

input		alu_nullify_ag;		// ag stage nullify signal
input		alu_nullify_ex;		// ex stage nullify signal
input		alu_nullify_ms;		// ms stage nullify signal
input		alu_nullify_er;		// er stage nullify signal

input   [31:0]  dec_ir_ag;		// Instruction register in AG stage
input   [31:0]  dec_ir_rf;		// Instruction register in RF stage
input           mfttr_minus_one_ag;     // do not execute MFTR/MTTR in AG stage
input [22:0]    mpc_predec_e;		// predecoded values for umips
input [22:0]	mpc_dspinfo_e;
input [39:0]	MDU_info_e;



input [31:0]    dp_rs_ex;		// Apipe from ALU datapath
input [31:0]    dp_rt_ex;		// Bpipe from ALU datapath
input [31:0]    dp_cpipe_ex;		// Cpipe from ALU datapath
input [31:0]    dp_add_ex;		// Adder result
input [31:0]	dp_shift_ex;		// Shift result
input [31:0]	dp_shift_plus_ex;		// Shift result
input [31:0]	dp_bshift_ex;		// Shift result out of barrel shifter


input           dp_add_c31_ex;		// Carry out from adder, bit 31
input		dp_add_c32_ex;		// Carry out from adder, bit 32
input           dp_overflow_ex;		// Adder Overflow detected
input           dp_opa_sign_ex;		// Sign bit of APIPE input
input           dp_opb_sign_ex;		// Sign bit of BPIPE input
input		dp_shft_rnd_ex;		// Shft count bit 4	
input		dp_shft_rnd_plus_ex;		// Shft count bit 4	

input [8:0]     alu_tcid1hot_rf;	// Decoded TC ID	
input [8:0]     alu_tcid1hot_ag;	// Decoded TC ID	
input [3:0]     alu_tcid_ag;		// TC ID of instruction in AG 
input [8:0]     alu_tcid1hot_ex;	// Decoded TC ID	
input [3:0]     alu_tcid_ex;		// TC ID of instruction in EX 
input [8:0]     alu_tcid1hot_ms;	// Decoded TC ID	
input [3:0]     alu_tcid_ms;		// TC ID of instruction in MS 
input [8:0]     alu_tcid1hot_er;	// Decoded TC ID
input [3:0]     alu_tcid_er;		// TC ID of instruction in ER 
input [8:0]     alu_cp0_rtc_ag;         // selects which TC a MTTR/MFTR accesses
input [8:0]     alu_cp0_rtc_ex;         // selects which TC a MTTR/MFTR accesses
input [8:0]     alu_cp0_wtc_er;         // selects which TC a MTTR/MFTR accesses


//OUFlag updates from MDU 
input [8:0]     MDU_pend_ouflag_wr_xx; 	// update to ouflag pending
input           MDU_ouflag_vld_xx;  	// ouflag values are valid
input [3:0]     MDU_ouflag_hilo_xx; 	// ouflag values for HI/LO sets
input           MDU_ouflag_mulq_muleq_xx;  	// ouflag value for MULQ/MULEQ
input           MDU_ouflag_extl_extr_xx;  	// ouflag value for EXTL/R
input [1:0]     MDU_ouflag_age_xx;  	// age of instr. setting ouflag
input [3:0]     MDU_ouflag_tcid_xx;  	// TC id of instr. setting ouflag
input	 	MDU_data_ack_ms;	//Data accept from ALU on MDU data


output		dsp_add_ag;		// Add instruction from DSP
output		dsp_sub_ag;		// Sub instruction from DSP
output		dsp_carryin_ag;		// Carry in from ALU_DSP
output		dsp_modsub_ag;		// ModSub from ALU
output		dsp_present_xx;		// DSP present
output		dsp_valid_rf;		// Valid DSP instruction
output		dsp_mdu_valid_rf;	// Valid MDU DSP instruction


output [31:0]	dsp_data_ms;		// DSP result bus

output		dsp_stallreq_ag;	// DSP stallrequest	

output [5:0]	alu_dsp_pos_r_ex;	// POS-SIZE fro EXTPDP instruction

output [4:0]	dsp_dspc_pos_ag;	// POS field from DSPControl register in AG
output		dsp_pos_ge32_ag;	// POS field is great or equeal to 32

// Performance counter outputs
output		dsp_alu_sat_xx;		// Saturations in ALU part of the DSP

output		dsp_dspc_ou_wren;

// BEGIN Wire declarations made by MVP
wire dsp_pos_ge32_ag;
wire dsp_stallreq_ag;
wire dsp_alu_sat_xx;
wire dsp_modsub_ag;
wire dsp_mdu_valid_rf;
wire dsp_add_ag;
wire dsp_valid_rf;
wire dsp_present_xx;
wire [5:0] /*[5:0]*/ alu_dsp_pos_r_ex;
wire [4:0] /*[4:0]*/ dsp_dspc_pos_ag;
wire dsp_dspc_ou_wren;
wire dsp_carryin_ag;
wire dsp_sub_ag;
wire [31:0] /*[31:0]*/ dsp_data_ms;
// END Wire declarations made by MVP


//

//verilint 599 off
//verilint 239 off
//verilint 528 off        // Variable set but not used
//hotwires for tracer
 `ifdef MIPS_SIMULATION 
 //VCS coverage off 
//

wire	[31:0]	dspc_tc0_xx = 32'd0;
wire	[31:0]	dspc_tc0_alu_wren_er = 32'd0;
wire	[5:0]	dspc_tc0_mdu_wdata_er = 6'd0;

//verilint 528 on        // Variable set but not used

//verilint 599 on
//verilint 239 on
 //VCS coverage on  
 `endif 
//

//

assign dsp_present_xx = 1'b0;
assign dsp_valid_rf = 1'b0;
assign dsp_mdu_valid_rf = 1'b0;


assign dsp_data_ms[31:0] = 32'b0;
assign dsp_add_ag = 1'b0;
assign dsp_sub_ag = 1'b0;
assign dsp_carryin_ag = 1'b0;
assign dsp_modsub_ag = 1'b0;
assign dsp_stallreq_ag = 1'b0;
assign alu_dsp_pos_r_ex[5:0] = 6'b0;
assign dsp_dspc_pos_ag[4:0] = 5'b0;
assign dsp_pos_ge32_ag = 1'b0;

assign dsp_alu_sat_xx = 1'b0;
assign dsp_dspc_ou_wren = 1'b0;

endmodule

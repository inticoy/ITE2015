// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_edp_buf_misc_pro
//            execution data path
//
//	$Id: \$
//	mips_repository_id: m14k_edp_buf_misc_pro.mv, v 1.2 
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

module m14k_edp_buf_misc_pro(
	mpc_udisel_m,
	mpc_ir_e,
	mpc_irval_e,
	edp_abus_e,
	edp_bbus_e,
	cpz_rbigend_e,
	cpz_kuc_e,
	mpc_killmd_m,
	mpc_run_ie,
	mpc_run_m,
	mpc_udislt_sel_m,
	asp_m,
	greset,
	gclk,
	gscanenable,
	gscanmode,
	UDI_rd_m,
	UDI_wrreg_e,
	UDI_ri_e,
	UDI_stall_m,
	UDI_present,
	UDI_honor_cee,
	bit0_m,
	UDI_ir_e,
	UDI_irvalid_e,
	UDI_rs_e,
	UDI_rt_e,
	UDI_endianb_e,
	UDI_kd_mode_e,
	UDI_kill_m,
	UDI_start_e,
	UDI_run_m,
	UDI_greset,
	UDI_gscanenable,
	UDI_gclk,
	edp_udi_wrreg_e,
	edp_udi_ri_e,
	edp_udi_stall_m,
	edp_udi_present,
	edp_udi_honor_cee,
	res_m);

	
      /* Inputs */
    input               mpc_udisel_m;
    input [31:0]	mpc_ir_e;		// Full instn
    input               mpc_irval_e;            // IR is valid
    input [31:0]        edp_abus_e;		        
    input [31:0]        edp_bbus_e;		        
    input               cpz_rbigend_e;
    input               cpz_kuc_e;
    input               mpc_killmd_m;
    input               mpc_run_ie;
    input               mpc_run_m;
    input               mpc_udislt_sel_m;
    input [31:0]        asp_m;
    input               greset;
    input               gclk;
    input               gscanenable;
    input               gscanmode;
    input [31:0]        UDI_rd_m;    
    input [4:0]         UDI_wrreg_e;
    input               UDI_ri_e;
    input               UDI_stall_m;
    input               UDI_present;
    input               UDI_honor_cee;
    input               bit0_m;

        
        /* Outputs */
    output [31:0]       UDI_ir_e;		// Full instn
    output              UDI_irvalid_e;          // IR is valid
    output [31:0]       UDI_rs_e;               
    output [31:0]       UDI_rt_e;
    output              UDI_endianb_e;
    output              UDI_kd_mode_e;
    output              UDI_kill_m;
    output              UDI_start_e;
    output              UDI_run_m;
    output              UDI_greset;
    output              UDI_gscanenable;
    output              UDI_gclk;     
    output [4:0]        edp_udi_wrreg_e;
    output              edp_udi_ri_e;
    output              edp_udi_stall_m;
    output              edp_udi_present;
    output              edp_udi_honor_cee;
    output [31:0]       res_m;

// BEGIN Wire declarations made by MVP
wire [31:0] /*[31:0]*/ UDI_rs_e;
wire [31:0] /*[31:0]*/ res_m;
wire [31:0] /*[31:0]*/ udislt_m;
wire UDI_kd_mode_e;
wire UDI_greset;
wire UDI_irvalid_e;
wire UDI_kill_m;
wire UDI_gclk;
wire [31:0] /*[31:0]*/ UDI_ir_e;
wire UDI_start_e;
wire [31:0] /*[31:0]*/ UDI_rt_e;
wire UDI_gscanenable;
wire UDI_endianb_e;
wire UDI_run_m;
// END Wire declarations made by MVP


    
        assign UDI_ir_e[31:0] = mpc_ir_e[31:0];
        assign UDI_irvalid_e = mpc_irval_e;
        assign UDI_rs_e[31:0] = edp_abus_e[31:0];
        assign UDI_rt_e[31:0] = edp_bbus_e[31:0];
        assign UDI_endianb_e = cpz_rbigend_e;
        assign UDI_kd_mode_e = ~cpz_kuc_e;
        assign UDI_start_e = mpc_run_ie;
        assign UDI_kill_m = mpc_killmd_m;
        assign UDI_run_m = mpc_run_m;
        assign UDI_greset = greset;
        assign UDI_gscanenable = gscanenable;
        assign UDI_gclk = gclk;
        wire [31:0]         UDI_data_m;
   
    `M14K_UDI_SCANIO_MODULE udi_scanio(
                                      .gclk( gclk),
                                      .gscanenable(gscanenable),
                                      .gscanmode(gscanmode),
                                      .UDI_irvalid_e(UDI_irvalid_e),
                                      .UDI_rs_e(UDI_rs_e),
                                      .UDI_rt_e(UDI_rt_e),
                                      .UDI_kill_m(UDI_kill_m),
                                      .UDI_start_e(UDI_start_e),
                                      .UDI_run_m(UDI_run_m),
                                      .UDI_endianb_e(UDI_endianb_e),
                                      .UDI_rd_m(UDI_rd_m),
                                      .UDI_wrreg_e(UDI_wrreg_e),
                                      .UDI_ri_e(UDI_ri_e),
                                      .UDI_stall_m(UDI_stall_m),
                                      .UDI_present(UDI_present),
                                      .UDI_honor_cee(UDI_honor_cee),
                                      .UDI_rd_buf_m(UDI_data_m),
                                      .UDI_wrreg_buf_e(edp_udi_wrreg_e),
                                      .UDI_ri_buf_e(edp_udi_ri_e),
                                      .UDI_stall_buf_m(edp_udi_stall_m),
                                      .UDI_present_buf(edp_udi_present),
                                      .UDI_honor_cee_buf(edp_udi_honor_cee));

    

`define M14K_UDI_SUP
    

        mvp_mux2 #(32) _udislt_m_31_0_(udislt_m[31:0],mpc_udisel_m && edp_udi_present, {31'h0, bit0_m}, UDI_data_m[31:0]);
        mvp_mux2 #(32) _res_m_31_0_(res_m[31:0],mpc_udislt_sel_m, asp_m[31:0], udislt_m[31:0]);
        
        
endmodule	// m14k_edp_buf_misc_pro


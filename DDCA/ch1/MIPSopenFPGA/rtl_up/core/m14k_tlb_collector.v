// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// 	Description: m14k_tlb_collector
//        Fixed Mapping Translation stub module
//        Ties off unused ports to keep MMU ports the same between
//        TLB and FMT  
//
//	$Id: \$
//	mips_repository_id: m14k_tlb_collector.mv, v 1.9 
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
//verilint 240 off

`include "m14k_const.vh"
module m14k_tlb_collector(
	cpz_g_erl,
	cpz_g_hoterl,
	cpz_g_k0cca,
	cpz_g_k23cca,
	cpz_g_kucca,
	cpz_g_kuc_i,
	cpz_g_kuc_m,
	cpz_g_smallpage,
	cpz_g_mmutype,
	cpz_g_mmusize,
	mpc_g_cp0move_m,
	cpz_vz,
	mpc_g_jamtlb_w,
	cpz_gm_m,
	cpz_gm_i,
	cpz_gid,
	cpz_rid,
	mpc_g_cp0func_e,
	mpc_g_eexc_e,
	cpz_drg,
	cpz_drgmode_i,
	cpz_drgmode_m,
	mmu_r_asid,
	mmu_r_asid_valid,
	mmu_r_cpyout,
	mmu_r_type,
	mmu_r_size,
	mmu_r_adrerr,
	mmu_r_dtexc_m,
	mmu_r_dtriexc_m,
	mmu_r_itexc_i,
	mmu_r_itxiexc_i,
	mmu_r_rawdtexc_m,
	mmu_r_rawitexc_i,
	mmu_r_tlbbusy,
	mmu_r_tlbinv,
	mmu_r_tlbmod,
	mmu_r_tlbrefill,
	mmu_r_tlbshutdown,
	mmu_r_iec,
	mmu_r_transexc,
	mmu_r_vafromi,
	r_asid_update,
	mmu_r_it_segerr,
	mmu_rid,
	mmu_r_read_m,
	r_jtlb_wr);


	/* Inputs */
	// I/O from mmuc
		
	// Guest Cp0 state inputs
	input 		cpz_g_erl;		// cpz_erl bit from status
	input 		cpz_g_hoterl;		// Early version of cpz_erl
	input [2:0]     cpz_g_k0cca;		// kseg0 cache attributes
	input [2:0]     cpz_g_k23cca;		// kseg2/3 cache attributes
	input [2:0]     cpz_g_kucca;		// kuseg cache attributes
	input 		cpz_g_kuc_i;		// Kernel/user bit - 0:=>kernel; 1:=>user
	input 		cpz_g_kuc_m;		// Kernel/user bit - 0:=>kernel; 1:=>user
	input		cpz_g_smallpage;		// Small (1KB) page support
	
	input 		cpz_g_mmutype;	        // mmu_type from Config register
	input 	[1:0]	cpz_g_mmusize;	        // mmu_type from Config register
	
	input           mpc_g_cp0move_m;
	input		cpz_vz;
	input 		mpc_g_jamtlb_w;		
	input 		cpz_gm_m;		
	input 		cpz_gm_i;		
	input [`M14K_GID] 	cpz_gid;
	input [`M14K_GID] 	cpz_rid;
	input [5:0]	mpc_g_cp0func_e;
	input		mpc_g_eexc_e;		// early exception detected in E-stage
	input 		cpz_drg;		
	input 		cpz_drgmode_i;		
	input 		cpz_drgmode_m;		

	// Misc. Outputs
	output [`M14K_ASID] 	mmu_r_asid;		// Load/Store Normal Memory from DEBUG
	output 			mmu_r_asid_valid; 
	output [31:0] 	mmu_r_cpyout;		// Read data for MFC0 & SC register updates
	output 		mmu_r_type;		// MMU type: 1->BAT, 0->TLB
	output 	[1:0]	mmu_r_size;		// MMU size: 0->16, 1->32
	
	// Translation/Address Error Outputs
	output 		mmu_r_adrerr;
	output 		mmu_r_dtexc_m;		// data reference translation error
	output 		mmu_r_dtriexc_m;		// D-addr RI exception
	output 		mmu_r_itexc_i;		// instruction reference translation error
	output 		mmu_r_itxiexc_i;		// itlb execution inhibit exception
	output 		mmu_r_rawdtexc_m;		// Raw translation exception (includes PREFS)
	output 		mmu_r_rawitexc_i;		// Raw ITranslation exception
	output 		mmu_r_tlbbusy;		// TLB is in midst of multi-cycle operation
	output 		mmu_r_tlbinv;		// TLB Invalid exception
	output 		mmu_r_tlbmod;			// TLB modified exception
	output 		mmu_r_tlbrefill;		// TLB Refill exception
	output 		mmu_r_tlbshutdown;		// conflict detected on TLB write
	output 		mmu_r_iec;		// enable unique ri/xi exception code
	output 		mmu_r_transexc;		// Translation exception - load shadow registers
	output 		mmu_r_vafromi;		// Use ITLBH instead of JTLBH to load CP0 regs
	
	
	output		r_asid_update;		// enhi register updated
	
	output		mmu_r_it_segerr;
	output [`M14K_GID] 	mmu_rid;
	output		mmu_r_read_m;
	output		r_jtlb_wr;

// BEGIN Wire declarations made by MVP
wire mmu_r_transexc;
wire mmu_r_adrerr;
wire mmu_r_iec;
wire [1:0] /*[1:0]*/ mmu_r_size;
wire mmu_r_dtriexc_m;
wire mmu_r_dtexc_m;
wire mmu_r_read_m;
wire mmu_r_tlbmod;
wire mmu_r_vafromi;
wire r_jtlb_wr;
wire [`M14K_ASID] /*[7:0]*/ mmu_r_asid;
wire [`M14K_GID] /*[2:0]*/ mmu_rid;
wire mmu_r_rawdtexc_m;
wire mmu_r_asid_valid;
wire mmu_r_tlbbusy;
wire mmu_r_tlbrefill;
wire mmu_r_itxiexc_i;
wire mmu_r_tlbshutdown;
wire mmu_r_tlbinv;
wire mmu_r_rawitexc_i;
wire mmu_r_it_segerr;
wire [31:0] /*[31:0]*/ mmu_r_cpyout;
wire mmu_r_itexc_i;
wire r_asid_update;
wire mmu_r_type;
// END Wire declarations made by MVP

	// End of init/O

// Misc. Outputs
	assign mmu_r_asid [`M14K_ASID] 	 = `M14K_ASIDWIDTH'b0;
	assign mmu_r_asid_valid 			 = 1'b0;
	assign mmu_r_cpyout [31:0] 	 = 32'b0;
	assign mmu_r_type 		 = 1'b0;
	assign mmu_r_size [1:0]	 = 2'b0;

// Translation/Address Error Outputs
	assign mmu_r_adrerr 		 = 1'b0;
	assign mmu_r_dtexc_m 		 = 1'b0;
	assign mmu_r_dtriexc_m 		 = 1'b0;
	assign mmu_r_itexc_i 		 = 1'b0;
	assign mmu_r_itxiexc_i 		 = 1'b0;
	assign mmu_r_rawdtexc_m 		 = 1'b0;
	assign mmu_r_rawitexc_i 		 = 1'b0;
	assign mmu_r_tlbbusy 		 = 1'b0;
	assign mmu_r_tlbinv 		 = 1'b0;
	assign mmu_r_tlbmod 		 = 1'b0;
	assign mmu_r_tlbrefill 		 = 1'b0;
	assign mmu_r_tlbshutdown 		 = 1'b0;
	assign mmu_r_iec 		 = 1'b0;
	assign mmu_r_transexc 		 = 1'b0;
	assign mmu_r_vafromi 		 = 1'b0;


	assign r_asid_update		 = 1'b0;

	assign mmu_r_it_segerr		 = 1'b0;
	assign mmu_rid [`M14K_GID] 	 = `M14K_GIDWIDTH'b0;
	assign mmu_r_read_m		 = 1'b0;
	assign r_jtlb_wr		 = 1'b0;

	
//verilint 240 on  // Unused input
endmodule	// fixed

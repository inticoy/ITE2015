// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// Description: m14k_cp2_stub
//      Dummy stub-module of CP2 IF module
//
// $Id: \$
// mips_repository_id: m14k_cp2_stub.mv, v 1.7 
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


`include "m14k_const.vh"
module m14k_cp2_stub(
	CP2_abusy_0,
	CP2_tbusy_0,
	CP2_fbusy_0,
	CP2_cccs_0,
	CP2_ccc_0,
	CP2_present,
	CP2_idle,
	CP2_excs_0,
	CP2_exc_0,
	CP2_exccode_0,
	CP2_fds_0,
	CP2_forder_0,
	CP2_fdata_0,
	CP2_tordlim_0,
	CP2_as_0,
	CP2_ts_0,
	CP2_fs_0,
	CP2_irenable_0,
	CP2_ir_0,
	CP2_endian_0,
	CP2_kd_mode_0,
	CP2_inst32_0,
	CP2_nulls_0,
	CP2_null_0,
	CP2_reset,
	CP2_kills_0,
	CP2_kill_0,
	CP2_tds_0,
	CP2_tdata_0,
	CP2_torder_0,
	CP2_fordlim_0,
	gclk,
	greset,
	gscanenable,
	gscanmode,
	mpc_srcvld_e,
	mpc_irval_e,
	mpc_ir_e,
	mpc_predec_e,
	mpc_umipspresent,
	cpz_rbigend_e,
	cpz_kuc_e,
	mpc_killcp2_w,
	mpc_cp2exc,
	mpc_brrun_ie,
	mpc_run_ie,
	mpc_run_m,
	mpc_run_w,
	mpc_wait_m,
	cpz_cu2,
	mpc_fixupd,
	dcc_dmiss_m,
	edp_ldcpdata_w,
	cp2_coppresent,
	cp2_copidle,
	cp2_fixup_m,
	cp2_fixup_w,
	cp2_stall_e,
	cp2_bstall_e,
	cp2_btaken,
	cp2_bvalid,
	cp2_movefrom_m,
	cp2_moveto_m,
	cp2_storekill_w,
	cp2_datasel,
	cp2_storeissued_m,
	cp2_ldst_m,
	cp2_missexc_w,
	cp2_exc_w,
	cp2_exccode_w,
	cp2_data_w,
	dcc_store_allocate,
	dcc_par_kill_mw,
	mpc_tlb_exc_type,
	cp2_storealloc_reg);


/*hookios*/
   // Cop2 I/F input/output signals
   input         CP2_abusy_0;		// COP2 Arithmetric instruction busy
   input 	 CP2_tbusy_0;		// COP2 To data busy
   input 	 CP2_fbusy_0;		// COP2 From data busy
   input 	 CP2_cccs_0;		// COP2 Condition Code Check Strobe
   input 	 CP2_ccc_0;		// COP2 Condition Code Check
   input 	 CP2_present;		// COP2 is present (1=present)
   input 	 CP2_idle;		// COP2 Coprocessor is idle
   input 	 CP2_excs_0;		// COP2 Exceptions strobe
   input 	 CP2_exc_0;		// COP2 Exception
   input [4:0] 	 CP2_exccode_0;		// COP2 Exception Code (Valid if CP2_exc_0 == 1)
   input 	 CP2_fds_0;		// COP2 From data Data strobe
   input [2:0]	 CP2_forder_0;		// COP2 From data ordering
   input [31:0]  CP2_fdata_0;		// COP2 From data
   input [2:0] 	 CP2_tordlim_0;		// COP2 To data ordering limit
   output 	 CP2_as_0;		// COP2 Arithmetric instruction strobe
   output 	 CP2_ts_0;		// COP2 To data instruction strobe
   output 	 CP2_fs_0;		// COP2 From data instruction strobe
   output 	 CP2_irenable_0;	// COP2 Enable Instruction registering
   output [31:0] CP2_ir_0;		// COP2 Arithmich and To/From instruction
   output 	 CP2_endian_0;		// COP2 Big Endian used in instruction/To/From
   output	 CP2_kd_mode_0;         // COP2 Instn executing in kernel or debug mode
   output 	 CP2_inst32_0;		// COP2 MIPS32 compatible instruction
   output 	 CP2_nulls_0;		// COP2 Nullify strobe
   output 	 CP2_null_0;		// COP2 Nullify
   output 	 CP2_reset;		// COP2 greset signal
   output 	 CP2_kills_0;		// COP2 Kill strobe
   output [1:0]  CP2_kill_0;		// COP2 Kill (00, 01=NoKill, 10=KillNotCP, 11=KillCP)
   output 	 CP2_tds_0;		// COP2 To data Data strobe
   output [31:0] CP2_tdata_0;		// COP2 To data
   output [2:0]  CP2_torder_0;		// COP2 To data ordering
   output [2:0]  CP2_fordlim_0;		// COP2 From data ordering limit

   
   // Integer unit input/output signals
   input 	 gclk;			// Global clock
   input 	 greset;		// Global reset
   input 	 gscanenable;		// Global Scan Enable
   input         gscanmode;
   input 	 mpc_srcvld_e;		// Abus and Bbus are valid.
   input 	 mpc_irval_e;		// Instruction on mpc_ir_e is valid
   input [31:0]  mpc_ir_e;		// Instruction in E stage
   input [22:0]  mpc_predec_e;		// umips predecoded instructions
   input         mpc_umipspresent;	// umips decoder present
   input 	 cpz_rbigend_e;		// Endianess of current instruction
   input 	 cpz_kuc_e;		// Current instruction is in user mode
   input 	 mpc_killcp2_w;		// Kill all E, M and W stage commands
   input 	 mpc_cp2exc;		// Kill exception due to COP2 (Valid first cycle of mpc_killcp2_w)
   input 	 mpc_brrun_ie;		// Stage I,E  is moving to next stage. Not deaserted for COP2 branch.
   input 	 mpc_run_ie;		// Stage I,E is moving to next stage.
   input 	 mpc_run_m;		// Stage M is moving to next stage.
   input 	 mpc_run_w;		// Stage W is moving to next stage.
   input	 mpc_wait_m;            // Wait instruction is in M stage, 
					// following cop2 in E stage will be cancelled
   input 	 cpz_cu2;		// CU2 bit from Status register
   input 	 mpc_fixupd;		// D$ rerunning M-stage due to cache miss
   input 	 dcc_dmiss_m;		// Miss in D$
   input [31:0]  edp_ldcpdata_w;	// Result of Cache hit/Register read
   output 	 cp2_coppresent;	// COP 2 is present on the interface.
   output 	 cp2_copidle;		// COP 2 is Idle, biu_shutdown is OK for COP 2
   output 	 cp2_fixup_m;		// Previous E-stage is rerun in cp2, due to busy signal
   output 	 cp2_fixup_w;		// Rerun Stage-M
   output 	 cp2_stall_e;		// Stall Current E-stage due to COP2 delay
   output 	 cp2_bstall_e;		// Stall Current E-stage due to branch on COP2 condition
   output 	 cp2_btaken;		// COP2 Branch is taken (Valid when cp2_bvalid == '1')
   output 	 cp2_bvalid;		// COP2 Bransh taken Valid
   output 	 cp2_movefrom_m;	// COP2 Move to/from register file
   output 	 cp2_moveto_m;	// COP2 Move to/from register file
   output 	 cp2_storekill_w; 	// Invalidate COP2 store data in SB
   output 	 cp2_datasel; 		// Select cp2_data_w in store buffer.
   output 	 cp2_storeissued_m;	// Indicate that a SWC2 is issued to CP2
   output 	 cp2_ldst_m;		// LWC2 or SWC2 is in W stage
   output 	 cp2_missexc_w; 	// COP2 Exception Not ready
   output 	 cp2_exc_w;		// COP2 Exception
   output [4:0]  cp2_exccode_w;		// COP2 Exception Code
   output [31:0] cp2_data_w;   		// Return Data from COP2

   // Data Cache Controller input/outputs
   // to bring registers only needed in m14k_dcc when m14k_cp2 is implemented
   // into this modules.
   input 	 dcc_store_allocate;
   input 	 dcc_par_kill_mw;
   input	 mpc_tlb_exc_type;	    // i stage exception type
   output 	 cp2_storealloc_reg;

// BEGIN Wire declarations made by MVP
wire [31:0] /*[31:0]*/ CP2_ir_0;
wire [2:0] /*[2:0]*/ CP2_torder_0;
wire cp2_fixup_w;
wire cp2_moveto_m;
wire cp2_storekill_w;
wire cp2_ldst_m;
wire [1:0] /*[1:0]*/ CP2_kill_0;
wire CP2_endian_0;
wire CP2_inst32_0;
wire cp2_bvalid;
wire CP2_fs_0;
wire cp2_missexc_w;
wire CP2_irenable_0;
wire CP2_tds_0;
wire cp2_btaken;
wire cp2_fixup_m;
wire CP2_null_0;
wire [2:0] /*[2:0]*/ CP2_fordlim_0;
wire cp2_coppresent;
wire cp2_stall_e;
wire CP2_nulls_0;
wire cp2_storealloc_reg;
wire cp2_storeissued_m;
wire CP2_kd_mode_0;
wire cp2_exc_w;
wire cp2_copidle;
wire CP2_ts_0;
wire CP2_kills_0;
wire [4:0] /*[4:0]*/ cp2_exccode_w;
wire cp2_bstall_e;
wire [31:0] /*[31:0]*/ CP2_tdata_0;
wire cp2_movefrom_m;
wire CP2_as_0;
wire cp2_datasel;
wire [31:0] /*[31:0]*/ cp2_data_w;
wire CP2_reset;
// END Wire declarations made by MVP


   // Apply dummy outputs
   assign CP2_as_0 = 		1'd0;
   assign CP2_ts_0 =		1'd0;
   assign CP2_fs_0 =		1'd0;
   assign CP2_irenable_0 =	1'd0;
   assign CP2_ir_0 [31:0] =	32'd0;
   assign CP2_endian_0 =	1'd0;
   assign CP2_kd_mode_0 =	1'd0;
   assign CP2_inst32_0 =	1'd0;
   assign CP2_nulls_0 =        1'd0;
   assign CP2_null_0 =		1'd0;
   assign CP2_reset =		1'd1;
   assign CP2_kills_0 =	1'd0;
   assign CP2_kill_0 [1:0] =	2'd0;
   assign CP2_tds_0 =		1'd0;
   assign CP2_tdata_0 [31:0] =	32'd0;
   assign CP2_torder_0 [2:0] =	3'd0;
   assign CP2_fordlim_0 [2:0] = 3'd0;
   
   assign cp2_coppresent =	1'd0;
   assign cp2_copidle =	1'd1;
   assign cp2_fixup_m =	1'd0;
   assign cp2_fixup_w =	1'd0;
   assign cp2_stall_e =	1'd0;
   assign cp2_bstall_e =	1'd0;
   assign cp2_btaken =		1'd0;
   assign cp2_bvalid =		1'd0;
   assign cp2_movefrom_m =	1'd0;
   assign cp2_moveto_m =	1'd0;
   assign cp2_storekill_w =	1'd0;
   assign cp2_datasel =	1'd0;
   assign cp2_storealloc_reg =	1'd0;
   assign cp2_storeissued_m =	1'd0;
   assign cp2_ldst_m =		1'd0;
   assign cp2_missexc_w =	1'd0;
   assign cp2_exc_w =		1'd0;
   assign cp2_exccode_w [4:0] =5'd0;
   assign cp2_data_w [31:0] = 32'd0;
   
//verilint 240 on  // Unused input
endmodule // cp2_stub

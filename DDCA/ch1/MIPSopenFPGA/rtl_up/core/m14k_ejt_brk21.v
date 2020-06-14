// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_ejt_brk21 
//            Simple Break Top Level 2I/1D channels
//
//      $Id: \$
//      mips_repository_id: m14k_ejt_brk21.mv, v 1.23 
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
module m14k_ejt_brk21(
	gscanenable,
	edp_iva_i,
	mmu_dva_m,
	mmu_asid,
	cpz_guestid,
	cpz_guestid_m,
	cpz_guestid_i,
	cpz_vz,
	cpz_mmutype,
	dcc_ldst_m,
	dcc_ejdata,
	mpc_lsbe_m,
	mpc_be_w,
	mmu_ivastrobe,
	dcc_dvastrobe,
	dcc_stdstrobe,
	mpc_sbstrobe_w,
	mpc_sbdstrobe_w,
	mpc_cbstrobe_w,
	cp2_ldst_m,
	cp1_ldst_m,
	dcc_lddatastr_w,
	mpc_sbtake_w,
	mpc_cleard_strobe,
	mpc_run_ie,
	mpc_run_m,
	mpc_run_w,
	gclk,
	greset,
	cpz_dm,
	ej_eagaddr_15_3,
	ej_eagdataout,
	ej_sbwrite,
	icc_umipspresent,
	mpc_umipspresent,
	mpc_isamode_i,
	icc_umipsfifo_null_i,
	icc_umipsfifo_null_w,
	icc_halfworddethigh_i,
	icc_isachange0_i_reg,
	icc_isachange1_i_reg,
	mpc_fixupi,
	icc_imiss_i,
	icc_macro_e,
	mpc_macro_e,
	mpc_macro_m,
	mpc_macro_w,
	mpc_ireton_e,
	mpc_bussize_m,
	ejt_ivabrk,
	ejt_dvabrk,
	ejt_dbrk_w,
	ejt_dbrk_m,
	ejt_cbrk_m,
	ejt_cbrk_type_m,
	ejt_stall_st_e,
	ej_sbdatain,
	ej_noinstbrk,
	ej_nodatabrk,
	ej_cbrk_present,
	brk_ibs_bcn,
	brk_dbs_bcn,
	brk_i_trig,
	brk_d_trig,
	brk_ibs_bs,
	brk_dbs_bs,
	mpc_atomic_m,
	mpc_atomic_e,
	mpc_lsdc1_e,
	mpc_lsdc1_m,
	mpc_lsdc1_w);


/* Inputs */

        input           gscanenable;     // Scan Enable
	input	[31:0]	edp_iva_i;	// Virtual addr of inst
	input 	[31:0]	mmu_dva_m;	// Virtual addr of load/store
	input	[7:0]	mmu_asid;	// Current mmu_asid
	input	[7:0]	cpz_guestid;	// Current cpz_guestid
	input   [7:0]   cpz_guestid_m;
	input   [7:0]   cpz_guestid_i;
	input		cpz_vz;
	input		cpz_mmutype;	// mmu_asid is not used
	input		dcc_ldst_m;	// M stage: 1=load 0=store
	input	[31:0]	dcc_ejdata;	// Muxed store+load data bus
	input	[3:0]	mpc_lsbe_m;	// Bytes valid for L/S in M stage
	input	[3:0]	mpc_be_w;	// Bytes valid for load in W stage
	input		mmu_ivastrobe;	// Strobe to indicate I stage
	input		dcc_dvastrobe;	// Strobe to indicate M stage
	input 		dcc_stdstrobe;  // Store data ready
	input		mpc_sbstrobe_w;	// Strobe to indicate W stage
	input		mpc_sbdstrobe_w;  // ejtag simple break strobe for d channels
	input		mpc_cbstrobe_w;	// Strobe to indicate W stage - not strobed on exceptions
	input 		cp2_ldst_m;     // Cop2 Load or Store
	input 		cp1_ldst_m;     // Cop1 Load or Store
	input		dcc_lddatastr_w;// Strobe to indicate L data in W stg
	input		mpc_sbtake_w;	// Simple Brk taken indication (W)
	input 		mpc_cleard_strobe;  // Clear dbits
	input 		mpc_run_ie;     // i/e-stage run signal
	input 		mpc_run_m;      // m-stage run signal
	input		mpc_run_w;	
	input		gclk;	        // global clock
	input		greset;	        // global reset
	input		cpz_dm;		// DebugMode indication

	input	[15:3]	ej_eagaddr_15_3;// Address of register bus
	input	[31:0]	ej_eagdataout;	// Indata of register bus
	input		ej_sbwrite;	// Write enable of register bus
	input 		icc_umipspresent; // Indicates whether UMIPS recoder is present
	input		mpc_umipspresent; // Indicates whether UMIPS decoder is present
	input 		mpc_isamode_i;  // ISA Mode that IVAddr corresponds to
	input		icc_umipsfifo_null_i;	// instn slip at i-stage
	input		icc_umipsfifo_null_w;	// instn slip propagated to w-stage
	input		icc_halfworddethigh_i;
	input		icc_isachange0_i_reg;
	input		icc_isachange1_i_reg;
	input		mpc_fixupi;
	input		icc_imiss_i;
	input		icc_macro_e;		// macro executing
	input		mpc_macro_e;		// macro executing
	input		mpc_macro_m;
	input		mpc_macro_w;
	input		mpc_ireton_e;
	input	[1:0]	mpc_bussize_m;

/* Outputs */
	output		ejt_ivabrk;	// Break in I stg
	output		ejt_dvabrk;	// Break in M stg
	output		ejt_dbrk_w;	// Break in W stg
	output		ejt_dbrk_m;	// Break in M stg
	output		ejt_cbrk_m;	// Break in M stg
	output	[6:0]	ejt_cbrk_type_m;  // complex break type
	output		ejt_stall_st_e;	// Stall stores in E stg
	output	[31:0]	ej_sbdatain;	// Outdata of register bus
	output		ej_noinstbrk;	// Indicate if any I ch are implm.
	output		ej_nodatabrk;	// Indicate if any D ch are implm.
	output		ej_cbrk_present; // Indicate if complex break logic is implm.

	output [3:0]	brk_ibs_bcn;	// Number of inst brk implemented
	output [3:0]	brk_dbs_bcn;	// Number of data brk implemented
        output [7:0]    brk_i_trig;     // Inst triggers
        output [3:0]    brk_d_trig;     // Data triggers
        output [7:0]    brk_ibs_bs;     // Inst Break Status
        output [3:0]    brk_dbs_bs;     // Data Break Status
        input           mpc_atomic_m;       //Atomic instruction is in M stage;
        input           mpc_atomic_e;       //Atomic instruction is in E stage;
        input           mpc_lsdc1_e;       
        input           mpc_lsdc1_m;       
	input		mpc_lsdc1_w;

// BEGIN Wire declarations made by MVP
wire ej_cbrk_present;
wire pwrsave_en;
wire ej_nodatabrk;
wire [3:0] /*[3:0]*/ brk_ibs_bcn;
wire w2_need_vm;
wire dbc_sel;
wire ibs_updt;
wire m2_event;
wire ejt_stall_st_e;
wire [3:0] /*[3:0]*/ brk_dbs_bs;
wire ejt_cbrk_m;
wire [31:0] /*[31:0]*/ dbld;
wire [1:0] /*[1:0]*/ i_trig;
wire [3:0] /*[3:0]*/ bytevalid_data;
wire dbs_bs_in;
wire [1:0] /*[1:0]*/ ibc_sel;
wire dbs_rst_updt_we_sel;
wire [3:0] /*[3:0]*/ bytevalid_adr;
wire ejt_ivabrk;
wire m1_need_vm;
wire [15:0] /*[15:0]*/ comp_addr;
wire d_trig;
wire [1:0] /*[1:0]*/ ibits_e;
wire [31:0] /*[31:0]*/ dbld_out;
wire [31:0] /*[31:0]*/ ej_sbdatain;
wire [1:0] /*[1:0]*/ ejt_ibits;
wire dbs_bs_set;
wire mpc_sbtake_w_long;
wire dbasid_sel;
wire [1:0] /*[1:0]*/ ibs_bs_in;
wire [1:0] /*[1:0]*/ iba_sel;
wire [31:0] /*[31:0]*/ edp_iva_i_umips;
wire [3:0] /*[3:0]*/ brk_dbs_bcn;
wire mmu_ivastrobe_hwart;
wire asid_sup;
wire [31:0] /*[31:0]*/ comp_iva;
wire ejt_dbrk_w;
wire dbits_w_1;
wire mmu_ivastrobe_umips;
wire dbs_bs;
wire ejt_dbrk_m;
wire write_dbits;
wire clear_dbits;
wire mmu_ivastrobe_qual;
wire ibs_rst_updt_we_sel;
wire m1_needm2;
wire pwrsave_en_sel;
wire [1:0] /*[1:0]*/ ibits_i;
wire dbv_sel;
wire ibs_sel;
wire need_cp2_stdata;
wire [1:0] /*[1:0]*/ ibm_sel;
wire [1:0] /*[1:0]*/ dbits_w;
wire [1:0] /*[1:0]*/ ibs_bs_set;
wire [1:0] /*[1:0]*/ ibits_w;
wire [31:0] /*[31:0]*/ ibs_out;
wire m1_vm;
wire [31:0] /*[31:0]*/ edp_iva_i_macrod;
wire w2_vm;
wire dbs_we;
wire [1:0] /*[1:0]*/ ejt_dbits;
wire dba_sel;
wire dbld_sel;
wire ej_noinstbrk;
wire m1_event;
wire dbits_w_0;
wire m1_act_novm;
wire m1_act_vm;
wire [1:0] /*[1:0]*/ ibs_bs;
wire [7:0] /*[7:0]*/ brk_ibs_bs;
wire m1_activ;
wire mpc_sbtake_w_qual;
wire latch_dbits;
wire m1_needw;
wire dbs_sel;
wire pre_w2_vm;
wire w_event;
wire [6:0] /*[6:0]*/ ejt_cbrk_type_m;
wire [1:0] /*[1:0]*/ ibits_m;
wire w2_event;
wire [7:0] /*[7:0]*/ brk_i_trig;
wire dbs_updt;
wire ibs_we;
wire dbm_sel;
wire [1:0] /*[1:0]*/ ibasid_sel;
wire m1_no_vm;
wire ejt_dvabrk;
wire capture_lddata_w;
wire mpc_sbtake_w_delay;
wire [31:0] /*[31:0]*/ dbs_out;
wire m1_activ_ndv;
wire [3:0] /*[3:0]*/ brk_d_trig;
// END Wire declarations made by MVP



/* Wire Declarations */

	wire [31:0]	regbusdataout_i0, regbusdataout_i1, regbusdataout_d0;

	wire [1:0] 	i_match;
        wire 	dbc_be, dbc_te, dbc_nolb, dbc_nosb;
        wire [1:0]	ibc_be, ibc_te;
	
	wire  	d_addr_m, d_do_vm, d_vmatch;
	wire	dbc_hwat;
	
	wire [31:0]	gt_ivaaddr;
	wire [31:0]	gt_dvaaddr;
	wire [31:0]	gt_data;

	wire [7:0]	gt_asid;
	wire [7:0]	gt_guestid;
	wire [7:0]	gt_guestid_i;
	wire [7:0]	gt_guestid_m;
	wire [3:0]	gt_bytevalid_m, gt_bytevalid_w;



/* Code */

// Configuration

	// Both I & D channels are implemented.

	assign ej_noinstbrk	= 1'b0;
	assign ej_nodatabrk	= 1'b0;
	// No complex break
	assign ej_cbrk_present = 1'b0;
 	assign ejt_cbrk_m = 1'b0;
	assign ejt_cbrk_type_m[6:0] = 7'b0;

// config/trigger signals to pdtrace

	assign brk_ibs_bcn [3:0] = ibs_out[27:24];	// Number of inst brk implemented
	assign brk_dbs_bcn [3:0] = dbs_out[27:24];	// Number of data brk implemented
        assign brk_i_trig [7:0] = {6'b0, i_trig[1:0]}; // Inst triggers
        assign brk_d_trig [3:0] = {3'b0, d_trig};      // Data triggers
        assign brk_ibs_bs [7:0] = {6'b0, ibs_bs[1:0]}; // Inst break status
        assign brk_dbs_bs [3:0] = {3'b0, dbs_bs};      // Data break status



// Low power indicator

	// pwrsave_en is 1 when Simple Break is in 
	// low power mode. pwrsave_en is 0 when a 
	// register in Simple Break has been written, 
	// thus enabling the module and leaving low pwr mode.

	assign pwrsave_en_sel	= greset | ej_sbwrite;

	mvp_cregister #(1) _pwrsave_en(pwrsave_en,pwrsave_en_sel, gclk, greset);


// Main Register Control

	assign comp_addr[15:0] = {ej_eagaddr_15_3, 3'b0};

	assign ibs_sel		= (comp_addr==`M14K_EJS_IBS);

	assign dbs_sel		= (comp_addr==`M14K_EJS_DBS);

	assign iba_sel [1:0] 	= { (comp_addr==`M14K_EJS_IBA1),
				(comp_addr==`M14K_EJS_IBA0) };

	assign ibm_sel [1:0] 	= { (comp_addr==`M14K_EJS_IBM1),
				(comp_addr==`M14K_EJS_IBM0) };

	assign ibasid_sel [1:0] = { (comp_addr==`M14K_EJS_IBASID1),
				(comp_addr==`M14K_EJS_IBASID0) };

	assign ibc_sel [1:0] 	= { (comp_addr==`M14K_EJS_IBC1),
				(comp_addr==`M14K_EJS_IBC0) };

	assign dba_sel  	= (comp_addr==`M14K_EJS_DBA0);

	assign dbm_sel  	= (comp_addr==`M14K_EJS_DBM0);

	assign dbc_sel 	= (comp_addr==`M14K_EJS_DBC0);

	assign dbv_sel  	= (comp_addr==`M14K_EJS_DBV0);

	assign dbasid_sel = (comp_addr==`M14K_EJS_DBASID0) ;

	assign ej_sbdatain[31:0] = ({32{ibs_sel}} & ibs_out) |
			    ({32{dbs_sel}} & dbs_out) |
				dbld_out |
			    regbusdataout_i0 | regbusdataout_i1 |
			    regbusdataout_d0;

// IBS Register
	assign ibs_we			= ej_sbwrite & ibs_sel;

	assign ibs_updt		= | ibs_bs_set;

	assign ibs_rst_updt_we_sel	= greset | ibs_updt | ibs_we;

	assign ibs_bs_in [1:0]	= 	greset ? 2'b0 : ( ibs_we ? 
				(ej_eagdataout[1:0] & ibs_bs | ibs_bs_set) :
				(ibs_bs | ibs_bs_set));

	mvp_cregister #(2) _ibs_bs_1_0_(ibs_bs[1:0],ibs_rst_updt_we_sel, gclk, ibs_bs_in);

	mvp_register #(1) _asid_sup(asid_sup, gclk, ~cpz_mmutype);

	assign ibs_out [31:0]	= {1'b0, asid_sup, 2'b0, 4'd2, 9'b0, 13'b0, ibs_bs};

	
// DBS Register
	assign dbs_we			= ej_sbwrite & dbs_sel;

	assign dbs_updt		= dbs_bs_set;

	assign dbs_rst_updt_we_sel	= greset | dbs_updt | dbs_we;

	assign dbs_bs_in 	= 	greset ? 1'b0 : ( dbs_we ?
				(ej_eagdataout[0] & dbs_bs | dbs_bs_set) :
				(dbs_bs | dbs_bs_set));

	mvp_cregister #(1) _dbs_bs(dbs_bs,dbs_rst_updt_we_sel, gclk, dbs_bs_in);

	assign dbs_out [31:0]	= {1'b0, asid_sup, 2'b0, 4'd1, 9'b0, 14'b0, dbs_bs};

// Capture loaddata to allow recovery from precise data value breaks
// on non-replayable loads
	assign capture_lddata_w = (| (dbc_be & w_event)) & 
				mpc_sbstrobe_w & mpc_sbtake_w;

	mvp_cregister_wide #(32) _dbld_31_0_(dbld[31:0],gscanenable, capture_lddata_w, gclk,
					    gt_data);

	assign dbld_sel = (comp_addr == `M14K_EJS_DBLD);

	assign dbld_out [31:0] = dbld & {32{dbld_sel}};


// I Stage: I Channel Break & Generation of IBits
	assign mmu_ivastrobe_hwart = 1'b0;
	assign ejt_ivabrk	= | (i_match & ( {2{mmu_ivastrobe | icc_isachange0_i_reg | icc_isachange1_i_reg}} & ibc_be));

	mvp_register #(1) _mmu_ivastrobe_qual(mmu_ivastrobe_qual, gclk, 
		(mmu_ivastrobe_qual | mmu_ivastrobe | mmu_ivastrobe_hwart) & icc_umipsfifo_null_i & !greset);
	assign mmu_ivastrobe_umips = mmu_ivastrobe | mmu_ivastrobe_hwart | mmu_ivastrobe_qual;
	assign ejt_ibits [1:0]= {2{mmu_ivastrobe_umips}} & i_match;

// M Stage: D Channel Break & Generation of MBits
			// m1_activ marks channels which can cause an event
	assign m1_activ 	= {1{dcc_dvastrobe}} & (dbc_be | dbc_te) &
			(dcc_ldst_m ? ~(dbc_nolb | mpc_atomic_m) : ~dbc_nosb);
	assign m1_activ_ndv 	= {1{dcc_dvastrobe}} & (dcc_ldst_m & mpc_atomic_m ? ~dbc_nosb : dcc_ldst_m ? ~dbc_nolb : ~dbc_nosb);

			// m1_act_novm marks channels which can cause 
			// an event without doing value comparison

	assign m1_act_novm= ~d_do_vm & m1_activ_ndv;

			// m1_act_vm marks channels which can cause 
			// an event if value comparison yields true

	assign m1_act_vm = d_do_vm & m1_activ;

			// m1_no_vm marks channels with events 
			// where no value comparison was needed

	assign m1_no_vm 	= m1_act_novm & d_addr_m & ~mpc_lsdc1_w;

			// m1_vm marks channels which can cause
			// an event if value comp. yields true (addr ok)
	
	assign m1_vm 	= m1_act_vm & d_addr_m;

			// m1_data marks whether data needs to be compared

	assign m1_need_vm	= m1_vm;

			// m1_needw flags whether the load data are required
			// to resolve channel events
	assign m1_needw	= (dcc_ldst_m & m1_need_vm);

	assign m1_needm2      = (((cp2_ldst_m | cp1_ldst_m) & ~dcc_ldst_m) & m1_need_vm) | 
			  (need_cp2_stdata & ~dcc_stdstrobe & ~mpc_run_m);
	
	mvp_cregister #(1) _need_cp2_stdata(need_cp2_stdata,((dcc_dvastrobe | dcc_stdstrobe | mpc_run_m) & (~mpc_lsdc1_w | dbc_hwat)) | greset, gclk, m1_needm2 & ~greset);

	// detect hazard between previous load and new store in E
	assign ejt_stall_st_e = m1_needw | m1_needm2;
	
	mvp_cregister #(1) _pre_w2_vm(pre_w2_vm,(dcc_dvastrobe | dcc_stdstrobe) & (~mpc_lsdc1_w | dbc_hwat), gclk, m1_vm);
	assign w2_vm = pre_w2_vm & need_cp2_stdata;
			
	assign w2_need_vm = w2_vm;
	
			// m2_event marks channels with events where the value
			// comparison yielded true (only store transactions)

	assign m2_event = m1_vm & d_vmatch & {1{dcc_stdstrobe}};
	assign w2_event = w2_vm & d_vmatch & {1{dcc_stdstrobe}};

			// m1_event marks events in m1 
			// (load/store, both without value match)

	assign m1_event 	= {1{~(m1_needw & ~dcc_ldst_m)}} & m1_no_vm;

			// Now M break signal to processor can be generated:

	assign ejt_dvabrk	= (dbc_be & m1_event);	

			// Generate Dbits:
			// DBits[1] indicates that possible value match in W
			// DBits[0] indicates event in M

	assign ejt_dbits [1:0]= w2_need_vm ? ({1'b0, w2_event} | dbits_w) :
			// {({1{m1_needw}} & m1_vm), (m2_event | m1_event) };
			 {({1{m1_needw}} & m1_vm), (m2_event | m1_event & ~mpc_atomic_m | ejt_dvabrk) };


// M / W stage: Generate bytevalid signals:

	assign bytevalid_adr[3:0]	= gt_bytevalid_m;

	assign bytevalid_data[3:0]	= |{dbits_w[1], w2_vm} ? gt_bytevalid_w : gt_bytevalid_m;

// W Stage: I Status Bit Update & I Trigger generation
	assign i_trig [1:0]	= {2{mpc_sbstrobe_w}} & (ibits_w & ibc_te);

	assign ibs_bs_set [1:0]= i_trig | 
		     ({2{mpc_sbstrobe_w & mpc_sbtake_w_qual}} & (ibits_w & ibc_be));
	mvp_register #(1) _mpc_sbtake_w_delay(mpc_sbtake_w_delay, gclk, icc_umipsfifo_null_w & mpc_sbtake_w_long & ~greset);
	assign mpc_sbtake_w_long = mpc_sbtake_w | mpc_sbtake_w_delay;
	assign mpc_sbtake_w_qual = mpc_sbtake_w_long;


// W Stage: W Break, D Status Bit update & D Trigger generation

			// w_event marks events in W stage
			// any W events if there was a break
			// on the load instruction in the M stage are 
			// inhibited as an M stage killed load does not
			// assert dcc_lddatastr_w

	assign w_event 	= dbits_w[1] & {1{dcc_lddatastr_w}} & d_vmatch;

	assign ejt_dbrk_w	= (dbc_be & (w_event | w2_event));

	assign ejt_dbrk_m	= (dbc_be & m2_event);

	assign d_trig 	= {1{mpc_sbdstrobe_w}} & 
				(dbits_w[0] | w_event | w2_event) & dbc_te;

	assign dbs_bs_set = d_trig  | ({1{mpc_sbstrobe_w & mpc_sbtake_w}} & dbc_be &
				(w_event | w2_event | dbits_w[0]));

	// munge IVAAddr depending on presence of umips
	assign comp_iva [31:0] = (edp_iva_i_umips & {31'h7fff_ffff, ~(icc_umipspresent|mpc_umipspresent)}) |
			  {31'b0, (icc_umipspresent|mpc_umipspresent) & mpc_isamode_i};
	mvp_cregister_wide #(32) _edp_iva_i_macrod_31_0_(edp_iva_i_macrod[31:0],gscanenable, ~(icc_macro_e | mpc_macro_e | mpc_lsdc1_e) | greset, gclk, edp_iva_i[31:0] & {32{~greset}});
	assign edp_iva_i_umips [31:0] = mpc_isamode_i & (icc_macro_e|mpc_macro_e | mpc_lsdc1_e) ? edp_iva_i_macrod[31:0] : edp_iva_i[31:0];
	
// Pipeline results of data comparisons
// break status bits set if matching instruction reaches end of pipe
	assign latch_dbits     =  (mpc_run_m & dcc_dvastrobe) | (w2_need_vm & dcc_stdstrobe);

	assign clear_dbits = mpc_cleard_strobe & ~latch_dbits;
	assign write_dbits = latch_dbits | mpc_cleard_strobe;
	// dbits_w [1:0] = cregister(write_dbits & ~mpc_lsdc1_w, gclk, {2{~clear_dbits}} & ejt_dbits);
	mvp_cregister #(1) _dbits_w_1(dbits_w_1,write_dbits & (~mpc_lsdc1_w | dbc_hwat), gclk, ~clear_dbits & ejt_dbits[1]);
	mvp_cregister #(1) _dbits_w_0(dbits_w_0,write_dbits & (~mpc_lsdc1_w | dbc_hwat), gclk, ~clear_dbits & ejt_dbits[0]);
	assign dbits_w [1:0] = {dbits_w_1, dbits_w_0};

	// IVA Strobe is the first cycle of I.  If pipe is stalled - save compare bits
	// to i-stage register, otherwise go directly to E
	mvp_cregister #(2) _ibits_i_1_0_(ibits_i[1:0],mmu_ivastrobe_umips, gclk, {2{~mpc_run_ie}} & ejt_ibits);
	mvp_cregister #(2) _ibits_e_1_0_(ibits_e[1:0],mpc_run_ie, gclk, mmu_ivastrobe_umips ? ejt_ibits : ibits_i);
	mvp_cregister #(2) _ibits_m_1_0_(ibits_m[1:0],mpc_run_ie, gclk, ibits_e);
	mvp_cregister #(2) _ibits_w_1_0_(ibits_w[1:0],mpc_run_m, gclk, ibits_m);
	


// Instantiation of gate module

m14k_ejt_gate ejt_gate	(	.edp_iva_i	(comp_iva),
			.mmu_dva_m	(mmu_dva_m),
			.dcc_ejdata	(dcc_ejdata),
			.mpc_lsbe_m	(mpc_lsbe_m),
			.mpc_be_w	(mpc_be_w),
			.pwrsave_en	(pwrsave_en),
			.gt_ivaaddr	(gt_ivaaddr),
			.gt_dvaaddr	(gt_dvaaddr),
			.mmu_asid	(mmu_asid),
			.gt_asid	(gt_asid),
			.cpz_guestid	(cpz_guestid),
			.cpz_guestid_i	(cpz_guestid_i),
			.cpz_guestid_m	(cpz_guestid_m),
			.gt_guestid	(gt_guestid),
			.gt_guestid_i	(gt_guestid_i),
			.gt_guestid_m	(gt_guestid_m),
			.gt_data	(gt_data),
			.gt_bytevalid_m	(gt_bytevalid_m),
			.gt_bytevalid_w	(gt_bytevalid_w)
		);


// Instantiation of four I Channels

`M14K_EJT_IBRK0 #(0) ejt_ibrk0 (	
			.asidsup	(asid_sup),
			.asid		(gt_asid),
			.cpz_vz		(cpz_vz),
			.guestid	(gt_guestid_i),
			.ivaddr		(gt_ivaaddr),
			.regbusdatain	(ej_eagdataout),
			.iba_sel	(iba_sel[0]),
			.ibm_sel	(ibm_sel[0]),
			.ibasid_sel	(ibasid_sel[0]),
			.ibc_sel	(ibc_sel[0]),
			.we		(ej_sbwrite),
			.mpc_isamode_i  (mpc_isamode_i),
			.icc_halfworddethigh_i(icc_halfworddethigh_i),
			.umips_present	(icc_umipspresent|mpc_umipspresent),
			.gclk		( gclk),
			.greset		(greset),
			.gscanenable     (gscanenable),

			.i_match	(i_match[0]),
			.regbusdataout	(regbusdataout_i0),
			.ibc_be		(ibc_be[0]),
			.ibc_te		(ibc_te[0])
		);

`M14K_EJT_IBRK1 #(1) ejt_ibrk1 (	
			.asidsup	(asid_sup),
			.asid		(gt_asid),
			.cpz_vz		(cpz_vz),
			.guestid	(gt_guestid_i),
			.ivaddr		(gt_ivaaddr),				
			.regbusdatain	(ej_eagdataout),
			.iba_sel	(iba_sel[1]),
			.ibm_sel	(ibm_sel[1]),
			.ibasid_sel	(ibasid_sel[1]),
			.ibc_sel	(ibc_sel[1]),
			.we		(ej_sbwrite),
			.mpc_isamode_i  (mpc_isamode_i),
			.icc_halfworddethigh_i(icc_halfworddethigh_i),
			.umips_present	(icc_umipspresent|mpc_umipspresent),
			.gclk		( gclk),
			.greset		(greset),
			.gscanenable     (gscanenable),

			.i_match	(i_match[1]),
			.regbusdataout	(regbusdataout_i1),
			.ibc_be		(ibc_be[1]),
			.ibc_te		(ibc_te[1])
		);

// Instantiation of one D channel

`M14K_EJT_DBRK0 #(0) ejt_dbrk0 (
			.asidsup	(asid_sup),
			.asid		(gt_asid),
			.cpz_vz		(cpz_vz),
			.guestid	(gt_guestid_m),
			.dvaddr		(gt_dvaaddr),
			.data		(gt_data),
			.bytevalid_adr	(bytevalid_adr),
			.bytevalid_data	(bytevalid_data),
			.regbusdatain	(ej_eagdataout),
			.dba_sel	(dba_sel),
			.dbm_sel	(dbm_sel),
			.dbasid_sel	(dbasid_sel),
			.dbc_sel	(dbc_sel),
			.dbv_sel	(dbv_sel),
			.we		(ej_sbwrite),
			.mpc_bussize_m  (mpc_bussize_m),
			.gclk		( gclk),
			.greset		(greset),
			.gscanenable     (gscanenable),
			.mpc_lsdc1_m		(mpc_lsdc1_m),
			.mpc_lsdc1_w		(mpc_lsdc1_w),

			.dbc_hwat	(dbc_hwat),
			.d_addr_m	(d_addr_m),
			.d_do_vm	(d_do_vm),
			.d_vmatch	(d_vmatch),
			.regbusdataout	(regbusdataout_d0),
			.dbc_be		(dbc_be),
			.dbc_te		(dbc_te),
			.dbc_nolb	(dbc_nolb),
			.dbc_nosb	(dbc_nosb)
		);

endmodule

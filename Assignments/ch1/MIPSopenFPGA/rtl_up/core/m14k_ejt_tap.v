// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_ejt_tap
//           EJTAG TAP module
//
//	$Id: \$
//	mips_repository_id: m14k_ejt_tap.mv, v 1.13 
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
module m14k_ejt_tap(
	gfclk,
	gclk,
	gscanmode,
	gscanenable,
	greset,
	cpz_halt,
	cpz_doze,
	cpz_vz,
	cdmm_ej_override,
	cpz_guestid,
	ej_probtrap,
	cpz_dm,
	EJ_DebugM,
	cpz_enm,
	mpc_umipspresent,
	ej_paaccess,
	ej_padone,
	ej_eagwrite,
	ej_eagaddr,
	ej_eagbe,
	ej_eagdataout,
	ej_dcr_override,
	ej_padatain,
	ej_proben,
	ej_tap_brk,
	EJ_TCK,
	EJ_TMS,
	EJ_TDI,
	EJ_TDO,
	EJ_TDOzstate,
	EJ_ECREjtagBrk,
	EJ_TRST_N,
	EJ_ManufID,
	EJ_PartNumber,
	EJ_Version,
	EJ_DisableProbeDebug,
	cpz_mmutype,
	EJ_DINTsup,
	EJ_PrRst,
	EJ_PerRst,
	tck_softreset,
	tck_capture,
	tck_shift,
	tck_update,
	tck_inst,
	pdt_tcbdata,
	pdt_present_tck,
	ej_disableprobedebug,
	ej_isaondebug_read,
	pc_sync_period,
	pc_sync_period_diff,
	pcse,
	pc_im,
	pc_noasid,
	pc_noguestid,
	dasq,
	dase,
	mpc_cleard_strobe,
	mpc_exc_w,
	cpz_epc_w,
	mmu_asid,
	mmu_dva_m,
	icc_pm_icmiss,
	edp_iva_i,
	dcc_dvastrobe,
	brk_d_trig,
	AHB_EAddr,
	cdmm_fdcread,
	cdmm_fdcgwrite,
	cdmm_fdc_hit,
	mmu_cdmm_kuc_m,
	cpz_kuc_m,
	cdmm_wdata_xx,
	fdc_rdata_nxt,
	ej_fdc_int,
	ej_fdc_busy_xx,
	fdc_present,
	pcs_present,
	das_present);


// Signals between TAP and Core 
input		gfclk;		// Free running clock
input		gclk;		// Clock turned off by WAIT
input		gscanmode;      	// ScanMode Control of gating logic and EJ_TCK inversion
input 	        gscanenable;     // gscanenable for gated clock cregisters
input   	greset;          // reset
input		cpz_halt;	// To Halt bit in ECR
input		cpz_doze;	// To Doze bit in ECR
input		cpz_vz;
input		cdmm_ej_override;
input [7:0]	cpz_guestid;	// Guest ID
output		ej_probtrap;	// From ProbTrap bit in ECR after sync to gclk
input		cpz_dm;		// Debug mode indication
input 	        EJ_DebugM;         // Earlier in the pipe DebugMode indication
input		cpz_enm;		// Endian mode for kernal and debug mode
input 	        mpc_umipspresent;  // UMIPS block is present
	

// Signals between TAP and EJTAG Area 
input		ej_paaccess;	// PA Access
output		ej_padone;	// PA Done
input		ej_eagwrite;	// Gated PA Write
input	[19:2]	ej_eagaddr;	// Gated PA Address
input	[3:0]	ej_eagbe;	// Gated PA Byte enables
input	[31:0]	ej_eagdataout;	// Gated PA Data for store
input           ej_dcr_override;
output	[31:0]	ej_padatain;	// PA data from fetch/load
output		ej_proben;	// ProbEn bit from ECR after sync to gclk
output		ej_tap_brk;	// From EjtagBrk bit in ECR

// Signals between TAP and Core boundary 
input		EJ_TCK;		// TCK
input		EJ_TMS;		// TMS
input		EJ_TDI;		// TDI
output		EJ_TDO;		// TDO
output		EJ_TDOzstate;	// TDO tri-state
output 	        EJ_ECREjtagBrk; // ECR.EjtagBrk bit
   
input		EJ_TRST_N;	// TRST*
input	[10:0]	EJ_ManufID;	// For ManufID in Device ID reg
input	[15:0]	EJ_PartNumber;	// For PartNumber in Device ID reg
input	[3:0]	EJ_Version;	// For Version in Device ID reg
input		EJ_DisableProbeDebug; // Disables Probe, EJTAGBOOT, PCSampling
input		cpz_mmutype;	// For generation of ASIDsize in Impl. reg
input		EJ_DINTsup;	// For generation of DINTsup in Impl. reg
output		EJ_PrRst;	// From PrRst bit in ECR
output		EJ_PerRst;	// From PerRst in ECR

// Signals between TAP and Trace Capture Block EJTAG registers 
// Remark: The TCB should pickup EJ_TCK, EJ_TRST_N and EJ_TDI on its own
output 		tck_softreset;	// TAP Control State is Test-Logic-greset
output 		tck_capture;	// TAP Control State is Capture-DR
output 		tck_shift;	// TAP Control State is Shift-DR
output 		tck_update;	// TAP Control State is Update-DR
output [4:0] 	tck_inst;	// Current contents of TAP Instruction Register
input 		pdt_tcbdata;	// Data from TCB shift register(s)
input 		pdt_present_tck;// EJ_TCK synchronous version of PDI_TCBPresent
output		ej_disableprobedebug; // disable probe debug unregistered
output		ej_isaondebug_read; 

input  [2:0]    pc_sync_period;      // sync period for PC sampling
input           pc_sync_period_diff; // indicates a change in PC sync period.
                                     // used to clear the pc sample counter
input           pcse;                // PC Sample Enable bit
input		pc_im;
input		pc_noasid;
input		pc_noguestid;
input		dasq;
input		dase;	
input           mpc_cleard_strobe;   // monitoring bit for instruction completion
input           mpc_exc_w;           // Exception in W-stage
input  [31:0]   cpz_epc_w;           // Address of inst in W
input  [7:0]    mmu_asid;            // ASID value in cpz (from cpy in mmu)
input [31:0]    mmu_dva_m;
input           icc_pm_icmiss;  // Perf. monitor I$ miss
input  [31:0]   edp_iva_i;
input           dcc_dvastrobe;
input  [1:0]    brk_d_trig;

input   [14:2]  AHB_EAddr;       // EJTAG Area address
input 	cdmm_fdcread;
input	cdmm_fdcgwrite;
input   cdmm_fdc_hit;
input		mmu_cdmm_kuc_m;
input           cpz_kuc_m;
input [31:0] cdmm_wdata_xx;
output [31:0] fdc_rdata_nxt;
output          ej_fdc_int;
output		ej_fdc_busy_xx;
output		fdc_present;
output		pcs_present;
output		das_present;

// BEGIN Wire declarations made by MVP
wire ej_probtrap;
wire b_prev_next;
wire padone_real_sync;
wire ej_tapejtagbrk_sync;
wire EJ_PerRst;
wire ej_perrst_pre;
wire ej_tapejtagbrk_pre;
wire b_nop_stuff;
wire padone_pulse_pre;
wire b_stuff;
wire ej_probtrap_pre;
wire ej_proben_pre;
wire padone_real_sync_pre;
wire ej_dm_delay;
wire [31:0] /*[31:0]*/ pa_data_inst_stuff;
wire ej_isaondebug_read_pre;
wire ej_padone;
wire ej_proben;
wire ej_tap_brk;
wire ej_prrst_pre;
wire paacc_real;
wire padone_pulse;
wire b_prev;
wire EJ_PrRst;
wire ej_isaondebug_read;
// END Wire declarations made by MVP



// Wires 
wire    [55:0]  pcsam_val;
wire    [55:0]  dasam_val;
wire	[31:0]	pa_data_reg_done;	// Wire for bus
wire	[31:0]	ej_padatain;	// Processor Access data return
wire	[35:0]  fdc_rxdata_tck;
wire    [35:0]  fdc_txdata_gclk;
wire 	padone_real;
wire 	ejtagbrk;
wire 	probtrap;
wire 	proben;
wire 	prrst;
wire 	perrst;
wire	isaondebug_read;
wire	new_pcs_gclk;
wire 	new_pcs_ack_tck;
wire	new_das_gclk;
wire	new_das_ack_tck;
wire	fdc_rxint_ack_gclk;
wire	fdc_rxint_tck;
wire	fdc_txtck_used_tck;
wire	fdc_txdata_ack_tck;
wire	fdc_txdata_rdy_gclk;
wire	fdc_rxdata_rdy_tck;
wire	fdc_rxdata_ack_gclk;


// TAP part in TCK domain 
m14k_ejt_tck ejt_tck(
	.greset(greset),
	.cpz_enm(cpz_enm),
	.cpz_vz(cpz_vz),
	.cdmm_ej_override(cdmm_ej_override),
	.ej_dcr_override(ej_dcr_override),
	.mpc_umipspresent(mpc_umipspresent),
	.gscanmode(gscanmode),
	.gscanenable(gscanenable),
	.ej_eagaddr(ej_eagaddr[19:2]),
	.ej_eagbe(ej_eagbe[3:0]),
	.ej_eagdataout(ej_eagdataout[31:0]),
	.paacc_real(paacc_real),
	.padone_real(padone_real),
	.padone_real_sync(padone_real_sync),
	.pa_data_reg_done(pa_data_reg_done[31:0]),
	.EJ_TCK(EJ_TCK),
	.EJ_TMS(EJ_TMS),
	.EJ_TDI(EJ_TDI),
	.EJ_TDO(EJ_TDO),
	.EJ_TDOzstate(EJ_TDOzstate),
        .EJ_ECREjtagBrk(EJ_ECREjtagBrk),
	.EJ_TRST_N(EJ_TRST_N),
	.EJ_ManufID(EJ_ManufID[10:0]),
	.EJ_PartNumber(EJ_PartNumber[15:0]),
	.EJ_Version(EJ_Version[3:0]),
	.EJ_DisableProbeDebug(EJ_DisableProbeDebug),
	.ej_disableprobedebug(ej_disableprobedebug),
	.cpz_mmutype(cpz_mmutype),
	.EJ_DINTsup(EJ_DINTsup),
	.tck_softreset(tck_softreset),
	.tck_capture(tck_capture),
	.tck_shift(tck_shift),
	.tck_update(tck_update),
	.tck_inst(tck_inst),
	.pdt_tcbdata(pdt_tcbdata),
	.pdt_present_tck(pdt_present_tck),
	.cpz_dm(cpz_dm),
	.EJ_DebugM(EJ_DebugM),
	.ejtagbrk(ejtagbrk),
	.probtrap(probtrap),
	.ej_probtrap(ej_probtrap),
	.proben(proben),
	.ej_proben(ej_proben),
	.prrst(prrst),
	.EJ_PrRst(EJ_PrRst),
	.ej_eagwrite(ej_eagwrite),
	.perrst(perrst),
	.EJ_PerRst(EJ_PerRst),
	.cpz_halt(cpz_halt),
	.cpz_doze(cpz_doze),
	.isaondebug_read(isaondebug_read),
        .pcsam_val(pcsam_val),
	.new_pcs_gclk(new_pcs_gclk),
	.new_pcs_ack_tck(new_pcs_ack_tck),
	.dasam_val(dasam_val),
	.new_das_gclk(new_das_gclk),
	.new_das_ack_tck(new_das_ack_tck),
	.pc_noasid(pc_noasid),
	.pc_noguestid(pc_noguestid | ~cpz_vz),
	.pcse(pcse),
	.dase(dase),
	.pcs_present(pcs_present),
	.das_present(das_present),
	.fdc_present(fdc_present),
	.fdc_rxint_ack_gclk(fdc_rxint_ack_gclk),
	.fdc_rxint_tck(fdc_rxint_tck),
	.fdc_txtck_used_tck(fdc_txtck_used_tck),
	.fdc_txdata_ack_tck(fdc_txdata_ack_tck),
	.fdc_txdata_rdy_gclk(fdc_txdata_rdy_gclk),
	.fdc_txdata_gclk(fdc_txdata_gclk),
	.fdc_rxdata_ack_gclk(fdc_rxdata_ack_gclk),
	.fdc_rxdata_rdy_tck(fdc_rxdata_rdy_tck),
	.fdc_rxdata_tck(fdc_rxdata_tck)
);

   `M14K_PCS_MODULE ejt_tap_pcsam(
        .pcs_present(pcs_present),
	.cpz_epc_w(cpz_epc_w[31:0]),
	.cpz_guestid(cpz_guestid[7:0]),
  	.mpc_cleard_strobe(mpc_cleard_strobe),
	.mpc_exc_w(mpc_exc_w),
	.edp_iva_i(edp_iva_i),
        .mmu_asid(mmu_asid[7:0]),
        .icc_pm_icmiss(icc_pm_icmiss),
        .gclk( gclk),
        .greset(greset),
        .gscanenable(gscanenable),
        .new_pcs_ack_tck(new_pcs_ack_tck),
        .new_pcs_gclk(new_pcs_gclk),
        .pc_sync_period(pc_sync_period),
        .pc_sync_period_diff(pc_sync_period_diff),
        .pcsam_val(pcsam_val),
        .pcse(pcse),
	.pc_im(pc_im)
);

   `M14K_DAS_MODULE ejt_tap_dasam(
	.das_present(das_present),
        .mmu_asid(mmu_asid[7:0]),
        .mmu_dva_m(mmu_dva_m),
	.cpz_guestid(cpz_guestid[7:0]),
        .dcc_dvastrobe(dcc_dvastrobe),
        .gclk( gclk),
        .greset(greset),
        .gscanenable(gscanenable),
        .pc_sync_period(pc_sync_period),
        .pc_sync_period_diff(pc_sync_period_diff),
        .brk_d_trig(brk_d_trig),
        .dasam_val(dasam_val),
        .new_das_ack_tck(new_das_ack_tck),
        .new_das_gclk(new_das_gclk),
        .dasq(dasq),
        .dase(dase)
);

   `M14K_FDC_MODULE ejt_tap_fdc(
	.gclk( gclk),
	.gfclk( gfclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.cdmm_fdcread(cdmm_fdcread),
	.cdmm_fdcgwrite(cdmm_fdcgwrite),
	.cdmm_fdc_hit(cdmm_fdc_hit),
	.AHB_EAddr(AHB_EAddr[14:2]),
	.cdmm_wdata_xx(cdmm_wdata_xx),
	.cpz_kuc_m(cpz_kuc_m),
	.mmu_cdmm_kuc_m(mmu_cdmm_kuc_m),
	.fdc_rdata_nxt(fdc_rdata_nxt),
	.fdc_rxdata_tck(fdc_rxdata_tck[35:0]),
	.fdc_rxdata_rdy_tck(fdc_rxdata_rdy_tck),
	.fdc_rxdata_ack_gclk(fdc_rxdata_ack_gclk),
	.fdc_txdata_gclk(fdc_txdata_gclk[35:0]),
	.fdc_txdata_rdy_gclk(fdc_txdata_rdy_gclk),
	.fdc_txdata_ack_tck(fdc_txdata_ack_tck),
	.fdc_txtck_used_tck(fdc_txtck_used_tck),
	.fdc_rxint_tck(fdc_rxint_tck),
	.fdc_rxint_ack_gclk(fdc_rxint_ack_gclk),
	.ej_fdc_int(ej_fdc_int),
	.fdc_busy_xx(ej_fdc_busy_xx),
	.fdc_present(fdc_present)
);


// EJTAG Control register gclk gfclk domain parts 

// EjtagBrk bit, sync to gfclk
mvp_register #(1) _ej_tapejtagbrk_pre(ej_tapejtagbrk_pre, gfclk, ejtagbrk);
mvp_register #(1) _ej_tapejtagbrk_sync(ej_tapejtagbrk_sync, gfclk, ej_tapejtagbrk_pre);
// Delay EJ_DebugM
mvp_register #(1) _ej_dm_delay(ej_dm_delay, gfclk, EJ_DebugM);
// Generate ej_tap_brk
assign ej_tap_brk = ej_tapejtagbrk_sync & ~ej_dm_delay;

// ProbTrap bit, sync to gfclk
mvp_register #(1) _ej_probtrap_pre(ej_probtrap_pre, gfclk, probtrap);
mvp_register #(1) _ej_probtrap(ej_probtrap, gfclk, ej_probtrap_pre);

// ProbEn bit, sync to gfclk
mvp_register #(1) _ej_proben_pre(ej_proben_pre, gfclk, proben);
mvp_register #(1) _ej_proben(ej_proben, gfclk, ej_proben_pre);

// PrRst bit, sync to gfclk
mvp_register #(1) _ej_prrst_pre(ej_prrst_pre, gfclk, prrst);
mvp_register #(1) _EJ_PrRst(EJ_PrRst, gfclk, ej_prrst_pre);

// PerRst bit, sync to gfclk
mvp_register #(1) _ej_perrst_pre(ej_perrst_pre, gfclk, perrst);
mvp_register #(1) _EJ_PerRst(EJ_PerRst, gfclk, ej_perrst_pre);

mvp_register #(1) _ej_isaondebug_read_pre(ej_isaondebug_read_pre, gclk, isaondebug_read);
mvp_register #(1) _ej_isaondebug_read(ej_isaondebug_read, gclk, ej_isaondebug_read_pre);

// Processor Access handling with return of PA Data register 

// Determine if B or NOP stuffing is used, and what to stuff
assign b_nop_stuff = ~cpz_dm | (cpz_dm & ej_eagaddr[2] & b_prev);
assign b_stuff = ~cpz_dm & ~ej_eagaddr[2];

// Make branch previous indication
mvp_cregister #(1) _b_prev(b_prev,ej_padone | greset, gclk, b_prev_next);
assign b_prev_next = b_stuff & ~greset;

// Generate paacc_real
mvp_register #(1) _paacc_real(paacc_real, gclk, ej_paaccess & ~b_nop_stuff);

// padone_real sync to gclk
mvp_register #(1) _padone_real_sync_pre(padone_real_sync_pre, gclk, padone_real);
mvp_register #(1) _padone_real_sync(padone_real_sync, gclk, padone_real_sync_pre);

// Generate pulse when padone_real_sync is asserted
mvp_register #(1) _padone_pulse_pre(padone_pulse_pre, gclk, padone_real_sync);
assign padone_pulse = ~padone_pulse_pre & padone_real_sync;

// Generate done PA indication
assign ej_padone = ej_paaccess & (b_nop_stuff | padone_pulse);

// Define values for B to itself and NOP 
`define	M14K_B_ITSELF		32'h1000FFFF
`define	M14K_NOP			32'h00000000 

// Make output data
assign pa_data_inst_stuff[31:0] = b_stuff ? `M14K_B_ITSELF : `M14K_NOP;
m14k_ejt_bus32mux2 ej_padatain_i(.y(ej_padatain[31:0]), 
              .s(padone_pulse), .b(pa_data_reg_done[31:0]), 
              .a(pa_data_inst_stuff[31:0]));



// The End 

endmodule

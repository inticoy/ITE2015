// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//	Description: m14k_cdmm
//
//      $Id: \$
//      mips_repository_id: m14k_cdmm.hook, v 3.14 
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

module m14k_cdmm(
	gclk,
	greset,
	gscanenable,
	AHB_EAddr,
	HWRITE,
	biu_if_enable,
	ejt_predonenxt,
	ejt_eadone,
	fdc_present,
	fdc_rdata_nxt,
	cdmm_wdata_xx,
	mmu_cdmm_kuc_m,
	mmu_ivastrobe,
	mpc_newiaddr,
	cpz_cdmmbase,
	cpz_vz,
	cpz_hotdm_i,
	cpz_dm_m,
	cpz_kuc_i,
	cpz_kuc_m,
	cpz_iret_ret,
	cpz_eret_m,
	mpc_squash_i,
	mpc_pexc_i,
	mpc_pexc_e,
	mpc_atomic_m,
	mpc_busty_m,
	mpc_mpustrobe_w,
	mpc_mputake_w,
	mpc_cleard_strobe,
	mpc_run_ie,
	mpc_run_m,
	mpc_fixup_m,
	mpc_ebld_e,
	mpc_ebexc_w,
	mpc_isamode_i,
	mpc_mputriggeredres_i,
	mpc_macro_e,
	mpc_macro_end_e,
	icc_macroend_e,
	icc_macro_e,
	icc_slip_n_nhalf,
	icc_umipsfifo_stat,
	dcc_dvastrobe,
	mpc_icop_m,
	dcc_dcopaccess_m,
	edp_cacheiva_i,
	edp_iva_i,
	mmu_dva_m,
	cpz_gm_m,
	cdmm_area,
	cdmm_sel,
	cdmm_hit,
	cdmm_fdc_hit,
	cdmm_fdcread,
	cdmm_fdcgwrite,
	cdmm_mpu_present,
	cdmm_mmulock,
	cdmm_mpu_numregion,
	cdmm_mputriggered_i,
	cdmm_mputriggered_m,
	cdmm_mpuipdt_w,
	cdmm_ej_override,
	cdmm_mputrigresraw_i,
	cdmm_rdata_xx);

/*hookios*//* IO declarations added by hookup */
/* End of hookup IO declarations */
/* Wire declarations added by hookup */
wire cdmm_mpu_hit;
wire cdmm_mpugwrite;
wire [31:0] cdmm_mpurdata_nxt;		//mpu read data
wire cdmm_mpuread;
/* End of hookup wire declarations */

	input	gclk;
	input	greset;
	input	gscanenable;

	input [31:2]	AHB_EAddr;
	input	HWRITE;
	input	biu_if_enable;
	input	ejt_predonenxt;
	input	ejt_eadone;

	input	fdc_present;
	input  [31:0]	fdc_rdata_nxt; //fdc read data
	input [31:0]	cdmm_wdata_xx;
	
	input	mmu_cdmm_kuc_m;
	input	mmu_ivastrobe;
	input	mpc_newiaddr;
	input [31:15]	cpz_cdmmbase;
	input	cpz_vz;
	input	cpz_hotdm_i;
	input	cpz_dm_m;
	input	cpz_kuc_i;
	input	cpz_kuc_m;
	input	cpz_iret_ret;		//active iret for writing registers
	input	cpz_eret_m;		//active eret for writing registers (m stage)
	input	mpc_squash_i;
	input	mpc_pexc_i;
	input	mpc_pexc_e;
	input	mpc_atomic_m;
	input [2:0]	mpc_busty_m;
	input	mpc_mpustrobe_w;
	input	mpc_mputake_w;
	input	mpc_cleard_strobe;
	input	mpc_run_ie;
	input	mpc_run_m;
	input	mpc_fixup_m;
	input	mpc_ebld_e;	// ebase write in e stage
	input	mpc_ebexc_w;	    // core taking ebase exception
	input	mpc_isamode_i;
	input	mpc_mputriggeredres_i;
	input	mpc_macro_e;
	input	mpc_macro_end_e;
	input	icc_macroend_e;
	input	icc_macro_e;
	input	icc_slip_n_nhalf;
	input [3:0]	icc_umipsfifo_stat;
	input	dcc_dvastrobe;
	input	mpc_icop_m;
	input	dcc_dcopaccess_m;
	input [31:0]	edp_cacheiva_i;
	input [31:0]	edp_iva_i;
	input [31:0]	mmu_dva_m;
	input	cpz_gm_m;

	output	cdmm_area;
	output	cdmm_sel;
	output	cdmm_hit;
	output	cdmm_fdc_hit;
	output 	cdmm_fdcread;
	output	cdmm_fdcgwrite;
	output	cdmm_mpu_present;
	output	cdmm_mmulock;
	output [3:0] cdmm_mpu_numregion;
	output	cdmm_mputriggered_i;
	output	cdmm_mputriggered_m;
	output	cdmm_mpuipdt_w;
	output	cdmm_ej_override;
	output	cdmm_mputrigresraw_i;
	output [31:0]	cdmm_rdata_xx; // CDMM read data


/*hookup*/
m14k_cdmm_ctl cdmm_ctl (
	.AHB_EAddr(AHB_EAddr),
	.HWRITE(HWRITE),
	.biu_if_enable(biu_if_enable),
	.cdmm_area(cdmm_area),
	.cdmm_fdc_hit(cdmm_fdc_hit),
	.cdmm_fdcgwrite(cdmm_fdcgwrite),
	.cdmm_fdcread(cdmm_fdcread),
	.cdmm_hit(cdmm_hit),
	.cdmm_mpu_hit(cdmm_mpu_hit),
	.cdmm_mpu_numregion(cdmm_mpu_numregion),
	.cdmm_mpu_present(cdmm_mpu_present),
	.cdmm_mpugwrite(cdmm_mpugwrite),
	.cdmm_mpurdata_nxt(cdmm_mpurdata_nxt),
	.cdmm_mpuread(cdmm_mpuread),
	.cdmm_rdata_xx(cdmm_rdata_xx),
	.cdmm_sel(cdmm_sel),
	.cpz_cdmmbase(cpz_cdmmbase),
	.cpz_gm_m(cpz_gm_m),
	.ejt_eadone(ejt_eadone),
	.ejt_predonenxt(ejt_predonenxt),
	.fdc_present(fdc_present),
	.fdc_rdata_nxt(fdc_rdata_nxt),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable));

/*hookup*/
`M14K_MPU_MODULE cdmm_mpu (
	.AHB_EAddr(AHB_EAddr[14:2]),
	.cdmm_ej_override(cdmm_ej_override),
	.cdmm_mmulock(cdmm_mmulock),
	.cdmm_mpu_hit(cdmm_mpu_hit),
	.cdmm_mpu_numregion(cdmm_mpu_numregion),
	.cdmm_mpu_present(cdmm_mpu_present),
	.cdmm_mpugwrite(cdmm_mpugwrite),
	.cdmm_mpuipdt_w(cdmm_mpuipdt_w),
	.cdmm_mpurdata_nxt(cdmm_mpurdata_nxt),
	.cdmm_mpuread(cdmm_mpuread),
	.cdmm_mputriggered_i(cdmm_mputriggered_i),
	.cdmm_mputriggered_m(cdmm_mputriggered_m),
	.cdmm_mputrigresraw_i(cdmm_mputrigresraw_i),
	.cdmm_wdata_xx(cdmm_wdata_xx),
	.cpz_dm_m(cpz_dm_m),
	.cpz_eret_m(cpz_eret_m),
	.cpz_hotdm_i(cpz_hotdm_i),
	.cpz_iret_ret(cpz_iret_ret),
	.cpz_kuc_i(cpz_kuc_i),
	.cpz_kuc_m(cpz_kuc_m),
	.cpz_vz(cpz_vz),
	.dcc_dcopaccess_m(dcc_dcopaccess_m),
	.dcc_dvastrobe(dcc_dvastrobe),
	.edp_cacheiva_i(edp_cacheiva_i),
	.edp_iva_i(edp_iva_i),
	.fdc_present(fdc_present),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.icc_macro_e(icc_macro_e),
	.icc_macroend_e(icc_macroend_e),
	.icc_slip_n_nhalf(icc_slip_n_nhalf),
	.icc_umipsfifo_stat(icc_umipsfifo_stat),
	.mmu_cdmm_kuc_m(mmu_cdmm_kuc_m),
	.mmu_dva_m(mmu_dva_m),
	.mmu_ivastrobe(mmu_ivastrobe),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_busty_m(mpc_busty_m),
	.mpc_cleard_strobe(mpc_cleard_strobe),
	.mpc_ebexc_w(mpc_ebexc_w),
	.mpc_ebld_e(mpc_ebld_e),
	.mpc_fixup_m(mpc_fixup_m),
	.mpc_icop_m(mpc_icop_m),
	.mpc_isamode_i(mpc_isamode_i),
	.mpc_macro_e(mpc_macro_e),
	.mpc_macro_end_e(mpc_macro_end_e),
	.mpc_mpustrobe_w(mpc_mpustrobe_w),
	.mpc_mputake_w(mpc_mputake_w),
	.mpc_mputriggeredres_i(mpc_mputriggeredres_i),
	.mpc_newiaddr(mpc_newiaddr),
	.mpc_pexc_e(mpc_pexc_e),
	.mpc_pexc_i(mpc_pexc_i),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_squash_i(mpc_squash_i));

endmodule	// m14k_cpu

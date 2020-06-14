// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//      Description: m14k_cdmm_ctl
//      CDMM Memory Proection Unit
//
//      $Id: \$
//      mips_repository_id: m14k_cdmm_ctl.mv, v 3.9 
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

module m14k_cdmm_ctl(
	gclk,
	greset,
	gscanenable,
	cpz_cdmmbase,
	ejt_predonenxt,
	ejt_eadone,
	fdc_present,
	cdmm_mpu_present,
	cdmm_mpu_numregion,
	AHB_EAddr,
	HWRITE,
	biu_if_enable,
	fdc_rdata_nxt,
	cdmm_mpurdata_nxt,
	cpz_gm_m,
	cdmm_rdata_xx,
	cdmm_area,
	cdmm_sel,
	cdmm_hit,
	cdmm_fdc_hit,
	cdmm_fdcread,
	cdmm_fdcgwrite,
	cdmm_mpu_hit,
	cdmm_mpuread,
	cdmm_mpugwrite);

	input	gclk;
	input	greset;
	input	gscanenable;
	input [31:15]	cpz_cdmmbase;
	input	ejt_predonenxt;
	input	ejt_eadone;
	input	fdc_present;
	input	cdmm_mpu_present;
	input [3:0]	cdmm_mpu_numregion;
	input [31:2]	AHB_EAddr;
	input	HWRITE;
	input	biu_if_enable;
	input  [31:0]	fdc_rdata_nxt; //fdc read data
	input  [31:0]	cdmm_mpurdata_nxt; //mpu read data
	input	cpz_gm_m;
	output [31:0]	cdmm_rdata_xx; // CDMM read data
	output	cdmm_area;
	output	cdmm_sel;
	output	cdmm_hit;
	output	cdmm_fdc_hit;
	output 	cdmm_fdcread;
	output	cdmm_fdcgwrite;
	output	cdmm_mpu_hit;
	output 	cdmm_mpuread;
	output	cdmm_mpugwrite;

// BEGIN Wire declarations made by MVP
wire cdmm_sel;
wire cdmm_mpuread;
wire cdmm_area_fdc;
wire cdmm_fdcread;
wire mpu_hit_nfdc_tmp;
wire cdmm_fdcgwrite;
wire cdmm_mpu_hit;
wire cdmm_fdc_hit;
wire cdmm_area;
wire last_read;
wire mpu_hit_tmp;
wire cdmm_mpugwrite;
wire cdmm_arearead;
wire cdmm_area_mpu;
wire [31:0] /*[31:0]*/ cdmm_rdata_nxt;
wire [31:0] /*[31:0]*/ cdmm_rdata_xx;
wire cdmm_hit;
wire mpu_hit_fdc_tmp;
// END Wire declarations made by MVP



assign cdmm_area = (AHB_EAddr[31:15] == cpz_cdmmbase[31:15]);
assign cdmm_hit = cdmm_area && (fdc_present && !cpz_gm_m || cdmm_mpu_present);
mvp_register #(1) _cdmm_sel(cdmm_sel, gclk, cdmm_hit);

// Area / Device Hit Controls
// Area hits if device is implemented and cdmm matches
// Device hits if area hits and specific DRB address is correct
// Selects are registered versions of the hits
assign cdmm_area_fdc = cdmm_area && fdc_present && !cpz_gm_m;
assign cdmm_fdc_hit = cdmm_area_fdc & (AHB_EAddr[14:8] == 7'b0) & (AHB_EAddr[7:6] != 2'b11);
//cdmm_fdc_sel = register( gclk, cdmm_fdc_hit);

assign cdmm_area_mpu = cdmm_area && cdmm_mpu_present;

assign mpu_hit_nfdc_tmp  = 
		cdmm_mpu_numregion[3:1]==3'o0 ? AHB_EAddr[9:6]==4'h0 :
		cdmm_mpu_numregion[3:1]==3'o1 ? AHB_EAddr[9:7]==3'h0 :
		cdmm_mpu_numregion[3:1]==3'o2 ? AHB_EAddr[9:7]==3'h0 | AHB_EAddr[9:6]==4'h2 :
		cdmm_mpu_numregion[3:1]==3'o3 ? AHB_EAddr[9:8]==2'b00 :
		cdmm_mpu_numregion[3:1]==3'o4 ? AHB_EAddr[9:8]==2'b00 | AHB_EAddr[9:6]==4'h4 :
		cdmm_mpu_numregion[3:1]==3'o5 ? AHB_EAddr[9:8]==2'b00 | AHB_EAddr[9:6]==4'h4 | AHB_EAddr[9:6]==4'h5 :
		cdmm_mpu_numregion[3:1]==3'o6 ? AHB_EAddr[9:8]==2'b00 | AHB_EAddr[9:6]==4'h4 | AHB_EAddr[9:6]==4'h5 | AHB_EAddr[9:6]==4'h6 :
						AHB_EAddr[9]==1'b0 ;
assign mpu_hit_fdc_tmp = cdmm_mpu_numregion[3:1]==3'o0 ? AHB_EAddr[9:6]==4'h3 :
                   cdmm_mpu_numregion[3:1]==3'o1 ? AHB_EAddr[9:6]==4'h3 | AHB_EAddr[9:6]==4'h4 :
                   cdmm_mpu_numregion[3:1]==3'o2 ? AHB_EAddr[9:6]==4'h3 | AHB_EAddr[9:6]==4'h4 | AHB_EAddr[9:6]==4'h5 :
                   cdmm_mpu_numregion[3:1]==3'o3 ? AHB_EAddr[9:6]==4'h3 | AHB_EAddr[9:6]==4'h4 | AHB_EAddr[9:6]==4'h5 | AHB_EAddr[9:6]==4'h6 :
                   cdmm_mpu_numregion[3:1]==3'o4 ? AHB_EAddr[9:6]==4'h3 | AHB_EAddr[9:6]==4'h4 | AHB_EAddr[9:6]==4'h5 | 
						   AHB_EAddr[9:6]==4'h6 | AHB_EAddr[9:6]==4'h7 :
                   cdmm_mpu_numregion[3:1]==3'o5 ? AHB_EAddr[9:6]==4'h3 | AHB_EAddr[9:6]==4'h4 | AHB_EAddr[9:6]==4'h5 |
						   AHB_EAddr[9:6]==4'h6 | AHB_EAddr[9:6]==4'h7 | AHB_EAddr[9:6]==4'h8 :
                   cdmm_mpu_numregion[3:1]==3'o6 ? AHB_EAddr[9:6]==4'h3 | AHB_EAddr[9:6]==4'h4 | AHB_EAddr[9:6]==4'h5 |
						   AHB_EAddr[9:6]==4'h6 | AHB_EAddr[9:6]==4'h7 | AHB_EAddr[9:6]==4'h8 |
						   AHB_EAddr[9:6]==4'h9 :
                   				   AHB_EAddr[9:6]==4'h3 | AHB_EAddr[9:6]==4'h4 | AHB_EAddr[9:6]==4'h5 | 
						   AHB_EAddr[9:6]==4'h6 | AHB_EAddr[9:6]==4'h7 | AHB_EAddr[9:6]==4'h8 |
						   AHB_EAddr[9:6]==4'h9 | AHB_EAddr[9:6]==4'ha ;
assign mpu_hit_tmp = fdc_present & mpu_hit_fdc_tmp | ~fdc_present & mpu_hit_nfdc_tmp;
assign cdmm_mpu_hit = cdmm_area_mpu & AHB_EAddr[14:10]==5'b0 & mpu_hit_tmp;
//cdmm_mpu_sel = register( gclk, cdmm_mpu_hit);


// Read / Write Controls
/* fdc controls are under tap because they are tightly coupled with tap serial streams
*/
//CDMM AREA
assign cdmm_arearead = !HWRITE & ejt_predonenxt & cdmm_area;
//cdmm_areagwrite = HWRITE & ejt_eadone & biu_if_enable & cdmm_area;

// CDMM FDC
assign cdmm_fdcread = !HWRITE & ejt_predonenxt & cdmm_fdc_hit;
assign cdmm_fdcgwrite = HWRITE & ejt_eadone & biu_if_enable & cdmm_fdc_hit;
// CDMM MPU
assign cdmm_mpuread	= !HWRITE & ejt_predonenxt & cdmm_mpu_hit;
assign cdmm_mpugwrite	=  HWRITE & ejt_eadone & biu_if_enable & cdmm_mpu_hit;


// Read Mux 
mvp_mux2 #(32) _cdmm_rdata_nxt_31_0_(cdmm_rdata_nxt[31:0],cdmm_fdc_hit, cdmm_mpurdata_nxt, fdc_rdata_nxt);
mvp_register #(1) _last_read(last_read, gclk, cdmm_fdcread | cdmm_mpuread);
mvp_cregister_wide #(32) _cdmm_rdata_xx_31_0_(cdmm_rdata_xx[31:0],gscanenable,  
				( cdmm_arearead & ~last_read), 
				gclk,
				cdmm_rdata_nxt);

endmodule


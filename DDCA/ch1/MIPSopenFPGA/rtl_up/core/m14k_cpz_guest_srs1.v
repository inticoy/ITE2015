// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_cpz_guest_srs1
//           Coprocessor Zero Shadow Register Set control
//
//	$Id: \$
//	mips_repository_id: m14k_cpz_guest_srs1.mv, v 3.5 
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
//	
//	

`include "m14k_const.vh"

module m14k_cpz_guest_srs1(
	gscanenable,
	greset,
	gclk,
	srsctl_rd,
	srsctl_ld,
	srsmap_rd,
	srsmap_ld,
	srsmap2_rd,
	srsmap2_ld,
	cpz_srsctl_pss2css_m,
	srsctl_css2pss_w,
	srsctl_vec2css_w,
	srsctl_ess2css_w,
	eic_present,
	srsdisable,
	eiss,
	vectornumber,
	cpz,
	cpz_gm_m,
	srsctl,
	srsmap,
	srsmap2,
	hot_srsctl_pss);


	/* Inputs */
	input		gscanenable;	// Scan Enable
	input		greset;		// Power on and reset for chip
	input	 gclk;		// Clock

	input		srsctl_rd;	// Read srsctl onto cpz line
	input		srsctl_ld;	// Load srsctl register via MTC0
	input		srsmap_rd;	// Read srsmap onto cpz line
	input		srsmap_ld;	// Load srsmap register via MTC0
	input		srsmap2_rd;	// Read srsmap onto cpz line
	input		srsmap2_ld;	// Load srsmap register via MTC0

	input		cpz_srsctl_pss2css_m;	// Copy PSS to CSS
	input		srsctl_css2pss_w;	// Copy CSS to PSS
	input		srsctl_vec2css_w;	// Copy VEC to CSS
	input		srsctl_ess2css_w;	// Copy ESS to CSS

	input		eic_present;		// External Interrupt cpntroller present
        input [3:0]     srsdisable;             // Disable some shadow sets

	input [3:0]	eiss;		// Shadow set, comes with the requested interrupt
	input [5:0]	vectornumber;	// Interrupt vektor number
	input [31:0]	cpz;		// local coprocessor write bus

	input		cpz_gm_m;

	/* Outputs */
	output [31:0]	srsctl;		// SRS Control rergister
	output [31:0]	srsmap;		// SRS Mapping register
	output [31:0]	srsmap2;	// SRS Mapping register 2
	output [3:0]	hot_srsctl_pss;

// BEGIN Wire declarations made by MVP
wire [31:0] /*[31:0]*/ srsctl;
wire [3:0] /*[3:0]*/ hot_srsctl_pss;
wire [31:0] /*[31:0]*/ srsmap2;
wire [31:0] /*[31:0]*/ srsmap;
// END Wire declarations made by MVP



	assign srsctl [31:0] = 32'h0;
	assign srsmap [31:0] = 32'h0;
	assign srsmap2 [31:0] = 32'h0;
	assign hot_srsctl_pss[3:0] = 4'b0;

// Artifact code to give the testbench a cannonical reference point independent of 
// how watch is configured
  
 //VCS coverage off 
//
//

wire [31:0] next_srs_srsctl = 32'h0;
wire [31:0] next_srs_srsmap = 32'h0;

wire [31:0] next_srs_srsmap2 = 32'h0;

//
 //VCS coverage on  
  
//

endmodule	// m14k_cpz_guest_srs1


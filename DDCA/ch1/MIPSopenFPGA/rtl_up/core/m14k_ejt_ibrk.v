// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_ejt_ibrk 
//           EJTAG Simple Break I Channel
//
//      $Id: \$
//      mips_repository_id: m14k_ejt_ibrk.mv, v 1.13 
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
module m14k_ejt_ibrk(
	cpz_vz,
	gscanenable,
	ivaddr,
	regbusdatain,
	iba_sel,
	ibm_sel,
	asidsup,
	asid,
	guestid,
	ibasid_sel,
	ibc_sel,
	we,
	mpc_isamode_i,
	icc_halfworddethigh_i,
	umips_present,
	gclk,
	greset,
	i_match,
	regbusdataout,
	ibc_be,
	ibc_te);


	parameter CHANNEL=0 ;
/* Inputs */
	input           cpz_vz;

        input           gscanenable;     // Scan Enable
	input	[31:0]	ivaddr;		// Virtual addr of inst


	input	[31:0]	regbusdatain;	// Data in from register bus
	
	input		iba_sel;	// Select IBA register
	input		ibm_sel;	// Select IBM register

	input 		asidsup;        // mmu_asid supported
	input [7:0] 	asid;		// Current mmu_asid
	input [7:0]     guestid;
	input		ibasid_sel;	// Select IBASID register
	input		ibc_sel;	// Select IBC register
	input		we;		// Write enable for register bus
	input		mpc_isamode_i;
	input		icc_halfworddethigh_i;
	input		umips_present;	// umips is supported

	input		gclk;		// gclk
	input		greset;		// reset

/* Outputs */	

	output		i_match;	// I channel match

	output	[31:0]	regbusdataout;	// Data out from register bus

	output		ibc_be;		// BE bit
	output		ibc_te;		// TE bit

// BEGIN Wire declarations made by MVP
wire [2:0] /*[2:0]*/ ibasid_guestid;
wire [7:0] /*[7:0]*/ ibasid_asid;
wire guestid_match;
wire ibc_te_in;
wire ibasid_we_sel;
wire iba_we_sel;
wire ibc_te;
wire addr_match;
wire [31:0] /*[31:0]*/ regbusdataout;
wire ibc_asiduse;
wire [31:0] /*[31:0]*/ ibm;
wire [31:0] /*[31:0]*/ iba_out;
wire ibc_be_in;
wire ibc_be;
wire [31:0] /*[31:0]*/ iba;
wire ibm_we_sel;
wire [31:0] /*[31:0]*/ ibm_out;
wire [31:0] /*[31:0]*/ ibasid_out;
wire [31:0] /*[31:0]*/ ibc_out;
wire i_match;
wire ibasid_guestiduse;
wire ibc_reset_we_sel;
wire ibc_asiduse_in;
wire asid_match;
// END Wire declarations made by MVP



/* Code */

// IBA Register

	assign iba_we_sel	= we & iba_sel;

	mvp_cregister_wide #(32) _iba_31_0_(iba[31:0],gscanenable, iba_we_sel, gclk, regbusdatain);


// IBM Register

	assign ibm_we_sel	= we & ibm_sel;

	mvp_cregister_wide #(32) _ibm_31_0_(ibm[31:0],gscanenable, ibm_we_sel, gclk, regbusdatain);

// IBASID Register


	assign ibasid_we_sel	= we & ibasid_sel;
	mvp_cregister_wide #(8) _ibasid_asid_7_0_(ibasid_asid[7:0],gscanenable, ibasid_we_sel, gclk, {8{asidsup}} & regbusdatain[7:0]);

	mvp_cregister #(3) _ibasid_guestid_2_0_(ibasid_guestid[2:0],ibasid_sel & we, gclk, {3{cpz_vz}} & regbusdatain[26:24]);
	mvp_cregister #(1) _ibasid_guestiduse(ibasid_guestiduse,ibasid_sel & we | greset, gclk, greset ? 1'b0 : cpz_vz & regbusdatain[23]);

// IBC Register

	assign ibc_be_in	= greset ? 1'b0 : regbusdatain[0];
	assign ibc_te_in	= greset ? 1'b0 : regbusdatain[2];

	assign ibc_reset_we_sel= greset | (we & ibc_sel);

	mvp_cregister #(1) _ibc_be(ibc_be,ibc_reset_we_sel, gclk, ibc_be_in);
	mvp_cregister #(1) _ibc_te(ibc_te,ibc_reset_we_sel, gclk, ibc_te_in);
	assign ibc_asiduse_in	= asidsup && regbusdatain[23];
	mvp_cregister #(1) _ibc_asiduse(ibc_asiduse,ibc_reset_we_sel, gclk, ibc_asiduse_in);

// Mux out register values

	assign iba_out	[31:0]	= iba;
	assign ibm_out [31:0]	= ibm;

	assign ibasid_out[31:0]= {(cpz_vz ? {5'b0, ibasid_guestid[2:0],ibasid_guestiduse} : 9'b0) , 2'b0, 1'b0, 12'b0, ibasid_asid};
	assign ibc_out	[31:0]	= {8'b0, ibc_asiduse, 20'b0, ibc_te, 1'b0, ibc_be};

	mvp_mux1hot_4 #(32) _regbusdataout_31_0_(regbusdataout[31:0],iba_sel, iba_out, ibm_sel, ibm_out,
				ibasid_sel, ibasid_out, ibc_sel, ibc_out);




// I channel match condition:
	assign asid_match = ~ibc_asiduse | (asid == ibasid_asid);
	assign guestid_match = ~ibasid_guestiduse | (guestid[2:0] == ibasid_guestid[2:0]);

	assign addr_match = (ivaddr | ibm) == (iba | ibm);
	assign i_match = addr_match & asid_match & (guestid_match | ~cpz_vz);


// The End !

endmodule

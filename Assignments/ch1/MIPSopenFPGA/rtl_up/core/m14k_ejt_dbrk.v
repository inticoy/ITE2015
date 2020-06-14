// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_ejt_dbrk 
//            EJTAG Simple Break D Channel
//
//      $Id: \$
//      mips_repository_id: m14k_ejt_dbrk.mv, v 1.15 
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
module m14k_ejt_dbrk(
	cpz_vz,
	gscanenable,
	dvaddr,
	asid,
	asidsup,
	guestid,
	data,
	bytevalid_adr,
	bytevalid_data,
	regbusdatain,
	dba_sel,
	dbm_sel,
	dbasid_sel,
	dbc_sel,
	dbv_sel,
	we,
	mpc_bussize_m,
	gclk,
	greset,
	mpc_lsdc1_m,
	mpc_lsdc1_w,
	d_addr_m,
	d_do_vm,
	d_vmatch,
	dbc_hwat,
	regbusdataout,
	dbc_be,
	dbc_te,
	dbc_nolb,
	dbc_nosb);


	parameter CHANNEL=0 ;
/* Inputs */
	input           cpz_vz;

        input           gscanenable;     // Scan Enable
	input	[31:0]	dvaddr;		// Virtual addr of load/store

	input	[7:0]	asid;		// Current mmu_asid
	input		asidsup;		// mmu_asid supported
	input	[7:0]	guestid;		// mmu_asid supported

	input	[31:0]	data;		// Load/store data
	input	[3:0]	bytevalid_adr;	// Validity of L/S for addr comp
	input	[3:0]	bytevalid_data;	// Validity of L/S for data comp

	input	[31:0]	regbusdatain;	// Data in from register bus
	
	input		dba_sel;	// Select DBA register
	input		dbm_sel;	// Select DBM register

	input		dbasid_sel;	// Select DBASID register
	input		dbc_sel;	// Select DBC register
	input		dbv_sel;	// Select DBV register
	input		we;		// Write enable for register bus
	input	[1:0]	mpc_bussize_m;

	input		gclk;		// clock
	input		greset;		// reset
	input		mpc_lsdc1_m;
	input		mpc_lsdc1_w;

/* Outputs */	

	output		d_addr_m;	// D channel address match
	output		d_do_vm;	// Do D channel value match
	output		d_vmatch;	// D channel value match
	output		dbc_hwat;	// hwat turned on or off

	output	[31:0]	regbusdataout;	// Data out from register bus

	output		dbc_be;		// BE bit
	output		dbc_te;		// TE bit
	output		dbc_nolb;	// NoLB bit
	output		dbc_nosb;	// NoSB bit

// BEGIN Wire declarations made by MVP
wire [7:0] /*[7:0]*/ dbasid_asid;
wire [31:0] /*[31:0]*/ dba_out;
wire [31:0] /*[31:0]*/ dba;
wire dbasid_guestiduse;
wire [3:0] /*[3:0]*/ dbc_bai;
wire [2:0] /*[2:0]*/ dbasid_guestid;
wire guestid_match;
wire [31:0] /*[31:0]*/ dbasid_out;
wire dbc_be;
wire addr_match;
wire dbc_te;
wire [31:0] /*[31:0]*/ regbusdataout;
wire dbv_we_sel;
wire dbc_asiduse_in;
wire [31:0] /*[31:0]*/ dbm_out;
wire dbc_asiduse;
wire dba_we_sel;
wire [31:0] /*[31:0]*/ dbm;
wire dbc_nolb;
wire d_addr_m;
wire dbc_ivm;
wire byte_match;
wire d_do_vm;
wire dbc_nosb;
wire dbc_ivm_in;
wire [3:0] /*[3:0]*/ dbc_blm;
wire dbc_nolb_in;
wire [31:0] /*[31:0]*/ dbv_out;
wire dbc_nosb_in;
wire dbm_we_sel;
wire [3:0] /*[3:0]*/ dbc_blm_in;
wire [31:0] /*[31:0]*/ dbv;
wire dbc_be_in;
wire [31:0] /*[31:0]*/ dbc_out;
wire dbc_hwat;
wire dbc_reset_we_sel;
wire d_vmatch;
wire dbc_te_in;
wire asid_match;
wire [3:0] /*[3:0]*/ dbc_bai_in;
wire dbasid_we_sel;
// END Wire declarations made by MVP



/* Code */

	assign dbc_hwat = 1'b0;
// DBA Register

	assign dba_we_sel	= we & dba_sel;

	mvp_cregister_wide #(32) _dba_31_0_(dba[31:0],gscanenable, dba_we_sel, gclk, regbusdatain[31:0]);


// DBM Register

	assign dbm_we_sel	= we & dbm_sel;

	mvp_cregister_wide #(32) _dbm_31_0_(dbm[31:0],gscanenable, dbm_we_sel, gclk, regbusdatain[31:0]);


// DBASID Register
	assign dbasid_we_sel	= we & dbasid_sel;

	mvp_cregister_wide #(8) _dbasid_asid_7_0_(dbasid_asid[7:0],gscanenable, dbasid_we_sel, gclk, {8{asidsup}} & regbusdatain[7:0]);

	mvp_cregister #(3) _dbasid_guestid_2_0_(dbasid_guestid[2:0], we & dbasid_sel, gclk, {3{cpz_vz}} & regbusdatain[26:24]);
	mvp_cregister #(1) _dbasid_guestiduse(dbasid_guestiduse,we & dbasid_sel | greset, gclk, greset ? 1'b0 : cpz_vz & regbusdatain[23]);

// DBC Register

	assign dbc_be_in	= greset ? 1'b0 : regbusdatain[0];
	assign dbc_ivm_in	= greset ? 1'b0 : regbusdatain[1];
	assign dbc_te_in	= greset ? 1'b0 : regbusdatain[2];
	assign dbc_blm_in[3:0]	= regbusdatain[7:4];
	assign dbc_nolb_in	= regbusdatain[12];
	assign dbc_nosb_in	= regbusdatain[13];
	assign dbc_bai_in[3:0]	= regbusdatain[17:14];		

	assign dbc_reset_we_sel= greset | (we & dbc_sel);


	mvp_cregister_wide #(14) _dbc_be_dbc_ivm_dbc_te_dbc_asiduse_dbc_blm_3_0_dbc_nolb_dbc_nosb_dbc_bai_3_0({dbc_be,
	dbc_ivm,
	dbc_te,
	dbc_asiduse,
	dbc_blm[3:0],
	dbc_nolb,
	dbc_nosb,
	dbc_bai[3:0]}, gscanenable, dbc_reset_we_sel, gclk,
						{dbc_be_in,
						dbc_ivm_in,
						dbc_te_in,
						dbc_asiduse_in,
						dbc_blm_in[3:0],
						dbc_nolb_in,
						dbc_nosb_in,
						dbc_bai_in[3:0]});

	

	assign dbc_asiduse_in	= asidsup && regbusdatain[23];

// DBV Register

	assign dbv_we_sel	= we & dbv_sel;

	mvp_cregister_wide #(32) _dbv_31_0_(dbv[31:0],gscanenable, dbv_we_sel, gclk, regbusdatain[31:0]);


// Mux out register values

	assign dba_out	[31:0]	= dba;
	assign dbm_out [31:0]	= dbm;
	
	assign dbasid_out[31:0]= { (cpz_vz ? {5'b0, dbasid_guestid[2:0], dbasid_guestiduse} : 9'b0), 2'b0, 1'b0, 12'b0, dbasid_asid};
	
	assign dbc_out	[31:0]	= {8'b0, dbc_asiduse, 5'b0, dbc_bai, dbc_nosb,
			dbc_nolb, 4'b0, dbc_blm, 1'b0, dbc_te, dbc_ivm, dbc_be};
	assign dbv_out	[31:0]	= dbv;

	mvp_mux1hot_5 #(32) _regbusdataout_31_0_(regbusdataout[31:0],dba_sel, dba_out, dbm_sel, dbm_out,
				dbasid_sel, dbasid_out, dbc_sel, dbc_out,
				dbv_sel, dbv_out);



// D channel match conditions:

	assign asid_match = ( !dbc_asiduse || (asid == dbasid_asid) );
	assign guestid_match = ~dbasid_guestiduse | (guestid[2:0] == dbasid_guestid[2:0]);
	assign addr_match = ((dvaddr | dbm) == (dba | dbm));
	assign byte_match = | ( ~dbc_bai & bytevalid_adr );

	
	assign d_addr_m = addr_match & asid_match & byte_match & (guestid_match | ~cpz_vz);

	assign d_do_vm = | ( ~dbc_bai & bytevalid_adr & ~dbc_blm );

	assign d_vmatch = dbc_ivm ^ (  ( ( dbv[31:24]==data[31:24] ) | dbc_bai[3] | 
				  dbc_blm[3] | !bytevalid_data[3] ) &
		   		( ( dbv[23:16]==data[23:16] ) | dbc_bai[2] | 
				  dbc_blm[2] | !bytevalid_data[2] ) &
		   		( ( dbv[15:8]==data[15:8] ) | dbc_bai[1] || 
				  dbc_blm[1] | !bytevalid_data[1] ) &
		   		( ( dbv[7:0]==data[7:0] ) | dbc_bai[0] | 
				  dbc_blm[0] | !bytevalid_data[0] )) ;

		

// The End !

endmodule

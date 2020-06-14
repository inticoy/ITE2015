// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_tlb_jtlb1entry
//         TLB Entry Model
//         Models a single register-based tlb entry.
//
//      $Id: \$
//      mips_repository_id: m14k_tlb_jtlb1entry.mv, v 1.13 
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
module m14k_tlb_jtlb1entry(
	greset,
	gscanenable,
	asid_in,
	gbit_in,
	inv_in,
	gid_in,
	vpn_in,
	cmask_in,
	data_in,
	clk,
	datawrclken0,
	datawrclken1,
	tagwrclken,
	tag_rd_str,
	rd_str0,
	rd_str1,
	cmp_str,
	is_root,
	guest_mode,
	cp0random_val_e,
	asid_out,
	gid_out,
	gbit_out,
	inv_out,
	vpn2_out,
	cmask_out,
	data_out,
	match,
	mmu_type);

`include "m14k_mmu.vh"

        parameter M14K_TLB_JTLB_ASID	= `M14K_ASIDWIDTH;
        parameter M14K_TLB_JTLB_VPN2	= `M14K_VPN2WIDTH+`M14K_ASIDWIDTH;
        parameter M14K_TLB_JTLB_CMASK	= `M14K_CMASKWIDTH+`M14K_VPN2WIDTH+`M14K_ASIDWIDTH;
        parameter M14K_TLB_JTLB_CMASKE	= `M14K_VPN2WIDTH+`M14K_ASIDWIDTH;
        parameter M14K_TLB_JTLB_INIT	= `M14K_CMASKWIDTH+`M14K_VPN2WIDTH+`M14K_ASIDWIDTH;
        parameter M14K_TLB_JTLB_G	= `M14K_CMASKWIDTH+`M14K_VPN2WIDTH+`M14K_ASIDWIDTH+1;
        parameter M14K_TLB_JTLB_GID	= `M14K_CMASKWIDTH+`M14K_VPN2WIDTH+`M14K_ASIDWIDTH+`M14K_GIDWIDTH+1;
        parameter M14K_TLB_JTLB_ENHIINV	= `M14K_CMASKWIDTH+`M14K_VPN2WIDTH+`M14K_ASIDWIDTH+`M14K_GIDWIDTH+`M14K_ENHIINVWIDTH+1;
        parameter M14K_TLB_JTLB_MSB	= `M14K_CMASKWIDTH+`M14K_VPN2WIDTH+`M14K_ASIDWIDTH+`M14K_GIDWIDTH+`M14K_ENHIINVWIDTH+1;

	input		greset;		// Processor greset
	input		gscanenable;	// Test Mode

	input [`M14K_ASID]	asid_in;		// asid For Writes and compare
	input		gbit_in;		// gbit Bit For Writes and compare
	input		inv_in;
	input	[`M14K_GID]	gid_in;		// Guest ID For Writes and compare
	input [`M14K_VPN]	vpn_in;		// Virt Page Num For Write and Compare
	input [`M14K_CMASK]	cmask_in;	// Compressed Page mask

	input [`M14K_JTLBDATA] data_in;	// Data word for write
	input		clk;
	input		datawrclken0;	// Clock to write even data entry
	input		datawrclken1;	// Clock to write odd data entry
	input		tagwrclken;	// Clock to write tag entry
	input		tag_rd_str;	// Read Enable for Tag
	input		rd_str0;		// Read Enable for even entry
	input		rd_str1;		// Read Enable for odd entry
	input		cmp_str;		// Compare Enable
	input		is_root;
	input		guest_mode;
	input		cp0random_val_e;

	output [`M14K_ASID]	asid_out;	// asid Value read
	output [`M14K_GID]	gid_out;	// GuestID read
	output		gbit_out;		// gbit bit read
	output		inv_out;		// gbit bit read
	output [`M14K_VPN2]	vpn2_out;	// vpn2 read
	output [`M14K_CMASK]	cmask_out;	// cmask read/compare

	output [`M14K_JTLBDATA] data_out;	// Data word read

	output		match;		// match output
	output		mmu_type;

// BEGIN Wire declarations made by MVP
wire [`M14K_JTLBDATA] /*[31:5]*/ data_out;
wire [31:8] /*[31:8]*/ pah1_31_8;
wire [`M14K_PMASK] /*[17:0]*/ mask_in;
wire match;
wire [`M14K_VPN2] /*[31:11]*/ vpn2;
wire data_out_en0;
wire [`M14K_GID] /*[2:0]*/ gid;
wire [`M14K_CMASK] /*[9:0]*/ cmask;
wire inv_out;
wire gbit_out;
wire odd_sel;
wire data_out_en1;
wire [`M14K_PMASK] /*[17:0]*/ mask;
wire cmask_out_en;
wire [31:0] /*[31:0]*/ vpn_in_31_0;
wire [31:0] /*[31:0]*/ vpn2_31_0;
wire [`M14K_ASID] /*[7:0]*/ asid;
wire inv;
wire [`M14K_VPN2] /*[31:11]*/ vpn2_out;
wire [`M14K_ASID] /*[7:0]*/ asid_out;
wire mmu_type;
wire gbit;
wire [`M14K_GID] /*[2:0]*/ gid_out;
wire [31:8] /*[31:8]*/ pah0_31_8;
wire [`M14K_CMASK] /*[9:0]*/ cmask_out;
wire init;
// END Wire declarations made by MVP


	//
	// Write and Storage Circuitry
	//

/************************************************************************
#########################################################################
TLB Organization:
#########################################################################

Tag Array : Tag information for dual entries (35 bits)
	init	hardware reset bit; cleared on reset, set on tlb write
	vpn2	VPN/2 bits from va[31:13] (19 bits)
	asid	mmu_asid bits (8 bits)
	cmask	Compressed pagemask bits (6 bits)
	gbit	Global bit anded from enlo0/1 (1 bit)
	gid	Guest ID from enlo0/1 (3 bit)
	inv	Invalid bit from enhi (1 bit)

Data Array0 : PTE information for EVEN tlb entry (25 bits)
	PFN0	pfn bits [31:12] (20 bits)
	C0	Coherence attributes (3 bits)
	D0	Dirty bit (1 bit)
	V0	Valid bit (1 bit)

Data Array1 : PTE information for ODD tlb entry (25 bits)
	PFN1	pfn bits [31:12] (20 bits)
	C1	Coherence attributes (3 bits)
	D1	Dirty bit (1 bit)
	V1	Valid bit (1 bit)

************************************************************************/

	// registers concatenated into one ultra wide register
	wire [M14K_TLB_JTLB_MSB:0] jtlb1entry_pipe_in;
	wire [M14K_TLB_JTLB_MSB:0] jtlb1entry_pipe_out;

// 
function [`M14K_PMASKHI : `M14K_PMASKLO] expand;
   input [`M14K_CMASKHI : `M14K_CMASKLO] c;
   expand = {`M14K_CM2PM};
endfunction

function [`M14K_CMASKHI : `M14K_CMASKLO] comprs;
   input [`M14K_PMASKHI : `M14K_PMASKLO] p;
   comprs = {`M14K_PM2CM};
endfunction
// 
	
	// MMU type: 1->BAT, 0->TLB  Static output
	assign mmu_type = 1'b0;	// Signal that we are a TLB

	// 
	mvp_cregister_wide_tlb #(M14K_TLB_JTLB_MSB+1) _jtlb1entry_pipe_out(jtlb1entry_pipe_out, gscanenable,
									  tagwrclken, clk, jtlb1entry_pipe_in);
	// 

	// init bit
	assign jtlb1entry_pipe_in[M14K_TLB_JTLB_INIT] = !greset;
	assign init = jtlb1entry_pipe_out[M14K_TLB_JTLB_INIT];


	// register-based tlb with no gated clocks

	// Tag Fields
	assign jtlb1entry_pipe_in[M14K_TLB_JTLB_G] = gbit_in | is_root & (|gid_in);
	assign gbit = jtlb1entry_pipe_out[M14K_TLB_JTLB_G];

	assign jtlb1entry_pipe_in[M14K_TLB_JTLB_GID : M14K_TLB_JTLB_G+1] = gid_in;
	assign gid[`M14K_GID] = jtlb1entry_pipe_out[M14K_TLB_JTLB_GID : M14K_TLB_JTLB_G+1];

	assign jtlb1entry_pipe_in[M14K_TLB_JTLB_ENHIINV] = inv_in & ~cp0random_val_e;
	assign inv = jtlb1entry_pipe_out[M14K_TLB_JTLB_ENHIINV];

	assign jtlb1entry_pipe_in[M14K_TLB_JTLB_ASID-1:0] = asid_in;
	assign asid [`M14K_ASID] = jtlb1entry_pipe_out[M14K_TLB_JTLB_ASID-1:0];

	assign jtlb1entry_pipe_in[M14K_TLB_JTLB_VPN2-1:`M14K_ASIDWIDTH] = vpn_in[`M14K_VPN2];
	assign vpn2 [`M14K_VPN2] = jtlb1entry_pipe_out[M14K_TLB_JTLB_VPN2-1:`M14K_ASIDWIDTH];

	assign jtlb1entry_pipe_in[M14K_TLB_JTLB_CMASK-1:M14K_TLB_JTLB_CMASKE] = cmask_in;
	assign cmask [`M14K_CMASK] = jtlb1entry_pipe_out[M14K_TLB_JTLB_CMASK-1:M14K_TLB_JTLB_CMASKE];

	// Data Fields
	wire [`M14K_JTLBDATA] data0;
	wire [`M14K_JTLBDATA] data1;
	// 
	mvp_cregister_wide_tlb #(`M14K_JTLBDATAWIDTH) _data0(data0, gscanenable, datawrclken0, clk, data_in);
	mvp_cregister_wide_tlb #(`M14K_JTLBDATAWIDTH) _data1(data1, gscanenable, datawrclken1, clk, data_in);
	// 

	//
	// match Circuitry
	//
	assign mask [`M14K_PMASK] = expand(cmask);
	assign mask_in [`M14K_PMASK] = expand(cmask_in);
	assign match = cmp_str & init & (gbit | gbit_in | (asid == asid_in)) & ~inv
		& (gid == gid_in) & (&( mask | mask_in | ~(vpn2 ^ vpn_in[`M14K_VPN2])));
	assign odd_sel = |({mask, 1'b1} & ~{1'b0, mask} & vpn_in);

	//
	// Read Circuitry
	//
	assign cmask_out_en = tag_rd_str && !inv && !(guest_mode && (gid != gid_in)) || match;
	assign data_out_en0 = rd_str0 && !inv && !(guest_mode && (gid != gid_in)) || match && !odd_sel;
	assign data_out_en1 = rd_str1 && !inv && !(guest_mode && (gid != gid_in)) || match && odd_sel;

        parameter AW = `M14K_ASIDWIDTH;
        parameter GW = `M14K_GIDWIDTH;
        parameter DW = `M14K_JTLBDATAWIDTH;
        parameter VW = `M14K_VPN2WIDTH;
        parameter CM = `M14K_CMASKWIDTH;
        assign asid_out [`M14K_ASID]     = {AW{rd_str0 & ~inv & ~(guest_mode & (gid != gid_in))}} & asid;
        assign gid_out [`M14K_GID]     = {GW{rd_str0 & ~inv & ~(guest_mode & (gid != gid_in))}} & gid;
	assign inv_out = rd_str0 & (inv | guest_mode & (gid != gid_in));
        assign gbit_out                = (data_out_en0 | data_out_en1) & gbit;
        assign vpn2_out [`M14K_VPN2]     = {VW{tag_rd_str & ~inv & ~(guest_mode && (gid != gid_in))}} & vpn2;
        assign cmask_out [`M14K_CMASK]   = {CM{cmask_out_en}} & cmask;
        assign data_out [`M14K_JTLBDATA] = {DW{data_out_en0}} & data0
                            | {DW{data_out_en1}} & data1;

  
 //VCS coverage off 
// 
   
//VCS coverage off
   
   //verilint 550 off	Mux is inferred: case (1'b1)
   //verilint 226 off 	Case-select expression is constant
   //verilint 225 off 	Case expression is not constant
   //verilint 180 off 	Zero extension of extra bits
   //verilint 528 off 	Variable set but not used
   // Generate a text description of state and next state for debugging
	assign vpn2_31_0[31:0] = {vpn2, 11'b0};
	assign vpn_in_31_0[31:0] = {vpn_in, 10'b0};
	assign pah0_31_8[31:8] = data0[31:8];
	assign pah1_31_8[31:8] = data1[31:8];
   //verilint 550 on	Mux is inferred: case (1'b1)
   //verilint 226 on 	Case-select expression is constant
   //verilint 225 on 	Case expression is not constant
   //verilint 180 on 	Zero extension of extra bits
   //verilint 528 on 	Variable set but not used
    // else MIPS_ACCELERATION_BUILD
//VCS coverage on
    // MIPS_SIMULATION
  //VCS coverage on  
  
// 

endmodule


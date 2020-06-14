// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// 	Description: m14k_tlb_utlb
//          Micro tlb. Register based
//
//	$Id: \$
//	mips_repository_id: m14k_tlb_utlb.mv, v 1.5 
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
module m14k_tlb_utlb(
	gclk,
	greset,
	gscanenable,
	lookup,
	va,
	mmu_asid,
	jtlb_wr,
	r_jtlb_wr,
	jtlb_wr_idx,
	update_utlb,
	jtlb_idx,
	rjtlb_idx,
	jtlb_lo,
	r_jtlb_lo,
	jtlb_grain,
	cpz_vz,
	pre_pah,
	jtlb_pah,
	att_wr_data,
	utlb_bypass,
	cpz_guestid,
	utlb_pah,
	utlb_patt,
	utlb_miss);
 parameter AW = 9; // Width of Attribute field
`include "m14k_mmu.vh"

	// synopsys template
	/* Inputs */
	input 		      gclk;		// Clock
	input 		      greset;		// greset
	input 		      gscanenable;	// gscanenable
	input 		      lookup;		// Control signal that the uTLB is used
	input [`M14K_VPNRANGE] va;		// Virtual address for translation
	input [`M14K_ASID]     mmu_asid;		// Address Space ID
	input 		      jtlb_wr;	// An Entry in the JTLB is written (flush signal)
	input 		      r_jtlb_wr;	// An Entry in the JTLB is written (flush signal)
	input [4:0] 	      jtlb_wr_idx;	// index of the Entry written in the JTLB
	input 		      update_utlb;	// uTLB Write strobe signal.
	input [4:0] 	      jtlb_idx;	// index in JTLB of the jtlb_lo entry.
	input [4:0] 	      rjtlb_idx;	// index in JTLB of the jtlb_lo entry.
	input [`M14K_JTLBL]    jtlb_lo;		// JTLB Lo output for uTLB write
	input [`M14K_JTLBL]    r_jtlb_lo;		// JTLB Lo output for uTLB write
	input 		      jtlb_grain;      // pagesize = 4KB+/1KB (1/0)
	input 		      cpz_vz;

	input [`M14K_PAH]      pre_pah;		// Fixed translation or Previous address
	input [`M14K_PAH]      jtlb_pah;		// Physical Address from JTLB
	input [AW-1:0] 	      att_wr_data;         // Attributes to write
	input 		      utlb_bypass;	// Bypass uTLB translate. = use pre_pah
   	input [`M14K_GID] 		cpz_guestid;
	
	/* Outputs */
	output [`M14K_PAH]     utlb_pah;            // Translated Physical address high part
	output [AW-1:0]       utlb_patt;           // Attributes from matching entry
	output 		      utlb_miss;	// uTLB Miss indication

// BEGIN Wire declarations made by MVP
wire [4:0] /*[4:0]*/ r_idx_wr_data;
wire [`M14K_PAH] /*[31:10]*/ pah_wr_data;
wire [`M14K_ASID] /*[7:0]*/ asid_wr_data;
wire [3:0] /*[3:0]*/ load_utlb;
wire [1:0] /*[1:0]*/ lru3;
wire [`M14K_PAH] /*[31:10]*/ utlb_pah;
wire [(AW-1):0] /*[8:0]*/ utlb_patt;
wire [4:0] /*[4:0]*/ idx_wr_data;
wire jtlb_val;
wire [1:0] /*[1:0]*/ lru3_cnxt;
wire [1:0] /*[1:0]*/ lru1_cnxt;
wire utlb_miss;
wire [1:0] /*[1:0]*/ lru1;
wire gbit_wr_data;
wire [`M14K_VPNRANGE] /*[31:10]*/ grain_mask;
wire [`M14K_GID] /*[2:0]*/ gid_wr_data;
wire [1:0] /*[1:0]*/ mru;
wire [1:0] /*[1:0]*/ lru2_cnxt;
wire [31:0] /*[31:0]*/ grain_mask32;
wire [1:0] /*[1:0]*/ nxt_entry;
wire [`M14K_VPNRANGE] /*[31:10]*/ vpn_wr_data;
wire [1:0] /*[1:0]*/ lru;
wire [1:0] /*[1:0]*/ lru2;
wire lru_update;
// END Wire declarations made by MVP

	
	// End of I/O
	parameter PAHW = `M14K_PAHWIDTH;

	/*
	 * Assumptions:
	 * 1: update_utlb is not set unless utlb_miss is set.
	 * 2: When update_utlb is set, va and mmu_asid are valid and translate into
	 *    the jtlb_idx and jtlb_lo inputs.
	 * 2: mmu_asid is valid one clock earlier than va
	 * 3: If va is invalid. All outputs will be undefined.
	 * 4: When jtlb_wr is set any uTLB entry with the index jtlb_wr_idx is cleared.
	 * 5: lookup is ONLY set when the uTLB is accesed for translation
	 */
	
	
	wire 		      utlb0_val;
	wire 		      utlb1_val;
	wire 		      utlb2_val;
	wire 		      utlb3_val;
	wire 		      utlb0_match;
	wire 		      utlb1_match;
	wire 		      utlb2_match;
	wire 		      utlb3_match;
	wire [AW-1:0] 	      utlb0_att;
	wire [AW-1:0] 	      utlb1_att;
	wire [AW-1:0] 	      utlb2_att;
	wire [`M14K_PAH]       utlb0_pah;
	wire [`M14K_PAH]       utlb1_pah;
	wire [`M14K_PAH]       utlb2_pah;
	
	wire [AW-1:0] 	      utlb3_att;
	wire [`M14K_PAH]       utlb3_pah;


	// 2-to-4 decoder
	//
	function [3:0] dec2to4;
		input [1:0]	enc;
		
		dec2to4 = 4'b0001 << enc;
		
	endfunction
	//
   

	// jtlb_val: jtlb_lo is valid and the uTLB must be updated
	assign jtlb_val = (cpz_vz ? r_jtlb_lo[`M14K_VALIDBIT] : jtlb_lo[`M14K_VALIDBIT]) && update_utlb;
	
	// mru: Most resently used entry. Only valid when lookup is set and utlb_miss is low
	assign mru [1:0] = {(utlb2_match || utlb3_match), (utlb1_match || utlb3_match)};
	
	// lru_update: Update the lru registers
	assign lru_update = greset || (lookup && !utlb_miss && !(mru == lru3));
   
	// lru1-3: Next to Least recently used entries
	
	assign lru1_cnxt [1:0] = (greset ? 2'd3 : ((lru2 == mru) ? lru1 : lru2));
	mvp_cregister #(2) _lru1_1_0_(lru1[1:0],lru_update, gclk, lru1_cnxt);
	
   
	assign lru2_cnxt [1:0] = (greset ? 2'd2 : lru3);
	mvp_cregister #(2) _lru2_1_0_(lru2[1:0],lru_update, gclk, lru2_cnxt);
	
	assign lru3_cnxt [1:0] = (greset ? 2'd1 : mru);
	mvp_cregister #(2) _lru3_1_0_(lru3[1:0],lru_update, gclk, lru3_cnxt);

	// lru: Least recently used entry
	assign lru [1:0] = lru1 ^ lru2 ^ lru3;
   
	// nxt_entry:  Next uTLB entry to update in case of uTLB miss

	assign nxt_entry [1:0] = !utlb0_val ? 2'd0 :	// If any unused entries exists
			  !utlb1_val ? 2'd1 :	// use them first.
			  !utlb2_val ? 2'd2 :
			  !utlb3_val ? 2'd3 :
			  lru;		// Otherwise select lru

	
	assign asid_wr_data [`M14K_ASID] = mmu_asid;

	assign gid_wr_data [`M14K_GID] = cpz_guestid;

	// Create grain mask to mask out low bits if 4K page
	assign grain_mask32[31:0] = {32{jtlb_grain}};
	// grain_mask[`M14K_VPNRANGE] = grain_mask32[`M14K_PFNLO-1:`M14K_VPNLO];  // pads with zeros on left 
	assign grain_mask[`M14K_VPNRANGE] = {20'b0, grain_mask32[`M14K_PFNLO-1:`M14K_VPNLO]};  // pads with zeros on left 

	assign vpn_wr_data  [`M14K_VPNRANGE]  = va & ~grain_mask;
	
	assign gbit_wr_data              = jtlb_lo[`M14K_GLOBALBIT];
	
	assign pah_wr_data [`M14K_PAH]   = jtlb_pah;
   
	// idx_wr_data: Idx write data
	assign idx_wr_data [4:0] = jtlb_idx;
	assign r_idx_wr_data [4:0] = rjtlb_idx;
   
	// load_utlb: Load enable for the 4 entries
	assign load_utlb [3:0] = ({4{jtlb_val}} & dec2to4(nxt_entry));
	


	// Entry 0
	`M14K_UTLBENTRY_MODULE #(AW) utlbentry0 (
					     /* Inputs */
					     .gclk ( gclk),
					     .greset (greset),
				 	     .gscanenable (gscanenable),
					     .va (va),
					     .mmu_asid (mmu_asid),
					     .cpz_guestid (cpz_guestid),
					     .load_utlb (load_utlb[0]),
					     .att_wr_data (att_wr_data),
					     .pah_wr_data (pah_wr_data),
					     .vpn_wr_data (vpn_wr_data),
					     .asid_wr_data (asid_wr_data),
					     .gid_wr_data (gid_wr_data),
					     .gbit_wr_data (gbit_wr_data),
					     .idx_wr_data (idx_wr_data),
					     .r_idx_wr_data (r_idx_wr_data),
					     .jtlb_wr (jtlb_wr),
					     .r_jtlb_wr (r_jtlb_wr),
					     .jtlb_wr_idx (jtlb_wr_idx),
					     .jtlb_grain (jtlb_grain),
					     /* Outputs */
					     .utlb_att (utlb0_att),
					     .utlb_pah (utlb0_pah),
					     .match (utlb0_match),
					     .utlb_val (utlb0_val)
					    );


	// Entry 1
	`M14K_UTLBENTRY_MODULE #(AW) utlbentry1 (
					     /* Inputs */
					     .gclk ( gclk),
					     .greset (greset),
				 	     .gscanenable (gscanenable),
					     .va (va),
					     .mmu_asid (mmu_asid),
					     .cpz_guestid (cpz_guestid),
					     .load_utlb (load_utlb[1]),
					     .att_wr_data (att_wr_data),
					     .pah_wr_data (pah_wr_data),
					     .vpn_wr_data (vpn_wr_data),
					     .asid_wr_data (asid_wr_data),
					     .gid_wr_data (gid_wr_data),
					     .gbit_wr_data (gbit_wr_data),
					     .idx_wr_data (idx_wr_data),
					     .r_idx_wr_data (r_idx_wr_data),
					     .jtlb_wr (jtlb_wr),
					     .r_jtlb_wr (r_jtlb_wr),
					     .jtlb_wr_idx (jtlb_wr_idx),
					     .jtlb_grain (jtlb_grain),
					     /* Outputs */
					     .utlb_att (utlb1_att),
					     .utlb_pah (utlb1_pah),
					     .match (utlb1_match),
					     .utlb_val (utlb1_val)
					    );

	// Entry 2
	`M14K_UTLBENTRY_MODULE #(AW) utlbentry2 (
					      /* Inputs */
					     .gclk ( gclk),
					     .greset (greset),
				 	     .gscanenable (gscanenable),
					     .va (va),
					     .mmu_asid (mmu_asid),
					     .cpz_guestid (cpz_guestid),
					     .load_utlb (load_utlb[2]),
					     .att_wr_data (att_wr_data),
					     .pah_wr_data (pah_wr_data),
					     .vpn_wr_data (vpn_wr_data),
					     .asid_wr_data (asid_wr_data),
					     .gid_wr_data (gid_wr_data),
					     .gbit_wr_data (gbit_wr_data),
					     .idx_wr_data (idx_wr_data),
					     .r_idx_wr_data (r_idx_wr_data),
					     .jtlb_wr (jtlb_wr),
					     .r_jtlb_wr (r_jtlb_wr),
					     .jtlb_wr_idx (jtlb_wr_idx),
					     .jtlb_grain (jtlb_grain),
					     /* Outputs */
					     .utlb_att (utlb2_att),
					     .utlb_pah (utlb2_pah),
					     .match (utlb2_match),
					     .utlb_val (utlb2_val)
					    );


	// Entry 3
	`M14K_UTLBENTRY_MODULE #(AW) utlbentry3 (
					     /* Inputs */
					     .gclk ( gclk),
					     .greset (greset),
				 	     .gscanenable (gscanenable),
					     .va (va),
					     .mmu_asid (mmu_asid),
					     .cpz_guestid (cpz_guestid),
					     .load_utlb (load_utlb[3]),
					     .att_wr_data (att_wr_data),
					     .pah_wr_data (pah_wr_data),
					     .vpn_wr_data (vpn_wr_data),
					     .asid_wr_data (asid_wr_data),
					     .gid_wr_data (gid_wr_data),
					     .gbit_wr_data (gbit_wr_data),
					     .idx_wr_data (idx_wr_data),
					     .r_idx_wr_data (r_idx_wr_data),
					     .jtlb_wr (jtlb_wr),
					     .r_jtlb_wr (r_jtlb_wr),
					     .jtlb_wr_idx (jtlb_wr_idx),
					     .jtlb_grain (jtlb_grain),
					     /* Outputs */
					     .utlb_att (utlb3_att),
					     .utlb_pah (utlb3_pah),
					     .match (utlb3_match),
					     .utlb_val (utlb3_val)
					    );


   
	// utlb_miss

	assign utlb_miss = !(utlb0_match || utlb1_match || utlb2_match || utlb3_match);


	
	// PAH: Muxed Physical address output of uTLB

	assign utlb_pah [`M14K_PAH] = {PAHW{utlb_bypass}} & pre_pah |
			      {PAHW{~utlb_bypass & utlb0_match}} & utlb0_pah | 
			      {PAHW{~utlb_bypass & utlb1_match}} & utlb1_pah | 
			      {PAHW{~utlb_bypass & utlb2_match}} & utlb2_pah | 
			      {PAHW{~utlb_bypass & utlb3_match}} & utlb3_pah;


	// pa_cca: Muxed Attribute bits
	// utlb_bypass is handled externally

	assign utlb_patt [(AW-1):0] = {AW{utlb0_match}} & utlb0_att | 
			       {AW{utlb1_match}} & utlb1_att | 
			       {AW{utlb2_match}} & utlb2_att | 
			       {AW{utlb3_match}} & utlb3_att;


endmodule	// m14k_tlb_utlb

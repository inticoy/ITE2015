// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// 	m14k_tlb_dtlb: Data Micro tlb.
//
//	$Id: \$
//	mips_repository_id: m14k_tlb_dtlb.mv, v 1.5 
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
module m14k_tlb_dtlb(
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
	cpz_guestid,
	pre_pah,
	jtlb_pah,
	utlb_bypass,
	store,
	cpz_gm_m,
	cpz_vz,
	dmap,
	mmu_dpah,
	pa_cca,
	dtlb_ri,
	dtlb_xi,
	rdtlb_ri,
	rdtlb_xi,
	dtlb_miss);

`include "m14k_mmu.vh"
   parameter AW = `M14K_CCAWIDTH + 6;

   /* Inputs */
   input 		gclk;		// Clock
   input 		greset;		// greset
   input 		gscanenable;	// gscanenable
   input 		lookup;		// Control signal that the uTLB is used
   input [`M14K_VPNRANGE]	va;		// Virtual address for translation
   input [`M14K_ASID] 	mmu_asid;		// Address Space ID
   input 		jtlb_wr;	// An Entry in the JTLB is written (flush signal)
   input 		r_jtlb_wr;	// An Entry in the JTLB is written (flush signal)
   input [4:0]		jtlb_wr_idx;	// index of the Entry written in the JTLB
   input 		update_utlb;	// uTLB Write strobe signal.
   input [4:0] 		jtlb_idx;	// index in JTLB of the jtlb_lo entry.
   input [4:0] 		rjtlb_idx;	// index in JTLB of the jtlb_lo entry.
   input [`M14K_JTLBL] 	jtlb_lo;		// JTLB Lo output for uTLB write
   input [`M14K_JTLBL] 	r_jtlb_lo;		// JTLB Lo output for uTLB write
   input 		jtlb_grain;	// Smallest pagesize = 1KB/4KB (0/1) 
   input [`M14K_GID] 	cpz_guestid;

   input [`M14K_PAH] 	pre_pah;		// Fixed translation or Previous address
   input [`M14K_PAH] 	jtlb_pah;		// Translated Physical address from JTLB
   input 		utlb_bypass;	// Bypass uTLB translate. = use pre_pah
   input 		store;          // Is this translation for a store?
   input 		cpz_gm_m;
   input 		cpz_vz;
   input 		dmap;

   /* Outputs */
   output [`M14K_PAH] 	mmu_dpah;		// Translated Physical address
   output [`M14K_CCA]	pa_cca;		// cca bit for PAH

   output 		dtlb_ri;		// Read inhibit from dTLB
   output 		dtlb_xi;		// Execute inhibit from dTLB
   output 		rdtlb_ri;		// Read inhibit from dTLB
   output 		rdtlb_xi;		// Execute inhibit from dTLB
   output 		dtlb_miss;	// uTLB Miss indication

// BEGIN Wire declarations made by MVP
wire rdbit;
wire [AW-1:0] /*[8:0]*/ att_wr_data;
wire [`M14K_CCA] /*[2:0]*/ pa_cca;
wire dtlb_miss;
wire dtlb_ri;
wire dtlb_xi;
wire rdtlb_xi;
wire rdtlb_ri;
// END Wire declarations made by MVP


   // End of init/O

   wire dbit;
   wire miss;

   // Need to miss if this will generate a mmu_tlbmod exception
   assign dtlb_miss = store & ((~cpz_vz | cpz_gm_m & dmap) & ~dbit | cpz_vz & ~rdbit) | miss;

   wire [AW-1:0] Att;
   assign att_wr_data [AW-1:0] = {r_jtlb_lo[`M14K_DIRTYBIT], r_jtlb_lo[`M14K_RINHBIT], r_jtlb_lo[`M14K_XINHBIT], 
		(cpz_gm_m | ~cpz_vz) ? jtlb_lo[`M14K_COHERENCYRANGE] : r_jtlb_lo[`M14K_COHERENCYRANGE], 
		jtlb_lo[`M14K_DIRTYBIT], jtlb_lo[`M14K_RINHBIT], 
		jtlb_lo[`M14K_XINHBIT]};
   assign {rdbit, rdtlb_ri, rdtlb_xi, pa_cca[`M14K_CCA], dbit, dtlb_ri, dtlb_xi} = Att;

   m14k_tlb_utlb #(AW) utlb (
   	/* Inputs */
   	.gclk		( gclk),
   	.greset		( greset),
   	.gscanenable	( gscanenable),
   	.lookup		( lookup),
   	.va		( va),	
   	.mmu_asid	( mmu_asid),
   	.cpz_guestid	( cpz_guestid),
   	.jtlb_wr	( jtlb_wr),
   	.r_jtlb_wr	( r_jtlb_wr),
   	.jtlb_wr_idx	( jtlb_wr_idx),
   	.update_utlb	( update_utlb),
   	.jtlb_idx	( jtlb_idx),
   	.rjtlb_idx	( rjtlb_idx),
   	.jtlb_lo	( jtlb_lo),
   	.r_jtlb_lo	( r_jtlb_lo),
   	.jtlb_pah	( jtlb_pah),
	.jtlb_grain	( jtlb_grain),
   	.att_wr_data	( att_wr_data),
   	.cpz_vz		( cpz_vz),

   	.pre_pah	( pre_pah),
   	.utlb_bypass	( utlb_bypass),

   	/* Outputs */
   	.utlb_pah	( mmu_dpah),
   	.utlb_patt	( Att),
   	.utlb_miss	( miss)
   );



endmodule	// m14k_tlb_dtlb

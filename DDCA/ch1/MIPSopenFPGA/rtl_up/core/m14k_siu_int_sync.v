// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//      Description: m14k_siu_int_sync 
//           Double flop synchronizers for Interrupt pins
//      
//      $Id: \$
//      mips_repository_id: m14k_siu_int_sync.mv, v 1.10 
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
module m14k_siu_int_sync(
	gfclk,
	SI_Int,
	SI_EISS,
	SI_EICVector,
	SI_Offset,
	SI_GInt,
	SI_GEICVector,
	SI_GOffset,
	SI_GEISS,
	SI_EICGID,
	siu_int,
	siu_eiss,
	siu_eicvector,
	siu_offset,
	siu_g_int,
	siu_g_eicvector,
	siu_g_offset,
	siu_eicgid,
	siu_g_eiss);


//verilint 423 off        // A port with a range is re-declared with a different range

   input gfclk;			// Free running clock
   input [7:0] SI_Int;          // Ext. Interrupt pins

   input [3:0] SI_EISS;		// Shadow set, comes with the requested interrupt
   input [5:0] SI_EICVector;	// Vector number for EIC interrupt request

   input [17:1] SI_Offset;	// Vector offset for EIC interrupt request
	
   input [7:0] SI_GInt;          // Ext. Interrupt pins
   input [5:0]	SI_GEICVector;	// Vector number for EIC interrupt
   input [17:1] SI_GOffset;	// Vector offset for EIC interrupt
   input [3:0]	SI_GEISS;	// Shadow set, comes with the requested interrupt
   input [7:0] SI_EICGID; 
   
   output [7:0] siu_int;        // registered interrupt pins

   output [3:0]	siu_eiss;	// Shadow set, comes with the requested interrupt
   output [5:0] siu_eicvector;	// Vector number for EIC interrupt request

   output [17:1] siu_offset;	// Vector offset for EIC interrupt request

   output [7:0] siu_g_int;            // registered interrupt pins

   output [5:0] siu_g_eicvector;      // registered vector pins

   output [17:1] siu_g_offset;		// registered offset pins

   output [2:0] siu_eicgid;

   output [3:0]	siu_g_eiss;	// Shadow set, comes with the requested interrupt

// BEGIN Wire declarations made by MVP
wire [5:0] /*[5:0]*/ siu_g_eicvector;
wire [3:0] /*[3:0]*/ siu_g_eiss;
wire [7:0] /*[7:0]*/ siu_eicgid_pre;
wire [5:0] /*[5:0]*/ siu_g_eicvector_pre;
wire [7:0] /*[7:0]*/ siu_g_int;
wire [17:1] /*[17:1]*/ siu_g_offset;
wire [7:0] /*[7:0]*/ siu_int_pre;
wire [17:1] /*[17:1]*/ siu_g_offset_pre;
wire [3:0] /*[3:0]*/ siu_eiss;
wire [17:1] /*[17:1]*/ siu_offset;
wire [17:1] /*[17:1]*/ siu_offset_pre;
wire [7:0] /*[7:0]*/ siu_int;
wire [`M14K_GID] /*[2:0]*/ siu_eicgid;
wire [7:0] /*[7:0]*/ siu_g_int_pre;
wire [5:0] /*[5:0]*/ siu_eicvector;
wire [3:0] /*[3:0]*/ siu_g_eiss_pre;
wire [5:0] /*[5:0]*/ siu_eicvector_pre;
wire [3:0] /*[3:0]*/ siu_eiss_pre;
// END Wire declarations made by MVP


   mvp_register #(8) _siu_int_pre_7_0_(siu_int_pre[7:0], gfclk, SI_Int);
   mvp_register #(8) _siu_int_7_0_(siu_int[7:0], gfclk, siu_int_pre);

   mvp_register #(4) _siu_eiss_pre_3_0_(siu_eiss_pre[3:0], gfclk, SI_EISS);
   mvp_register #(4) _siu_eiss_3_0_(siu_eiss[3:0], gfclk, siu_eiss_pre);        

   mvp_register #(6) _siu_eicvector_pre_5_0_(siu_eicvector_pre[5:0], gfclk, SI_EICVector);
   mvp_register #(6) _siu_eicvector_5_0_(siu_eicvector[5:0], gfclk, siu_eicvector_pre);

   mvp_register #(17) _siu_offset_pre_17_1_(siu_offset_pre[17:1], gfclk, SI_Offset);
   mvp_register #(17) _siu_offset_17_1_(siu_offset[17:1], gfclk, siu_offset_pre);

   mvp_register #(8) _siu_g_int_pre_7_0_(siu_g_int_pre[7:0], gfclk, SI_GInt);
   mvp_register #(8) _siu_g_int_7_0_(siu_g_int[7:0], gfclk, siu_g_int_pre);

   mvp_register #(4) _siu_g_eiss_pre_3_0_(siu_g_eiss_pre[3:0], gfclk, SI_GEISS);
   mvp_register #(4) _siu_g_eiss_3_0_(siu_g_eiss[3:0], gfclk, siu_g_eiss_pre);        

   mvp_register #(6) _siu_g_eicvector_pre_5_0_(siu_g_eicvector_pre[5:0], gfclk, SI_GEICVector);
   mvp_register #(6) _siu_g_eicvector_5_0_(siu_g_eicvector[5:0], gfclk, siu_g_eicvector_pre);

   mvp_register #(17) _siu_g_offset_pre_17_1_(siu_g_offset_pre[17:1], gfclk, SI_GOffset);
   mvp_register #(17) _siu_g_offset_17_1_(siu_g_offset[17:1], gfclk, siu_g_offset_pre);

   mvp_register #(8) _siu_eicgid_pre_7_0_(siu_eicgid_pre[7:0], gfclk, SI_EICGID);
   mvp_register #(3) _siu_eicgid_2_0_(siu_eicgid[`M14K_GID], gfclk, siu_eicgid_pre[`M14K_GID]);

//verilint 423 on        // A port with a range is re-declared with a different range

endmodule       // m14k_siu_int_sync


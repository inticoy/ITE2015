// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE

//
// Description:    m14k_edp_clz_16b
//      Counts leading zeros for a 16bit input
//
// $Id: \$
// mips_repository_id: m14k_edp_clz_16b.mv, v 1.1 
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

// Not all bits of lower level module outputs are used
// will be optimized away in synthesis
//verilint 498 off  // Unused input

`include "m14k_const.vh"
  module m14k_edp_clz_16b(
	count,
	allzeron,
	a);
 /*AUTOARG()*/

   output [3:0] count;
   output 	allzeron;
   
   input [15:0]  a;

// BEGIN Wire declarations made by MVP
// END Wire declarations made by MVP


   wire [3:0] 	 count;
   wire [3:0] 	 lscount0a;
   wire [3:0] 	 lscount1a;
   wire [3:0] 	 lscount2a;
   wire [3:0] 	 lscount3a;
   wire [3:0] 	 partial_cl;
   wire 	 allzeron;

   // Instantiate 4bit clz's with lscount unknown - ignore lower 2 bits of their count.
   // For synthesis, this module should be flattened, but not restructured.
   m14k_edp_clz_4b lscount0i(
		      // Outputs
		      .count		(lscount0a[3:0]),
		      .allzeron		(partial_cl[0]),
		      // Inputs
		      .lscount0		(2'bxx),
		      .lscount1		(2'bxx),
		      .lscount2		(2'bxx),
		      .lscount3		(2'bxx),
		      .a		(a[3:0]));
   
   m14k_edp_clz_4b lscount1i(
		      // Outputs
		      .count		(lscount1a[3:0]),
		      .allzeron		(partial_cl[1]),
		      // Inputs
		      .lscount0		(2'bxx),
		      .lscount1		(2'bxx),
		      .lscount2		(2'bxx),
		      .lscount3		(2'bxx),
		      .a		(a[7:4]));
   
   m14k_edp_clz_4b lscount2i(
		      // Outputs
		      .count		(lscount2a[3:0]),
		      .allzeron		(partial_cl[2]),
		      // Inputs
		      .lscount0		(2'bxx),
		      .lscount1		(2'bxx),
		      .lscount2		(2'bxx),
		      .lscount3		(2'bxx),
		      .a		(a[11:8]));
   
   m14k_edp_clz_4b lscount3i(
		      // Outputs
		      .count		(lscount3a[3:0]),
		      .allzeron		(partial_cl[3]),
		      // Inputs
		      .lscount0		(2'bxx),
		      .lscount1		(2'bxx),
		      .lscount2		(2'bxx),
		      .lscount3		(2'bxx),
		      .a		(a[15:12]));

   // Instantiate one more clz 4bit to combine the 1st level results.
   // Note that we are not using bits1:0 of lscount.
   m14k_edp_clz_4b mscounti(
		      // Outputs
		      .count		(count[3:0]),
		      .allzeron		(allzeron),
		      // Inputs
		      .lscount0		(lscount0a[3:2]),
		      .lscount1		(lscount1a[3:2]),
		      .lscount2		(lscount2a[3:2]),
		      .lscount3		(lscount3a[3:2]),
		      .a		(partial_cl[3:0]));
   
//verilint 498 on  // Unused input
endmodule
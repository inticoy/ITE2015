// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
// ###########################################################################
//
// cop2: Cop2 emulator
//
// $Id: \$
// mips_repository_id: m14k_cop2_stub.mv, v 1.1 
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
// ###########################################################################
`include "m14k_const.vh"
module m14k_cop2_stub(
	CP2_abusy_0,
	CP2_tbusy_0,
	CP2_fbusy_0,
	CP2_cccs_0,
	CP2_ccc_0,
	CP2_excs_0,
	CP2_exc_0,
	CP2_exccode_0,
	CP2_fds_0,
	CP2_forder_0,
	CP2_fdata_0,
	CP2_tordlim_0,
	CP2_present,
	CP2_idle,
	CP2_as_0,
	CP2_ts_0,
	CP2_fs_0,
	CP2_irenable_0,
	CP2_ir_0,
	CP2_endian_0,
	CP2_inst32_0,
	CP2_nulls_0,
	CP2_null_0,
	CP2_kills_0,
	CP2_kill_0,
	CP2_tds_0,
	CP2_tdata_0,
	CP2_torder_0,
	CP2_fordlim_0,
	CP2_reset,
	CP2_kd_mode_0,
	SI_Reset,
	SI_ClkIn,
	CP2_tocp2,
	CP2_fromcp2);


   // Cop2 I/F output signals
   output                   CP2_abusy_0;        // COP2 Arithmetric instruction busy
   output                   CP2_tbusy_0;        // COP2 To data busy
   output                   CP2_fbusy_0;        // COP2 From data busy
   output                   CP2_cccs_0;         // COP2 Condition Code Check Strobe
   output                   CP2_ccc_0;          // COP2 Condition Code Check
   output                   CP2_excs_0;		// COP2 Exceptions strobe
   output                   CP2_exc_0;		// COP2 Exception
   output [4:0]             CP2_exccode_0;      // COP2 Exception Code
   output                   CP2_fds_0;		// COP2 From data Data strobe
   output [2:0]             CP2_forder_0;       // COP2 From data ordering
   output [31:0] 	    CP2_fdata_0;	// COP2 From data
   output [2:0]             CP2_tordlim_0;      // COP2 To data ordering limit
   output                   CP2_present;        // COP2 is present (1=present)
   output                   CP2_idle;           // COP2 Coprocessor is idle

   // Cop2 I/F input signals
   input                    CP2_as_0;           // COP2 Arith strobe
   input                    CP2_ts_0;           // COP2 To strobe
   input                    CP2_fs_0;           // COP2 From strobe
   input                    CP2_irenable_0;     // COP2 Enable Instruction
   input [31:0]             CP2_ir_0;           // COP2 instruction word
   input                    CP2_endian_0;       // COP2 Endianess
   input                    CP2_inst32_0;       // COP2 MIPS32 compatible inst
   input                    CP2_nulls_0;        // COP2 Nullify strobe
   input                    CP2_null_0;         // COP2 Nullify
   input                    CP2_kills_0;        // COP2 Kill strobe
   input [1:0]              CP2_kill_0;         // COP2 Kill code
   input                    CP2_tds_0;          // COP2 To data strobe
   input [31:0]  	    CP2_tdata_0;        // COP2 To data
   input [2:0]              CP2_torder_0;       // COP2 To data ordering
   input [2:0]              CP2_fordlim_0;      // COP2 From data order limit
   input                    CP2_reset;		// COP2 greset signal
   input                    CP2_kd_mode_0;      // COP2 kernel mode signal             

   // Cop2 emulator control
   input 		SI_Reset;		// Global reset
   input 		SI_ClkIn;		// Global clock

    // external CP2 signals
  input  [`M14K_CP2_EXT_TOCP2_WIDTH-1:0] CP2_tocp2; // External input to CP2 module
  output  [`M14K_CP2_EXT_FROMCP2_WIDTH-1:0] CP2_fromcp2; // Output from CP2 module to external system    

// BEGIN Wire declarations made by MVP
wire [4:0] /*[4:0]*/ CP2_exccode_0;
wire [31:0] /*[31:0]*/ CP2_fdata_0;
wire CP2_idle;
wire CP2_fbusy_0;
wire [`M14K_CP2_EXT_FROMCP2_WIDTH-1:0] /*[0:0]*/ CP2_fromcp2;
wire CP2_ccc_0;
wire CP2_cccs_0;
wire CP2_tbusy_0;
wire [2:0] /*[2:0]*/ CP2_forder_0;
wire CP2_abusy_0;
wire CP2_excs_0;
wire CP2_exc_0;
wire CP2_present;
wire [2:0] /*[2:0]*/ CP2_tordlim_0;
wire CP2_fds_0;
// END Wire declarations made by MVP

    
assign CP2_fromcp2[`M14K_CP2_EXT_FROMCP2_WIDTH-1:0] = {`M14K_CP2_EXT_FROMCP2_WIDTH{1'b0}};
    

   assign CP2_abusy_0 = 1'b0;
   assign CP2_tbusy_0 = 1'b0;
   assign CP2_fbusy_0 = 1'b0;        // COP2 From data busy
   assign CP2_cccs_0 = 1'b0;         // COP2 Condition Code Check Strobe
   assign CP2_ccc_0 = 1'b0;          // COP2 Condition Code Check
   assign CP2_excs_0 = 1'b0;		// COP2 Exceptions strobe
   assign CP2_exc_0 = 1'b0;		// COP2 Exception
   assign CP2_exccode_0[4:0] = 5'b0;      // COP2 Exception Code
   assign CP2_fds_0 = 1'b0;		// COP2 From data Data strobe
   assign CP2_forder_0[2:0] = 3'b0;       // COP2 From data ordering
   assign CP2_fdata_0[31:0] = 32'b0;	// COP2 From data
   assign CP2_tordlim_0[2:0] = 3'b0;      // COP2 To data ordering limit
   assign CP2_present = 1'b0;        // COP2 is present (1=present)
   assign CP2_idle = 1'b0;           // COP2 Coprocessor is idle
    


endmodule // m14k_cop2_stub





// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_udi_stub
//             stub module if UDI not implemented
//
//	$Id: \$
//	mips_repository_id: m14k_udi_stub.mv, v 1.1 
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


// Comments for verilint
// This is a stub module so most of the inputs are unused
//verilint 240 off  // Unused input

`include "m14k_const.vh"
module m14k_udi_stub(
	UDI_ir_e,
	UDI_irvalid_e,
	UDI_rs_e,
	UDI_rt_e,
	UDI_endianb_e,
	UDI_kd_mode_e,
	UDI_kill_m,
	UDI_start_e,
	UDI_run_m,
	UDI_greset,
	UDI_gclk,
	UDI_gscanenable,
	UDI_rd_m,
	UDI_wrreg_e,
	UDI_ri_e,
	UDI_stall_m,
	UDI_present,
	UDI_honor_cee,
	UDI_toudi,
	UDI_fromudi);


        /* Inputs */
        input [31:0]    UDI_ir_e;           // full 32 bit Spec2 Instruction
        input           UDI_irvalid_e;      // Instruction reg. valid signal.

        input [31:0]    UDI_rs_e;           // edp_abus_e data from register file
        input [31:0]    UDI_rt_e;           // edp_bbus_e data from register file

	input 		UDI_endianb_e;      // Endian - 0=little, 1=big
	input 		UDI_kd_mode_e;      // Mode - 0=user, 1=kernel or debug

        input           UDI_kill_m;         // Kill signal
        input           UDI_start_e;        // mpc_run_ie signal to start the UDI.
        input 		UDI_run_m;          // mpc_run_m signal to qualify kill_m.

        input           UDI_greset;         // greset signal to reset state machine.
        input           UDI_gclk;           // Clock
        input 		UDI_gscanenable;

        /* Outputs */
        output [31:0]   UDI_rd_m;           // Result of the UDI in M stage
        output [4:0]    UDI_wrreg_e;        // Register File address written to
                                        // 5'b0 indicates not writing to 
                                        // register file.
        output          UDI_ri_e;           // Illegal Spec2 Instn.
        output          UDI_stall_m;        // Stall the pipeline. E stage signal
	output 		UDI_present;        // Indicate whether UDI is implemented
	output 		UDI_honor_cee;        // Indicate whether UDI has local state


    // external UDI signals
  input  [`M14K_UDI_EXT_TOUDI_WIDTH-1:0] UDI_toudi; // External input to UDI module
  output  [`M14K_UDI_EXT_FROMUDI_WIDTH-1:0] UDI_fromudi; // Output from UDI module to external system    

// BEGIN Wire declarations made by MVP
wire [`M14K_UDI_EXT_FROMUDI_WIDTH-1:0] /*[0:0]*/ UDI_fromudi;
// END Wire declarations made by MVP

    
assign UDI_fromudi[`M14K_UDI_EXT_FROMUDI_WIDTH-1:0] = {`M14K_UDI_EXT_FROMUDI_WIDTH{1'b0}};
    
// This module is a dummy module which reflects that no user defined SPEC2 
// instructions have been implemented. So it just sets ri_e to 1
// to signal that any spec2 instn is illegal. 

// Inactive value for outputs and no connect for inputs

assign UDI_ri_e = 1'b1;           // Illegal Spec2 Instn.
assign UDI_rd_m = 32'b0;                // Result = 0
assign UDI_wrreg_e = 5'b0;         // No writing into register.
assign UDI_stall_m = 1'b0;
assign UDI_present = 1'b0;
assign UDI_honor_cee = 1'b0;

//verilint 240 on  // Unused input
endmodule       // m14k_udi_stub


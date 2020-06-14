// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_icc_spstub 
//             stub module for icc SPRAM control logic
//
//	$Id: \$
//	mips_repository_id: m14k_icc_spstub.mv, v 1.9 
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

// Comments for verilint...Since the ports on this module need to match others,
//  some inputs are unused.
//verilint 240 off  // Unused input

`include "m14k_const.vh"
module	m14k_icc_spstub(
	ISP_TagWrStr,
	gclk,
	gscanenable,
	gscanmode,
	mpc_run_ie,
	mpc_fixupi,
	icc_imiss_i,
	edp_ival_p_19_10,
	icc_tagaddrintb,
	icop_write,
	icop_data_write,
	icop_active_m,
	icop_ready,
	icache_write_e,
	icc_tagwren4,
	icc_tagaddr,
	icc_dataaddr,
	ISP_DataWrStr,
	ISP_RdStr,
	icc_sptrstb,
	icop_tag,
	icc_tagcmpdata,
	fill_data_raw,
	icop_idx_stt,
	icop_idx_std,
	icop_fill_pend,
	spram_way,
	spram_sel_raw,
	raw_isp_hit,
	raw_isp_stall,
	sp_stall_en,
	isp_write_active,
	ISP_Hit,
	ISP_Stall,
	icop_use_idx,
	imbinvoke,
	spram_cache_data,
	spram_cache_tag,
	ISP_TagRdValue,
	ic_datain,
	ic_tagin,
	spram_support,
	ISP_Present,
	icc_sp_pres,
	ISP_Addr,
	ISP_DataTagValue,
	ISP_DataRdValue,
	icc_spwr_active,
	isp_dataaddr_scr,
	ISP_ParityEn,
	ISP_WPar,
	ISP_ParPresent,
	ISP_RPar,
	ispram_par_present,
	fill_data_par,
	cpz_pe,
	isp_size,
	ispmbinvoke,
	isp_data_raw,
	scan_mb_ispaddr,
	mbispwrite,
	gscanramwr,
	scan_ispmb_stb_ctl,
	mbispdata);


parameter PARITY =  `M14K_PARITY_ENABLE;

// Calculated parameter

parameter T_BITS = (PARITY == 1) ? `M14K_T_PAR_BITS : `M14K_T_NOPAR_BITS;
parameter D_BITS = (PARITY == 1) ? `M14K_D_PAR_BITS : `M14K_D_NOPAR_BITS;

	output 	       ISP_TagWrStr;

	input 	       gclk;
	input 	       gscanenable;
        input          gscanmode;              
	
	input 	       mpc_run_ie;
	input 	       mpc_fixupi;
	input 	       icc_imiss_i;
	input [19:10]  edp_ival_p_19_10;
	input [19:10]  icc_tagaddrintb;
	input 	       icop_write;
	input 	       icop_data_write;
	input 	       icop_active_m;
	input 	       icop_ready;
	input 	       icache_write_e;
	input [3:0]    icc_tagwren4;
	input [13:4]   icc_tagaddr;
	input [13:2]   icc_dataaddr;

	output 	       ISP_DataWrStr;
	output 	       ISP_RdStr;
	
	input 	       icc_sptrstb;
	input [23:0]   icop_tag;
	input [31:9]   icc_tagcmpdata;
	input [31:0]   fill_data_raw;
	input 	       icop_idx_stt;
	input 	       icop_idx_std;
	input 	       icop_fill_pend;

	output [3:0]   spram_way;
	output [3:0]   spram_sel_raw;
	output 	       raw_isp_hit;
	output 	       raw_isp_stall;
        output 	       sp_stall_en;
        output 	       isp_write_active;
   
	input 	       ISP_Hit;
	input 	       ISP_Stall;
	input 	       icop_use_idx;
	input 	       imbinvoke;

	output [D_BITS*`M14K_MAX_IC_ASSOC-1:0]      spram_cache_data;
	output [T_BITS*`M14K_MAX_IC_ASSOC-1:0]       spram_cache_tag;

	input [23:0] 	ISP_TagRdValue;
	input [D_BITS*`M14K_MAX_IC_ASSOC-1:0] 	ic_datain;
	input [T_BITS*`M14K_MAX_IC_ASSOC-1:0] 	ic_tagin;

	output 					spram_support;
	input 					ISP_Present;
	output 					icc_sp_pres;

	output [19:2] 	ISP_Addr;       // Additional index bits for SPRAM
	output [31:0] 	ISP_DataTagValue;
        input [31:0] 	ISP_DataRdValue;    // ispram data value
	output 		icc_spwr_active;
	output [19:2] 	isp_dataaddr_scr;

        output          ISP_ParityEn;           // Parity enable for ISPRAM
        output  [3:0]   ISP_WPar;               // Parity bit for ISPRAM write data
        input           ISP_ParPresent;         // ISPRAM has parity support
        input   [3:0]   ISP_RPar;               // Parity bits read from ISPRAM
	output		ispram_par_present;	

	input	[3:0]	fill_data_par;
        input           cpz_pe;

	output  [20:12]                         isp_size;
        input                                   ispmbinvoke;
        output  [31:0]                    	isp_data_raw;
        input   [19:2]                          scan_mb_ispaddr;
        input                                   mbispwrite;
        input                                   gscanramwr;
        input                                   scan_ispmb_stb_ctl;
        input   [D_BITS-1:0]                    mbispdata;

// BEGIN Wire declarations made by MVP
wire [31:0] /*[31:0]*/ ISP_DataTagValue;
wire [31:0] /*[31:0]*/ isp_data_raw;
wire raw_isp_hit;
wire ISP_DataWrStr;
wire [19:2] /*[19:2]*/ ISP_Addr;
wire [19:2] /*[19:2]*/ isp_dataaddr_scr;
wire [3:0] /*[3:0]*/ spram_sel_raw;
wire icc_spwr_active;
wire sp_stall_en;
wire [3:0] /*[3:0]*/ ISP_WPar;
wire [T_BITS*`M14K_MAX_IC_ASSOC-1:0] /*[99:0]*/ spram_cache_tag;
wire ISP_ParityEn;
wire [D_BITS*`M14K_MAX_IC_ASSOC-1:0] /*[143:0]*/ spram_cache_data;
wire ISP_RdStr;
wire [20:12] /*[20:12]*/ isp_size;
wire raw_isp_stall;
wire icc_sp_pres;
wire spram_support;
wire isp_write_active;
wire ispram_par_present;
wire [3:0] /*[3:0]*/ spram_way;
wire ISP_TagWrStr;
// END Wire declarations made by MVP


	assign ISP_Addr[19:2] = 18'b0;
	assign isp_dataaddr_scr[19:2] = 18'b0;
	assign ISP_DataTagValue[31:0] = 32'b0;
	assign icc_spwr_active = 1'b0;
	
	assign ISP_TagWrStr = 1'b0;
	assign ISP_RdStr = 1'b0;
	assign ISP_DataWrStr = 1'b0;
	assign spram_way[3:0] = 4'b0;
	assign spram_sel_raw[3:0] = 4'b0;
	assign raw_isp_hit = 1'b0;
	assign raw_isp_stall = 1'b0;
	assign sp_stall_en = 1'b0;

	assign spram_cache_data [D_BITS*`M14K_MAX_IC_ASSOC-1:0] = ic_datain;
	assign spram_cache_tag [T_BITS*`M14K_MAX_IC_ASSOC-1:0] = ic_tagin;

	assign spram_support = 1'b0;
	assign icc_sp_pres = 1'b0;
        assign isp_write_active = 1'b0;
	
	assign ISP_ParityEn = 1'b0;
	assign ISP_WPar[3:0] = 4'b0;
	assign ispram_par_present = 1'b0;
	
	assign isp_size[20:12] = 9'b0;
	assign isp_data_raw[31:0] = mbispdata[31:0];
	
//verilint 240 on  // Unused input
endmodule // m14k_icc_spstub


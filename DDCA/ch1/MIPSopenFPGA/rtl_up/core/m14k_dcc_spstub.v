// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_dcc_spstub 
//            stub module for dcc SPRAM control logic
//
//	$Id: \$
//	mips_repository_id: m14k_dcc_spstub.mv, v 1.12 
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
module	m14k_dcc_spstub(
	DSP_TagAddr,
	DSP_TagWrStr,
	advance_m,
	raw_cacheread_e,
	mpc_atomic_load_e,
	ev_dirtyway,
	ev_wrtag_inv,
	edp_dval_e,
	dcc_dval_m,
	dcc_dataaddr,
	raw_dstore_e,
	storewrite_e,
	raw_dcop_access_e,
	raw_dsync_e,
	storebuff_idx_mx,
	dcc_tagwren4,
	dcc_twstb,
	dcc_writemask16,
	spram_way,
	spram_sel,
	raw_dsp_hit,
	block_hit_way,
	cache_hit_way,
	DSP_Hit,
	DSP_Stall,
	use_idx,
	dmbinvoke,
	spram_cache_data,
	spram_cache_tag,
	DSP_TagRdValue,
	dc_datain,
	dc_tagin,
	spram_support,
	spram_hit,
	gclk,
	gscanenable,
	gscanmode,
	sp_stall,
	enabled_sp_hit,
	cacheread_m,
	valid_d_access,
	pref_m,
	store_m,
	dcached,
	greset,
	DSP_TagRdStr,
	cacheread_e,
	DSP_DataRdStr,
	DSP_Lock,
	dsp_lock_start,
	dsp_lock_present,
	mpc_busty_raw_e,
	dcop_read,
	dcop_access_m,
	dcop_ready,
	dcop_tag,
	DSP_DataWrStr,
	dcc_spwstb,
	DSP_TagCmpValue,
	dcc_tagcmpdata,
	dcc_tagwrdata,
	dcc_data_raw,
	DSP_Present,
	dcc_sp_pres,
	dsp_size,
	dspmbinvoke,
	dsp_data_raw,
	mbdspbytesel,
	scan_mb_dspaddr,
	mbdspread,
	gscanramwr,
	scan_dspmb_stb_ctl,
	mbdspdata,
	DSP_DataAddr,
	DSP_DataWrValue,
	DSP_DataWrMask,
	DSP_DataRdValue,
	sp_read_m,
	dcc_data_par,
	cpz_pe,
	dspram_par_present,
	DSP_ParityEn,
	DSP_WPar,
	DSP_ParPresent,
	DSP_RPar,
	DSP_DataRdStr_reg);


parameter PARITY =  `M14K_PARITY_ENABLE;

// Calculated parameter

parameter T_BITS = (PARITY == 1) ? `M14K_T_PAR_BITS : `M14K_T_NOPAR_BITS;
parameter D_BITS = (PARITY == 1) ? `M14K_D_PAR_BITS : `M14K_D_NOPAR_BITS;
parameter D_BYTES = (PARITY == 1) ? `M14K_D_PAR_BYTES : `M14K_D_NOPAR_BYTES;

	output [19:2]  DSP_TagAddr;
	output 	       DSP_TagWrStr;

	input          advance_m;
	input 	       raw_cacheread_e;
	input		mpc_atomic_load_e;
	input 	       ev_dirtyway;
	input 	       ev_wrtag_inv;
	input [19:2]   edp_dval_e;
	input [19:2]   dcc_dval_m;
	input [9:2]    dcc_dataaddr;
	input 	       raw_dstore_e;
	input 	       storewrite_e;
	input 	       raw_dcop_access_e;
	input 	       raw_dsync_e;
	input [19:10]  storebuff_idx_mx;
	input [3:0]    dcc_tagwren4;
	input 	       dcc_twstb;
	input [15:0]   dcc_writemask16;
	

	output [3:0]   spram_way;
	output [3:0]   spram_sel;

	output 	       raw_dsp_hit;
	output [3:0]   block_hit_way;
	input [3:0]    cache_hit_way;

	input 	       DSP_Hit;
	input 	       DSP_Stall;
	input 	       use_idx;
	input 	       dmbinvoke;

	output [D_BITS*`M14K_MAX_DC_ASSOC-1:0]      spram_cache_data;
	output [T_BITS*`M14K_MAX_DC_ASSOC-1:0]       spram_cache_tag;

	input [23:0] 	DSP_TagRdValue;
	input [D_BITS*`M14K_MAX_DC_ASSOC-1:0] 	dc_datain;
	input [T_BITS*`M14K_MAX_DC_ASSOC-1:0] 	dc_tagin;

	output 					spram_support;
	output 					spram_hit;
	input 				 gclk;
	input 					gscanenable;
        input                                   gscanmode;
	output 					sp_stall;
	output 					enabled_sp_hit;
	input 					cacheread_m;
	input 					valid_d_access;
	input 					pref_m;
	input 					store_m;
	input 					dcached;
	input 					greset;

	output 					DSP_TagRdStr;
	input 					cacheread_e;

	output 					DSP_DataRdStr;
	//Gracy:
	output					DSP_Lock;
	output					dsp_lock_start;
	input					dsp_lock_present;
	input [2:0] 				mpc_busty_raw_e;
	input 					dcop_read;
	input 					dcop_access_m;
	input 					dcop_ready;
	input [23:0] 				dcop_tag;

	output 					DSP_DataWrStr;
	input 					dcc_spwstb;

	output [23:0] 				DSP_TagCmpValue;
	input [31:10] 				dcc_tagcmpdata;

	input [T_BITS-1:0] 				dcc_tagwrdata;

	input [31:0] 				dcc_data_raw;

	input 					DSP_Present;
	output 					dcc_sp_pres;

	output  [20:12]                         dsp_size;
        input                                   dspmbinvoke;
        output  [31:0]                    	dsp_data_raw;
        input   [3:0]                           mbdspbytesel;
        input   [19:2]                          scan_mb_dspaddr;
        input                                   mbdspread;
        input                                   gscanramwr;
        input                                   scan_dspmb_stb_ctl;
        input   [D_BITS-1:0]                    mbdspdata;

	output [19:2] 	DSP_DataAddr;       // Additional index bits for SPRAM
	output [31:0] 	DSP_DataWrValue;
	output [3:0]	DSP_DataWrMask;     // SP write mask
        input [31:0] 	DSP_DataRdValue;    // dspram data value

	output		sp_read_m;
	input	[3:0]	dcc_data_par;		// core generated parity bits for write data
	input		cpz_pe;
	output		dspram_par_present;	// spram supports parity
	output		DSP_ParityEn;		// Parity enable for DSPRAM 
	output	[3:0]	DSP_WPar;		// Parity bit for DSPRAM write data 
	input		DSP_ParPresent;		// DSPRAM has parity support
	input	[3:0]	DSP_RPar;		// Parity bits read from DSPRAM

	output          DSP_DataRdStr_reg;      // delayed version of DSP_DataRdStr

// BEGIN Wire declarations made by MVP
wire DSP_DataWrStr;
wire [23:0] /*[23:0]*/ DSP_TagCmpValue;
wire sp_stall;
wire [3:0] /*[3:0]*/ block_hit_way;
wire DSP_TagWrStr;
wire [31:0] /*[31:0]*/ dsp_data_raw;
wire DSP_DataRdStr;
wire sp_read_m;
wire [19:2] /*[19:2]*/ DSP_DataAddr;
wire [3:0] /*[3:0]*/ DSP_DataWrMask;
wire dcc_sp_pres;
wire dspram_par_present;
wire [T_BITS*`M14K_MAX_DC_ASSOC-1:0] /*[99:0]*/ spram_cache_tag;
wire [20:12] /*[20:12]*/ dsp_size;
wire DSP_TagRdStr;
wire [19:2] /*[19:2]*/ DSP_TagAddr;
wire [D_BITS*`M14K_MAX_DC_ASSOC-1:0] /*[143:0]*/ spram_cache_data;
wire DSP_Lock;
wire DSP_DataRdStr_reg;
wire raw_dsp_hit;
wire spram_support;
wire spram_hit;
wire enabled_sp_hit;
wire DSP_ParityEn;
wire dsp_lock_start;
wire [3:0] /*[3:0]*/ DSP_WPar;
wire [31:0] /*[31:0]*/ DSP_DataWrValue;
wire [3:0] /*[3:0]*/ spram_way;
wire [3:0] /*[3:0]*/ spram_sel;
// END Wire declarations made by MVP

 
	assign DSP_DataAddr[19:2] = 18'b0;
	assign DSP_DataWrMask[3:0] = 4'b0;
	assign DSP_DataWrValue[31:0] = 32'b0;
	
	assign DSP_TagAddr [19:2] = 16'b0;
	assign DSP_TagWrStr = 1'b0;
	assign spram_way[3:0] = 4'b0;
	assign spram_sel[3:0] = 4'b0;
	assign raw_dsp_hit = 1'b0;
	assign block_hit_way[3:0] = cache_hit_way;
	assign spram_cache_data[D_BITS*`M14K_MAX_DC_ASSOC-1:0] = dc_datain;
	assign spram_cache_tag[T_BITS*`M14K_MAX_DC_ASSOC-1:0] = dc_tagin;
	assign spram_support = 1'b0;
	assign spram_hit = 1'b0;
	assign sp_stall = 1'b0;
	assign enabled_sp_hit = 1'b0;
	assign DSP_TagRdStr = 1'b0;
	assign DSP_DataRdStr = 1'b0;
	assign DSP_Lock = 1'b0; 
	assign dsp_lock_start = 1'b0;
	assign DSP_DataWrStr = 1'b0;
	assign DSP_TagCmpValue[23:0] = 24'b0;
	assign dcc_sp_pres = 1'b0;
	
	assign sp_read_m = 1'b0;
	assign DSP_ParityEn = 1'b0;
	assign DSP_WPar[3:0] = 4'b0;
	assign dspram_par_present = 1'b0;
	
	assign DSP_DataRdStr_reg = 1'b0;
	
	assign dsp_size[20:12] = 9'b0;
	assign dsp_data_raw[31:0] = mbdspdata[31:0];
// 
// verilint 528 off
	wire	sp_stall_en;
	assign sp_stall_en = 1'b0;
// verilint 528 on
// 
	
//verilint 240 on  // Unused input
endmodule // m14k_dcc_spstub


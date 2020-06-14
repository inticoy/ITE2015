// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_ic
//          Instruction Cache
//
//      $Id: \$
//      mips_repository_id: m14k_ic.mv, v 1.4 
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
module m14k_ic(
	gclk,
	greset,
	tag_addr,
	tag_wr_en,
	tag_rd_str,
	tag_wr_str,
	tag_wr_data,
	tag_rd_data,
	ws_addr,
	ws_wr_mask,
	ws_rd_str,
	ws_wr_str,
	ws_wr_data,
	ws_rd_data,
	data_addr,
	wr_mask,
	data_rd_str,
	data_wr_str,
	wr_data,
	rd_data,
	data_rd_mask,
	num_sets,
	set_size,
	hci,
	cache_present,
	bist_to,
	bist_from,
	ica_parity_present,
	early_tag_ce,
	early_data_ce,
	early_ws_ce);


	// Instance Overridden Parameters

	parameter	ASSOC = `M14K_ICACHE_ASSOC;	// Set Assoc
	parameter	WAYSIZE = `M14K_ICACHE_WAYSIZE;	// Size in KB
	parameter	PARITY = `M14K_PARITY_ENABLE;

	// calculated parameters

        parameter T_BITS = (PARITY == 1) ? `M14K_T_PAR_BITS : `M14K_T_NOPAR_BITS;
        parameter D_BITS = (PARITY == 1) ? `M14K_D_PAR_BITS : `M14K_D_NOPAR_BITS;
        parameter D_BYTES = (PARITY == 1) ? `M14K_D_PAR_BYTES : `M14K_D_NOPAR_BYTES;

        parameter       BITS_PER_BYTE_TAG = T_BITS;
        parameter       BITS_PER_BYTE_DATA = D_BYTES;

	parameter	TAG_DEPTH = 6+((WAYSIZE==16) ? 4 :
					      (WAYSIZE==8) ? 3 :
					      (WAYSIZE==4) ? 2 : 
					      (WAYSIZE==2) ? 1 : 0 );
	parameter 	DATA_DEPTH = 8 + ((WAYSIZE==16) ? 4 :
					      (WAYSIZE==8) ? 3 :
					      (WAYSIZE==4) ? 2 : 
					      (WAYSIZE==2) ? 1 : 0 );

        parameter       WS_WIDTH = (ASSOC == 4) ? 6 :
			           (ASSOC == 3) ? 3 : 1;

	input		gclk;
	input		greset;

// tag array port
	input [13:4]	tag_addr;	// Index into tag array
	input [(`M14K_MAX_IC_ASSOC-1):0] 	tag_wr_en;
	input 					tag_rd_str;	// Tag Read Strobe
	input 					tag_wr_str;	// Tag Write Strobe
	input [T_BITS-1:0] 				tag_wr_data;	// Data for Tag write 

	output [(T_BITS*`M14K_MAX_IC_ASSOC-1):0]	tag_rd_data;	// read tag

// ws array port
        input [13:4] 				ws_addr;         // Index into WS array
        input [(`M14K_MAX_IC_WS-1):0] 		ws_wr_mask;       // Write mask to write dirty bit & LRU
        input 					ws_rd_str;        // WS Read Strobe
        input 					ws_wr_str;        // WS Write Strobe
        input [(`M14K_MAX_IC_WS-1):0] 		ws_wr_data;       // Data for WS write
       
        output [(`M14K_MAX_IC_WS-1):0] 		ws_rd_data;       // read WS

// data array port	
	input [13:2] 				data_addr;
	input [(4*`M14K_MAX_IC_ASSOC-1):0] 	wr_mask;	// Byte Mask for writes
	input 					data_rd_str;	// Data Read Strobe
	input 					data_wr_str;	// Data Write Strobe 
	input [D_BITS-1:0] 				wr_data;	// Data in
	output [(D_BITS*`M14K_MAX_IC_ASSOC-1):0] 	rd_data;        // Read data for N ways of cache

	input [`M14K_MAX_IC_ASSOC-1:0]		data_rd_mask;	// data ram read way select

 	
	// Static outputs to tell core what cache looks like;
	output [2:0] 				num_sets;	 // Way Size:  0=1KB, 1=2KB, 2=4KB, 3=8K, 4=16K
	output [1:0] 				set_size;	 // Associativity: 
	                                                         //   0=DM, 1=2WSA, 2=3WSA, 3=4WSA
        output 					hci;             // Hardware cache init?
        output 					cache_present;   // Do we have a cache?
	
	
	// Bist-related signals
	input [`M14K_IC_BIST_TO-1:0] 		bist_to;	// bist signals from top level bistctl
	output [`M14K_IC_BIST_FROM-1:0] 		bist_from;	// bist signals to top level bistctl
	output					ica_parity_present;

        input           early_tag_ce;
        input           early_data_ce;
        input           early_ws_ce;

// BEGIN Wire declarations made by MVP
wire [(WS_WIDTH-1):0] /*[0:0]*/ ws_wr_mask_short;
wire [143:0] /*[143:0]*/ data_rd_data_128;
wire [5:0] /*[5:0]*/ ws_wr_mask_full;
wire [2:0] /*[2:0]*/ num_sets;
wire [(WS_WIDTH-1):0] /*[0:0]*/ ws_wr_data_short;
wire [5:0] /*[5:0]*/ ws_wr_mask_adj;
wire [31:0] /*[31:0]*/ num_sets32;
wire [1:0] /*[1:0]*/ set_size;
wire [31:0] /*[31:0]*/ set_size32;
wire [5:0] /*[5:0]*/ ws_wr_data_adj;
wire cache_present;
wire [5:0] /*[5:0]*/ ws_wr_data_full;
wire [(D_BITS*`M14K_MAX_IC_ASSOC-1):0] /*[143:0]*/ rd_data;
wire ica_parity_present;
wire [5:0] /*[5:0]*/ ws_rd_data_adj;
wire [(T_BITS*`M14K_MAX_IC_ASSOC-1):0] /*[99:0]*/ tag_rd_data;
wire [99:0] /*[99:0]*/ tag_rd_int96;
wire [5:0] /*[5:0]*/ ws_rd_data_full;
wire [(`M14K_MAX_IC_WS-1):0] /*[5:0]*/ ws_rd_data;
// END Wire declarations made by MVP


	
	/* Inouts */
	/*hookios*/

	/* End of I/O */

	// Static Outputs
        assign set_size32 [31:0] = ASSOC - 1;                                // 0=DM, 1=2way, 2=3way, 3=4way
        assign set_size [1:0] = set_size32[1:0];     
        assign num_sets32 [31:0] = (WAYSIZE == 16) ? 4 :
			 (WAYSIZE == 8) ? 3 :
			 (WAYSIZE == 4) ? 2 : (WAYSIZE-1);    // 0-1K, 1-2K, 2-4K, 3-8K, 4-16K
        assign num_sets [2:0] = num_sets32[2:0];
        assign cache_present = 1'b1;       // Use nullcache module if there is not a cache

	/* Internal Block Wires */
	wire [`M14K_IC_BIST_TAG_TO-1:0]		tag_bist_to;
	wire [`M14K_IC_BIST_TAG_FROM-1:0]	tag_bist_from;
        wire [`M14K_IC_BIST_WS_TO-1:0]           ws_bist_to;
        wire [`M14K_IC_BIST_WS_FROM-1:0]         ws_bist_from;      
	wire [`M14K_IC_BIST_DATA_TO-1:0]		data_bist_to;
	wire [`M14K_IC_BIST_DATA_FROM-1:0]	data_bist_from;

	m14k_ic_bistctl #(`M14K_IC_BIST_TO, `M14K_IC_BIST_FROM, `M14K_IC_BIST_TAG_TO, `M14K_IC_BIST_TAG_FROM, `M14K_IC_BIST_WS_TO, `M14K_IC_BIST_WS_FROM, `M14K_IC_BIST_DATA_TO, `M14K_IC_BIST_DATA_FROM) bistctl_cache (
		.cbist_to(bist_to),
		.cbist_from(bist_from),
		.tag_bist_to(tag_bist_to),
		.tag_bist_from(tag_bist_from),
		.ws_bist_to(ws_bist_to),
                .ws_bist_from(ws_bist_from),     			 
		.data_bist_to(data_bist_to),
		.data_bist_from(data_bist_from)
	);

	//
	//	Tag Array
	//
	//	CacheTag Format
	//		27-6		5 	4	3-0
	//		PA[31:10]	LRF	Lock	Valid[3:0]
	//
	// BYTES/Tag * (Data BYTES in Cache) / (Data BYTES / Line)
	wire [ASSOC*T_BITS-1:0]	tag_rd_int;	// Tag Read Output Wires
	
	`M14K_IC_TAGRAM tagram (
		.clk( gclk ),
		.greset( greset),
		.line_idx( tag_addr[(4+TAG_DEPTH)-1:4] ),
		.wr_mask( tag_wr_en[(ASSOC)-1:0] ),
		.rd_str( tag_rd_str ),
		.wr_str( tag_wr_str ),

                .early_ce(early_tag_ce),

		.wr_data( {tag_wr_data} ),
		.rd_data( tag_rd_int[T_BITS*ASSOC-1:0] ),
		.hci( hci ),
		.bist_to( tag_bist_to ),
		.bist_from( tag_bist_from )
	);

	//	Data Array
	//	data_rd_data:  Data Array Output Before Way Muxing
	
	wire [ASSOC*D_BITS-1:0] data_rd_data;

	`M14K_IC_DATARAM dataram (
		.clk( gclk ),
		.line_idx( data_addr[(2 + DATA_DEPTH -1):2] ),
		.rd_mask(data_rd_mask[ASSOC-1:0]),
		.wr_mask( wr_mask[(4*ASSOC)-1:0] ),
		.rd_str( data_rd_str  ),
		.wr_str( data_wr_str  ),

                .early_ce(early_data_ce),

		.wr_data(wr_data),
		.rd_data( data_rd_data[ASSOC*D_BITS-1:0] ),
		.bist_to( data_bist_to ),
		.bist_from( data_bist_from )
	);

        //      WS Array

        parameter       TESTTEST = `M14K_MAX_IC_WS;

        // Max Assoc (M14K_MAX_IC_WS) is bus width from this module to the core.
        // Assoc (WS_WIDTH) is bus width from this module to ram.
        //*******
        //      core / 6 bit signal interface
        //*******
        // 6 bit signal <- core(max)
        assign ws_wr_data_full[5:0] = {ws_wr_data};

        assign ws_wr_mask_full[5:0] = {ws_wr_mask};

        // core(max) <- 6 bit signal
        assign ws_rd_data[(`M14K_MAX_IC_WS-1):0] = ws_rd_data_adj[(`M14K_MAX_IC_WS-1):0];
   
        assign ws_rd_data_adj[5:0] =
                (ASSOC == 4) ? ws_rd_data_full[5:0] : // 6 bit
                (ASSOC == 3)  ?
                     ( (`M14K_MAX_IC_WS == 6) ?
                       {ws_rd_data_full[2],2'b0,ws_rd_data_full[1:0],1'b0} : // 6 bit
                       {3'b0,ws_rd_data_full[2:0]} ) :
                (ASSOC == 2) ?
                     ( (`M14K_MAX_IC_WS == 6) ? {3'b0,ws_rd_data_full[0],2'b0} : //6 bit
                       (`M14K_MAX_IC_WS == 3) ? {3'b0,1'b0,ws_rd_data_full[0],1'b0} : //3 bit
                       {5'b0,ws_rd_data_full[0]} ) :
	        // else  // set to '0' if 1-way icache (no ws array)
		     ( (`M14K_MAX_IC_WS == 6) ? {6'b0} :
		       (`M14K_MAX_IC_WS == 3) ? {3'b0,3'b0} :
		                               {5'b0,1'b0} );

        //*******
        //      6 bit signal / ram interface
        //*******
        // ram(assoc) <- 6 bit signal

        assign ws_wr_data_short[(WS_WIDTH-1):0] = ws_wr_data_adj[(WS_WIDTH-1):0];
   
        assign ws_wr_data_adj[5:0] = 
              (WS_WIDTH == 6) ? ws_wr_data_full[5:0] :
              (WS_WIDTH == 3) ? 
                  ( (`M14K_MAX_IC_WS == 6) ? 
                    {3'b0,ws_wr_data_full[5],ws_wr_data_full[2:1]} : // 3 bit
                    {3'b0,ws_wr_data_full[2:0]} ) :   
              // else
                  ( (`M14K_MAX_IC_WS == 6) ? {5'b0,ws_wr_data_full[2]} : // 1 bit
                    (`M14K_MAX_IC_WS == 3)  ? {5'b0,ws_wr_data_full[1]} : // 1 bit
                    {5'b0,ws_wr_data_full[0]} ) ;

        assign ws_wr_mask_short[(WS_WIDTH-1):0] = ws_wr_mask_adj[(WS_WIDTH-1):0];
   
        assign ws_wr_mask_adj[5:0] =
              (WS_WIDTH == 6) ? ws_wr_mask_full[5:0] :
              (WS_WIDTH == 3) ? 
                  ( (`M14K_MAX_IC_WS == 6) ? 
                    {3'b0,ws_wr_mask_full[5],ws_wr_mask_full[2:1]} : // 3 bit
                    {3'b0,ws_wr_mask_full[2:0]} ) :   
              // else
                  ( (`M14K_MAX_IC_WS == 6) ? {5'b0,ws_wr_mask_full[2]} : // 1 bit
                    (`M14K_MAX_IC_WS == 3)  ? {5'b0,ws_wr_mask_full[1]} : // 1 bit
                    {5'b0,ws_wr_mask_full[0]} ) ;
   
        // 6 bit signal <- ram(assoc)
        wire [(WS_WIDTH-1):0] ws_rd_data_short;
        assign ws_rd_data_full [5:0] = {ws_rd_data_short};   
   
        `M14K_IC_WSRAM wsram (
                .clk( gclk ),
		.greset( greset),
                .line_idx( ws_addr[(4+TAG_DEPTH)-1:4] ),
                .wr_mask( ws_wr_mask_short ),
                .rd_str( ws_rd_str ),
                .wr_str( ws_wr_str ),

                .early_ce(early_ws_ce),

                .wr_data( ws_wr_data_short ),
                .rd_data( ws_rd_data_short ),
                .bist_to( ws_bist_to ),
                .bist_from( ws_bist_from )
        );

	assign data_rd_data_128[143:0] = {data_rd_data};
	assign rd_data [(D_BITS*`M14K_MAX_IC_ASSOC-1):0] = data_rd_data_128[(D_BITS*`M14K_MAX_IC_ASSOC-1):0];

	assign tag_rd_int96[99:0] = {tag_rd_int};
	
	assign tag_rd_data [(T_BITS*`M14K_MAX_IC_ASSOC-1):0]       = tag_rd_int96[(T_BITS*`M14K_MAX_IC_ASSOC-1):0];
	
	assign ica_parity_present = (PARITY == 1) ? 1'b1 : 1'b0;

endmodule // dcache


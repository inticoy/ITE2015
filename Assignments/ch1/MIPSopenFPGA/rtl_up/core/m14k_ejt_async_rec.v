// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
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

module m14k_ejt_async_rec(
	gscanenable,
	gclk,
	gfclk,
	reset,
	reset_unsync,
	sync_data_enable,
	sync_data_out,
	sync_data_vld,
	sync_data_pnd,
	sync_wakeup,
	async_data_in,
	async_data_rdy,
	async_data_ack);


   parameter WIDTH=32;
   parameter TRIPSYNC=1;       // =1 for Triple flop synchronizers (used in gclk)
                               // =0 for Double (in TCK)
   
  /*hookios*/
  
// i/f with receiving logic -----------------------------------------------
   input     gscanenable;      // Scan Enable

   input     gclk;              // module used for both gclk and tck 
   input     gfclk;             // Free-running clock - gfclk or tck


   input     reset;            // Synchronous reset
   input     reset_unsync;     // Asynchronous reset - gate off outputs
                               //   to clear i/f even if clock is stopped
                               //   Only used for TCK

   input 	      sync_data_enable; // Enable update of capture register

   output [WIDTH-1:0] sync_data_out; // synchronized data value
   output 	      sync_data_vld; // captured data is ready to be read
   output 	      sync_data_pnd; // additional data is pending on i/f
   
   output 	      sync_wakeup;   // Start clocks to receive data
   


   // i/f with sending logic -----------------------------------------------
   input [WIDTH-1:0]   async_data_in;   // Sent data
   input 	       async_data_rdy;  // data_in is valid 
   output 	       async_data_ack;  // data has been accepted

// BEGIN Wire declarations made by MVP
wire data_rdy_synced;
wire data_rdy_sync2;
wire sync_sample_en_reset;
wire sync_data_vld;
wire data_rdy_sync1;
wire sync_sample_en;
wire data_ack;
wire sync_wakeup;
wire data_rdy_sync0;
wire sync_data_pnd;
// END Wire declarations made by MVP

   
   // This module should be paired with tpz_biu_async_snd to form the
   // two sides of an asynchronous data transfer
   
   //--------------------------
   // Handshake protocol for async transfer:
   //   A) steady state is when async_data_rdy and async_data_ack are both deasserted.
   //   B) When sending domain wants to send a new sample, it drives async_data_out and asserts
   //      async_data_rdy in the same cycle
   //   C) The receiving domain synchronizes (2x or 3x) async_data_rdy and knows that a new value 
   //      can be latched
   //   D) When receiving domain accepts the data, it asserts async_data_ack
   //   E) The sending domain synchronizes (3x or 2x) async_data_ack and deasserts async_data_rdy
   //   F) The receiving domain deasserts async_data_ack after it recognizes the deassertion of 
   //      async_data_rdy
   // Thus, the rules are:
   //   sending domain cannot change async_data_out when async_data_rdy is asserted.
   //   sending domain can only assert async_data_rdy when async_data_ack is deasserted.
   //   sending domain can only deassert async_data_rdy when async_data_ack is asserted.
   //   receiving domain can only assert async_data_ack when async_data_rdy is asserted.
   //   receiving domain can only deassert async_data_ack when async_data_rdy is deasserted.

   // Wakeup terms: synchronize data ready strobe with a free-running clock
   // Ask for a wakeup if: (data_rdy, data_ack)
   //       data is ready and has not been accepted. (1,0) and space is available
   //       Or to complete the handshake and allow more data in (0,1)
   // Allow shutdown when:
   //       idle (0,0)  
   //       or when waiting for handshake completion (1,1)
   //       (allows shutdown even if TCK stops at this point)
   // Not used in TCK modules - connect tck to both gfclk and gclk

   
   // Double or triple flop synchronizers
   mvp_register #(1) _data_rdy_sync0(data_rdy_sync0, gfclk, async_data_rdy);
   mvp_register #(1) _data_rdy_sync1(data_rdy_sync1, gfclk, data_rdy_sync0);
   mvp_register #(1) _data_rdy_sync2(data_rdy_sync2, gfclk, TRIPSYNC ? data_rdy_sync1 : 1'b0);

   assign data_rdy_synced = TRIPSYNC ? data_rdy_sync2 : data_rdy_sync1;

   // wakeup logic
   assign sync_wakeup = (~data_rdy_synced & data_ack) |    // Complete handshake to allow next x-fer
		 (data_rdy_synced & ~data_ack & ~sync_data_vld);  // Or to advance data

   
   // Sample the incoming data if: 
   assign sync_sample_en = ~reset &             // Not in reset and
		    data_rdy_synced &    // data is available and
		     ~data_ack &         // we have not already sampled it and
		     (~sync_data_vld |   // Sample register is free or 
		      sync_data_enable);    // can be overwritten
   
   // sampled data value
   wire [WIDTH-1:0] sync_data_out;

   wire [WIDTH-1:0] async_data_reset;  
   assign sync_sample_en_reset = sync_sample_en | reset;
   assign async_data_reset = {WIDTH{~reset}} & async_data_in;
 
   mvp_cregister_wide #(WIDTH) sync_data_out_(sync_data_out,
					       gscanenable, sync_sample_en_reset,
					       gclk, async_data_reset);

   // Mark data valid when sampled, clear when enable has been seen
   mvp_register #(1) _sync_data_vld(sync_data_vld, gclk, sync_sample_en | (sync_data_vld & ~sync_data_enable));

   // Indication that there is another piece of data waiting on async bus
   mvp_register #(1) _sync_data_pnd(sync_data_pnd, gclk, data_rdy_synced &     // data available and
			         ~data_ack &     // we haven't taken it and 
			         ~sync_sample_en);     // we aren't taking it now
 
   // Acknowledge once the data has been sampled and hold until data_rdy goes away
   mvp_register #(1) _data_ack(data_ack, gclk, ~reset & (sync_sample_en | (data_ack & data_rdy_synced)));

   wire 	    async_data_ack;
   
   m14k_ejt_and2 async_data_ack_(.y(async_data_ack), 
				      .a(data_ack), 
				      .b(~reset_unsync));
   
endmodule

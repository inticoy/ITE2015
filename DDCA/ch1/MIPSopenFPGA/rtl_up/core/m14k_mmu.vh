/*    Verilog header file for the MMU    */

// $Id: \$
// mips_repository_id: m14k_mmu.vh, v 1.10 


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

// Attribute field for use in JTLBL bus
// verilint 191 off
`define M14K_GBIT             0
`define M14K_VBIT            (`M14K_GBIT + 1)	// 1
`define M14K_DBIT            (`M14K_VBIT + 1)	// 2
`define M14K_CFIELDLO        (`M14K_DBIT + 1) 	// 3
`define M14K_CFIELDHI        (`M14K_CFIELDLO + `M14K_CCAWIDTH - 1)	// 5
`define M14K_CFIELD           `M14K_CFIELDHI : `M14K_CFIELDLO	// 5:3

`define M14K_RIBIT           (`M14K_CFIELDHI + 1)	// 6
`define M14K_XIBIT           (`M14K_RIBIT + 1)		// 7
  `define M14K_ATTHI         `M14K_XIBIT		// 7
`define M14K_ATTBITS         (`M14K_ATTHI - `M14K_GBIT + 1)	// 8
`define M14K_ATT              `M14K_ATTHI : `M14K_GBIT	// 7:0
`define M14K_ATTNOGBIT        `M14K_ATTHI : `M14K_VBIT	// 7:1

// JTLBL Layout
`define M14K_JTLBLHI          `M14K_PFNHI			// 31
`define M14K_JTLBLLO         (`M14K_PFNLO - `M14K_ATTBITS)	// 4
`define M14K_GLOBALBIT       (`M14K_GBIT + `M14K_JTLBLLO)	// 4
`define M14K_VALIDBIT        (`M14K_VBIT + `M14K_JTLBLLO)	// 5
`define M14K_DIRTYBIT        (`M14K_DBIT + `M14K_JTLBLLO)	// 6
`define M14K_COHERENCYRANGE   `M14K_CFIELDHI + `M14K_JTLBLLO : `M14K_CFIELDLO + `M14K_JTLBLLO	// 9:7
`define M14K_JTLBLOATT        `M14K_CFIELDHI + `M14K_JTLBLLO : `M14K_GBIT + `M14K_JTLBLLO	// 9:4
`define M14K_RINHBIT         (`M14K_RIBIT + `M14K_JTLBLLO)	// 10
`define M14K_XINHBIT         (`M14K_XIBIT + `M14K_JTLBLLO)	// 11

`define M14K_JTLBATTHI       (`M14K_ATTHI + `M14K_JTLBLLO)	// 11
`define M14K_JTLBL            `M14K_JTLBLHI : `M14K_JTLBLLO	// 31:4
`define M14K_JTLBLWIDTH      (`M14K_JTLBLHI - `M14K_JTLBLLO + 1) // 28
// The data part of the JTLB doesn't have the GBit
`define M14K_JTLBDATA         `M14K_JTLBLHI : `M14K_VALIDBIT
`define M14K_JTLBDATAWIDTH   (`M14K_JTLBLWIDTH - 1)
`define M14K_JTLBATTXG        `M14K_JTLBATTHI : `M14K_VALIDBIT
`define M14K_RPUDATA	      `M14K_XINHBIT : `M14K_VALIDBIT 
`define M14K_RPUDATAWIDTH     `M14K_XINHBIT - `M14K_VALIDBIT + 1

// PageMask attributes

`ifdef  M14K_PAGESIZE16K
`define M14K_CMASKHI       2
`define M14K_PMASKHI       3
`define M14K_CM2PMH c[2],c[2]
`define M14K_PM2CMH p[3]
`endif
`ifdef  M14K_PAGESIZE64K
`define M14K_CMASKHI       3
`define M14K_PMASKHI       5
`define M14K_CM2PMH c[3],c[3],c[2],c[2]
`define M14K_PM2CMH p[5],p[3]
`endif
`ifdef  M14K_PAGESIZE256K
`define M14K_CMASKHI       4
`define M14K_PMASKHI       7
`define M14K_CM2PMH c[4],c[4],c[3],c[3],c[2],c[2]
`define M14K_PM2CMH p[7],p[5],p[3]
`endif
`ifdef  M14K_PAGESIZE1M
`define M14K_CMASKHI       5
`define M14K_PMASKHI       9
`define M14K_CM2PMH c[5],c[5],c[4],c[4],c[3],c[3],c[2],c[2]
`define M14K_PM2CMH p[9],p[7],p[5],p[3]
`endif
`ifdef  M14K_PAGESIZE4M
`define M14K_CMASKHI       6
`define M14K_PMASKHI       11
`define M14K_CM2PMH c[6],c[6],c[5],c[5],c[4],c[4],c[3],c[3],c[2],c[2]
`define M14K_PM2CMH p[11],p[9],p[7],p[5],p[3]
`endif
`ifdef  M14K_PAGESIZE16M
`define M14K_CMASKHI       7
`define M14K_PMASKHI       13
`define M14K_CM2PMH c[7],c[7],c[6],c[6],c[5],c[5],c[4],c[4],c[3],c[3],c[2],c[2]
`define M14K_PM2CMH p[13],p[11],p[9],p[7],p[5],p[3]
`endif
`ifdef  M14K_PAGESIZE64M
`define M14K_CMASKHI       8
`define M14K_PMASKHI       15
`define M14K_CM2PMH c[8],c[8],c[7],c[7],c[6],c[6],c[5],c[5],c[4],c[4],c[3],c[3],c[2],c[2]
`define M14K_PM2CMH p[15],p[13],p[11],p[9],p[7],p[5],p[3]
`endif
`ifdef  M14K_PAGESIZE256M
`define M14K_CMASKHI       9
`define M14K_PMASKHI       17
`define M14K_CM2PMH c[9],c[9],c[8],c[8],c[7],c[7],c[6],c[6],c[5],c[5],c[4],c[4],c[3],c[3],c[2],c[2]
`define M14K_PM2CMH p[17],p[15],p[13],p[11],p[9],p[7],p[5],p[3]
`endif

`define M14K_PMASKLO       0
`define M14K_CMASKLO       0
`define M14K_CM2PM `M14K_CM2PMH,c[1],c[0]
`define M14K_PM2CM `M14K_PM2CMH,p[1],p[0]

`define M14K_CMASKWIDTH (`M14K_CMASKHI - `M14K_CMASKLO + 1)
`define M14K_PMASKWIDTH (`M14K_PMASKHI - `M14K_PMASKLO + 1)

`define M14K_CMASK     `M14K_CMASKWIDTH - 1 : 0
`define M14K_PMASK     `M14K_PMASKWIDTH - 1 : 0

`define M14K_PMLO             `M14K_VPN2LO
`define M14K_PMHI            (`M14K_PMASKWIDTH - 1 + `M14K_PMLO)
`define M14K_PMRANGE         `M14K_PMHI : `M14K_PMLO
`define M14K_PMUXRANGE       `M14K_PMHI - 1 : `M14K_PMLO - 1
`define M14K_PFNNONMUXED     `M14K_PFNHI : `M14K_PMHI

// JTLBH Layout
`define M14K_JTLBHGBIT        0
`define M14K_JTLBHVBIT        `M14K_JTLBHGBIT + 1
`define M14K_JTLBHASIDLO     (`M14K_JTLBHVBIT + 1)
`define M14K_JTLBHASIDHI     (`M14K_JTLBHASIDLO + `M14K_ASIDWIDTH - 1)
`define M14K_JTLBHVPN2LO     (`M14K_JTLBHASIDHI + 1)
`define M14K_JTLBHVPN2HI     (`M14K_JTLBHVPN2LO + `M14K_VPN2WIDTH - 1)
`define M14K_JTLBHPMLO       (`M14K_JTLBHVPN2HI + 1)
`define M14K_JTLBHPMHI       (`M14K_JTLBHPMLO + `M14K_CMASKWIDTH - 1)
`define M14K_JTLBHHI          `M14K_JTLBHPMHI
`define M14K_PMCRANGETLB      `M14K_JTLBHPMHI : `M14K_JTLBHPMLO
`define M14K_VPN2RANGETLB     `M14K_JTLBHVPN2HI : `M14K_JTLBHVPN2LO
`define M14K_ASIDRANGETLB     `M14K_JTLBHASIDHI : `M14K_JTLBHASIDLO
`define M14K_INVRANGETLB     `M14K_JTLBHVBIT
`define M14K_JTLBH            `M14K_JTLBHPMHI : `M14K_JTLBHGBIT
`define M14K_JTLBHWIDTH	     `M14K_JTLBHPMHI - `M14K_JTLBHGBIT + 1	
// verilint 191 on

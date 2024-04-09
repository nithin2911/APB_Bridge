//`timescale 1ns/1ns
`include "uvm_macros.svh"
`include "master.sv"
`include "slave1.sv"
`include "slave2.sv"


module APB_Protocol(apb_intf if1);
import uvm_pkg::*;

				wire [7:0]PWDATA,PRDATA,PRDATA1,PRDATA2;
				wire [8:0]PADDR;

				wire PREADY,PREADY1,PREADY2,PENABLE,PSEL1,PSEL2,PWRITE;
				
				assign PREADY = PADDR[8] ? PREADY2 : PREADY1 ;
				assign PRDATA = if1.READ_WRITE ? (PADDR[8] ? PRDATA2 : PRDATA1) : 8'dx ;
				
				bit [2:0] check_state;

				master_bridge dut_mas(
										if1.apb_write_paddr,
										if1.apb_read_paddr,
										if1.apb_write_data,
										PRDATA,         
										if1.PRESETn,
										if1.PCLK,
										if1.READ_WRITE,
										if1.transfer,
										PREADY,
										PSEL1,
										PSEL2,
										PENABLE,
										PADDR,
										PWRITE,
										PWDATA,
										if1.apb_read_data_out,
										if1.PSLVERR,
										check_state
									 ); 


				slave1 dut1(  if1.PCLK,if1.PRESETn, PSEL1,PENABLE,PWRITE, PADDR[7:0],PWDATA, PRDATA1, PREADY1 );

				slave2 dut2(  if1.PCLK,if1.PRESETn, PSEL2,PENABLE,PWRITE, PADDR[7:0],PWDATA, PRDATA2, PREADY2 );
  
endmodule

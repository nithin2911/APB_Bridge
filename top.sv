`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "my_test.svh"
`include "apb_protocol.sv"
`include "apb_intf.sv"

module top();
	apb_intf DutIf();
 	APB_Protocol dut1(.if1(DutIf));
	
	initial begin
  	 DutIf.PCLK = 0;
	 forever #5 DutIf.PCLK = ~DutIf.PCLK;
	end

	initial begin
	 uvm_config_db#(virtual apb_intf) :: set(null,"*","dut_vif",DutIf);
	 run_test("my_test");
	end

endmodule

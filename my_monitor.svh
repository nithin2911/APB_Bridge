`timescale 1ns/1ps
class my_monitor extends uvm_monitor;
 `uvm_component_utils(my_monitor)
 virtual apb_intf dut_vif;

 function new(string name,uvm_component parent);
  super.new(name,parent);
 endfunction
 
 uvm_analysis_port#(seq_item) mon_port;

//BUILD_PHASE IS FUNCTION
//IN BUILD PHASE WE GET INTERFACE SIGNALS
 function void build_phase(uvm_phase phase);
 mon_port = new("mon_port", this);
  //GET INTERFACE REFERENCE FROM CONFIG DATABASE
  if(!uvm_config_db #(virtual apb_intf) :: get(this,"","dut_vif",dut_vif))  //WE USED GET TO GET THE VIRUTAL INTERFACE
  `uvm_error("","uvm_config_db::get FAILED")
 endfunction

//RUN PHASE IS A TASK

 task run_phase(uvm_phase phase);
 	 seq_item seq;
	 seq = seq_item::type_id::create("seq");
  forever begin

//#0.5;
if(!dut_vif.READ_WRITE)
begin
	 @(posedge dut_vif.PCLK && dut_vif.transfer);
	 @(posedge dut_vif.PCLK);
	 seq.apb_write_paddr=dut_vif.apb_write_paddr;
	 seq.apb_write_data=dut_vif.apb_write_data;
	 seq.apb_read_paddr=dut_vif.apb_read_paddr;
	 seq.PSLVERR=dut_vif.PSLVERR;
	 seq.apb_read_data_out=dut_vif.apb_read_data_out;
	 `uvm_info("MONITOR","Written Item received",UVM_LOW)
	 seq.print();
	 end
else if(dut_vif.READ_WRITE)
begin
	 @(posedge dut_vif.PCLK && dut_vif.transfer);
	 //@(negedge dut_vif.PCLK);
	 
	 //@(posedge dut_vif.PCLK);
	 //#0.5;
	 //@(dut_vif.apb_read_paddr);
	 seq.apb_read_paddr=dut_vif.apb_read_paddr;
	 seq.apb_write_paddr=dut_vif.apb_write_paddr;
	 seq.apb_write_data=dut_vif.apb_write_data;
	 //seq.apb_read_paddr=dut_vif.apb_read_paddr;
	 seq.PSLVERR=dut_vif.PSLVERR;
	 seq.apb_read_data_out=dut_vif.apb_read_data_out;
	 `uvm_info("MONITOR","Read Item received",UVM_LOW)
	 seq.print();
	 end
	//mon_port.write(seq);
end
 endtask

endclass

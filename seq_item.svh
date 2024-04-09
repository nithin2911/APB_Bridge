
class seq_item extends uvm_sequence_item;

 
 	rand logic [8:0] apb_write_paddr;
	rand logic [7:0] apb_write_data;
	rand logic [8:0] apb_read_paddr;
	bit PSLVERR; 
	logic [7:0] apb_read_data_out; 
	bit transfer;
	bit READ_WRITE;

	
	
	
	 `uvm_object_utils_begin(seq_item)
	 `uvm_field_int(apb_write_paddr,UVM_ALL_ON)
	 `uvm_field_int(apb_write_data,UVM_ALL_ON)
	 `uvm_field_int(apb_read_paddr,UVM_ALL_ON)
	 `uvm_field_int(PSLVERR,UVM_ALL_ON)
	 `uvm_field_int(apb_read_data_out,UVM_ALL_ON)	
	 `uvm_object_utils_end
	
 
 constraint c_addr { apb_write_paddr>0; apb_write_paddr<64;}
 constraint c_data { apb_read_paddr>0; apb_read_paddr<64;} 

 function new(string name="seq_item");
  super.new(name);
 endfunction
endclass

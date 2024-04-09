`include "my_env.svh"
class my_test extends uvm_test;
  `uvm_component_utils(my_test)

 my_env env;

 function new(string name, uvm_component parent);
  super.new(name,parent);
 endfunction

 function void build_phase(uvm_phase phase);
   env = my_env::type_id::create("env",this);
 endfunction
/*
 task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  begin
   #10
   `uvm_warning("","HI, I AM UVM")
  end
  phase.drop_objection(this);
 endtask*/
endclass

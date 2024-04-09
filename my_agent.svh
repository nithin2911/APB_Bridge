//AGENT
`include "my_driver.svh"
`include "my_monitor.svh"
`include "my_sequence.svh"
class my_agent extends uvm_agent;
 `uvm_component_utils(my_agent)


  my_driver driver;
  my_monitor monitor;
  uvm_sequencer #(seq_item) sequencer;

 function new(string name, uvm_component parent);
  super.new(name,parent);
 endfunction

 function void build_phase(uvm_phase phase);
  driver = my_driver::type_id::create("driver",this);
  monitor = my_monitor::type_id::create("monitor",this);
  sequencer = uvm_sequencer #(seq_item)::type_id::create("sequencer",this);
 endfunction

 function void connect_phase(uvm_phase phase);
  driver.seq_item_port.connect(sequencer.seq_item_export);
 endfunction

 task run_phase (uvm_phase phase);
  phase.raise_objection(this);
  begin
   my_sequence seq;
   seq = my_sequence::type_id::create("seq");
   seq.start(sequencer);
  end
  phase.drop_objection(this);
 endtask
endclass




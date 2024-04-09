class my_sequence extends uvm_sequence#(seq_item);
 `uvm_object_utils(my_sequence)

 function new(string name = " ");
  super.new(name);
 endfunction
 
 task body;
  repeat(3) 
  begin
   req = seq_item::type_id::create("req");
   start_item(req);
   if(!req.randomize())
	`uvm_error("Sequence Item","NOT RANDOMIZED")
   finish_item(req);
  end
 endtask
endclass

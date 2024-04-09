`include "my_agent.svh"
`include "my_scoreboard.svh"
class my_env extends uvm_env;
	`uvm_component_utils(my_env)
	
	my_agent agent;
	my_scoreboard scoreboard;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		agent = my_agent::type_id::create("agent", this);
		scoreboard = my_scoreboard::type_id::create("scoreboard", this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
 	 agent.monitor.mon_port.connect(scoreboard.sb_port);
 	endfunction

endclass

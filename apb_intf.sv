interface apb_intf();
	bit          PCLK;
	bit          PRESETn,transfer,READ_WRITE;
	logic [8:0]  apb_write_paddr;
	logic [7:0]  apb_write_data;
	logic [8:0]  apb_read_paddr;
	bit          PSLVERR; 
	logic [7:0]  apb_read_data_out;
	
modport APB_Protocol(input PCLK,PRESETn,transfer,READ_WRITE, apb_write_paddr, apb_write_data, apb_read_paddr,output PSLVERR, apb_read_data_out);

endinterface

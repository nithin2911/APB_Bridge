//DRIVER
`include "seq_item.svh"
class my_driver extends uvm_driver #(seq_item);
	 `uvm_component_utils(my_driver)
	 
	 virtual apb_intf dut_vif;
	 integer i,j;
	 logic [7:0]data;
	 //bit [7:0]mem[0:15];

	 function new(string name,uvm_component parent);
	  super.new(name,parent);
	 endfunction
	 
	 function void build_phase(uvm_phase phase);
	   if(!uvm_config_db #(virtual apb_intf) :: get(this,"","dut_vif",dut_vif))  
		`uvm_error("","uvm_config_db::get FAILED")
	 endfunction


	 task run_phase(uvm_phase phase);
			  dut_vif.PRESETn = 0;
			  @(posedge dut_vif.PCLK);
			  #4 dut_vif.PRESETn = 1;
			 
			 /////////////////////////////////////////test 1 :NORMAL READ AND WRITE OPERATION ////////////////////////////////////////////////////////// 
			  begin 
				 reset();
						                             
						   @(posedge dut_vif.PCLK)                     //no write address available but request for write operation
						   //@(posedge dut_vif.PCLK)   dut_vif.transfer = 1;
				 repeat(2) @(posedge dut_vif.PCLK); dut_vif.PRESETn = 1; 
						   @(negedge dut_vif.PCLK)   Write_slave1;                          // write operation
				
				 repeat(3) @(posedge dut_vif.PCLK);  Write_slave2;                               
				repeat(2)	   @(posedge dut_vif.PCLK);  write_random_data();
				 repeat(2) @(posedge dut_vif.PCLK);  write_random_data();
				 repeat(2) @(posedge dut_vif.PCLK);
						   @(posedge dut_vif.PCLK)   reset(); 
						   @(posedge dut_vif.PCLK)    dut_vif.PRESETn = 1;
				 repeat(3) @(posedge dut_vif.PCLK);   //dut_vif.transfer <= 1;                  // no read address available but request for read operation
				 									  Read_slave1;                           //read operation

				 repeat(3) @(posedge dut_vif.PCLK);  Read_slave2;
				 //repeat(3) @(posedge dut_vif.PCLK);  dut_vif.apb_read_paddr <= req.apb_read_paddr;
				 //no data inserted in write operation but requested for read operation
				 repeat(4) @(posedge dut_vif.PCLK);
				
				  end
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			
	      
	      ////////////////////////////////////////test 2 :SLAVE ERROR FOR WRITE OPERATION //////////////////////////////////////////////////////////	
			
			begin
                                    reset();
               @(posedge dut_vif.PCLK)      dut_vif.PRESETn = 1;                                     //no write address available but request for write operation
               @(posedge dut_vif.PCLK)      dut_vif.transfer = 1;
     repeat(2) @(posedge dut_vif.PCLK);                                    //no write address available but request for write operation
			//$finish;
			  end
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	      /////////////////////////////////////////test 2 :SLAVE ERROR FOR READ OPERATION //////////////////////////////////////////////////////////	
			
			begin
     repeat(2) @(posedge dut_vif.PCLK);
               @(posedge dut_vif.PCLK);     dut_vif.READ_WRITE =1; dut_vif.PRESETn<=0; dut_vif.transfer<=0; 
               @(posedge dut_vif.PCLK);     dut_vif.PRESETn = 1;
     repeat(3) @(posedge dut_vif.PCLK);     dut_vif.transfer = 1;                             // no read address available but request for read operation
			 repeat(3) @(posedge dut_vif.PCLK);
			//$finish;
			  end
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	      /////////////////////////////////////////test 3 :SLAVE ERROR FOR INVALID WRITE DATA//////////////////////////////////////////////////////////	
			
			begin
     repeat(2) @(posedge dut_vif.PCLK);
               @(posedge dut_vif.PCLK);     dut_vif.READ_WRITE =0;dut_vif.apb_write_paddr <= 9'h0ff; 
               dut_vif.apb_write_data  <=8'bx;
               dut_vif.PRESETn<=0; dut_vif.transfer<=0; 
               @(posedge dut_vif.PCLK);     dut_vif.PRESETn = 1;
     repeat(3) @(posedge dut_vif.PCLK);     dut_vif.transfer = 1;                             // no read address available but request for read operation
			 repeat(3) @(posedge dut_vif.PCLK);
			 //repeat(2) @(posedge dut_vif.PCLK);  write_random_data();
			  end
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////test 4 :TOGGLE COVERAGE //////////////////////////////////////////////////////////	
			
			begin
     repeat(2) @(posedge dut_vif.PCLK);
               @(posedge dut_vif.PCLK);     dut_vif.READ_WRITE =0;dut_vif.apb_read_paddr <= 9'h02f; 
               dut_vif.apb_write_data  <=8'bx;
               dut_vif.PRESETn<=0; dut_vif.transfer<=0; 
               @(posedge dut_vif.PCLK);     dut_vif.PRESETn = 1;
     repeat(3) @(posedge dut_vif.PCLK);     dut_vif.transfer = 1;                             // no read address available but request for read operation
			 repeat(3) @(posedge dut_vif.PCLK);
			 //repeat(2) @(posedge dut_vif.PCLK);  write_random_data();
			  end
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	/////////////////////////////////////////test 5 :SLAVE ERROR FOR INVALID READ ADDRESS//////////////////////////////////////////////////////////	
			
			begin
     repeat(2) @(posedge dut_vif.PCLK);
               @(posedge dut_vif.PCLK);     dut_vif.READ_WRITE =1;dut_vif.apb_read_paddr <= 9'bx; 
               dut_vif.apb_write_data  <=8'bx;
               dut_vif.PRESETn<=0; dut_vif.transfer<=0; 
               @(posedge dut_vif.PCLK);     dut_vif.PRESETn = 1;
     repeat(3) @(posedge dut_vif.PCLK);     dut_vif.transfer = 1;                             // no read address available but request for read operation
			 repeat(3) @(posedge dut_vif.PCLK);
			 repeat(2) @(posedge dut_vif.PCLK);  write_random_data();
			  end
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////				
	 endtask
	 
	 	task reset();
	 		dut_vif.PRESETn<=0;
	 	 	dut_vif.transfer<=0;
	 	endtask

		 task write_random_data();
		   begin
		   dut_vif.READ_WRITE <=0;
		   `uvm_info("DRIVER","DRIVING RANDOMIZED VALUES",UVM_LOW)
		   seq_item_port.get_next_item(req);
		   dut_vif.apb_write_paddr <= req.apb_write_paddr;
		   dut_vif.apb_write_data  <= req.apb_write_data;
		   dut_vif.apb_read_paddr  <= 9'bx;
		   req.apb_read_paddr  = 9'bx;
		   dut_vif.transfer <=1;
		   //dut_vif.transfer<= req.transfer;
		   //dut_vif.READ_WRITE<= req.READ_WRITE;
		   seq_item_port.item_done(req);
		   //$display("Driver here");
		   req.print();
		   
		   end
		   repeat(2) @(posedge dut_vif.PCLK);
	   		dut_vif.transfer =0;
		endtask

	 
		task Write_slave1;
		begin
		$display("SLAVE 1 WRITE OPERATION 8X\n");
			dut_vif.READ_WRITE <=0;
	 		
			for (i = 0; i < 8; i=i+1) 
			begin
				repeat(2)@(negedge dut_vif.PCLK)
		    begin   
		    		dut_vif.transfer =1; 
		         	data = 30+i;
					dut_vif.apb_write_data <= 2*i;
					dut_vif.apb_write_paddr <=  {1'b0,data};
					//mem[i] = (2*i);        
			end 
			end
	   end
	   repeat(2) @(posedge dut_vif.PCLK);
	   dut_vif.transfer =0;
	   endtask


		  task Write_slave2;
		  begin
		  $display("SLAVE 2 WRITE OPERATION 8X\n");
		  dut_vif.READ_WRITE <=0;
		    
			for (i = 0; i < 8; i=i+1) 
			begin
			repeat(2)@(negedge dut_vif.PCLK)
				begin 
				dut_vif.transfer =1; 
				data = i;
				dut_vif.apb_write_paddr <= {1'b1,data};
				dut_vif.apb_write_data <= i;
				//mem[i] = i;
				end 
			end
			end
			repeat(2) @(posedge dut_vif.PCLK);
			dut_vif.transfer =0;
		endtask

			 
		  task Read_slave1;
			   reg [7:0]expected_data;
			  begin
			  dut_vif.READ_WRITE <=1;
			  
			  repeat(2) @(posedge dut_vif.PCLK);
			  $display("SLAVE 1 READ OPERATION 8X\n");
				for (j = 0;  j< 8; j= j+1)
				begin
				repeat(2)@(negedge dut_vif.PCLK)
				begin  
				dut_vif.transfer <= 1;
			  		data = 30+j; 
			 	 	dut_vif.apb_read_paddr <= {1'b0,data};
			 	 	dut_vif.apb_write_paddr  <= 9'bx;
			 	 	dut_vif.apb_write_data <= 8'bx;
			  	  	//expected_data = mem[j];
				end
				end
				end
				repeat(2) @(posedge dut_vif.PCLK);
			dut_vif.transfer =0;
		  endtask


		 task Read_slave2;
			  	 reg [7:0]expected_data;	
			  begin
			  dut_vif.READ_WRITE <=1;
			  dut_vif.transfer <= 1;
			  repeat(2) @(posedge dut_vif.PCLK);
			  $display("SLAVE 2 READ OPERATION 8X\n");
			  for (j = 0;  j< 8; j= j+1)
			  begin
			  repeat(2)@(negedge dut_vif.PCLK)
			  begin
			  		data = j;	  
			  		dut_vif.apb_read_paddr <= {1'b1,data};
			  		dut_vif.apb_write_paddr  <= 9'bx;
			 	 	dut_vif.apb_write_data <= 8'bx;
			  	    //expected_data = mem[j];
			  	    //$display("%d",expected_data);
			  end
			  end
			  end
			  repeat(2) @(posedge dut_vif.PCLK);
			dut_vif.transfer =0;
		  endtask

endclass















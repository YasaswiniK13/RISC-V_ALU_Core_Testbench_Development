class my_driver extends uvm_driver #(my_transaction);
  
    `uvm_component_utils(my_driver)
    

    virtual dut_if.TESTPORT dut_vif;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase( phase );
      // Get interface reference from config database
      if( !uvm_config_db #(virtual dut_if.TESTPORT)::get(this, "*", "dut_if", dut_vif) )
        `uvm_error("", "uvm_config_db::get failed")
    endfunction 
   
    task reset_phase(uvm_phase phase);
      super.reset_phase(phase);
      phase.raise_objection(this);
      `uvm_info("Reset", "Runing Reset seq...", UVM_MEDIUM)
      dut_vif.reset <= 1;
      @(posedge dut_vif.clock);
      @(posedge dut_vif.clock);
      @(posedge dut_vif.clock);    
      @(posedge dut_vif.clock);  
    	dut_vif.reset <= 0;
      @(posedge dut_vif.clock);
  
      phase.drop_objection(this);
    endtask
    
    task main_phase(uvm_phase phase);
      bit [31:0] data;

      my_transaction tx_req_dvr;
      `uvm_info("DRIVER",$sformatf("port connected to %0d export",seq_item_port.size()),UVM_MEDIUM)
      
      forever begin
         seq_item_port.get_next_item(tx_req_dvr);
         @(posedge dut_vif.clock); 

        dut_vif.cb.cmd   <= tx_req_dvr.cmd;

        
        if (tx_req_dvr.cmd == 1) //write
          write(tx_req_dvr.addr, tx_req_dvr.data);
        
        else begin //read       
          read(tx_req_dvr.addr, data);
          tx_req_dvr.data = data;
        end
     
     
       // `uvm_info("driver", $sformatf("cmd: %h, addr: %h, data: %h, wdata %h rdata :%h\n", tx_req_dvr.cmd, tx_req_dvr.addr, tx_req_dvr.data, dut_vif.cb.wdata, dut_vif.rdata), UVM_MEDIUM)
        seq_item_port.item_done();
      end
    endtask

      
      virtual task read( input bit [31:0] addr, output logic [31:0] data);
        dut_vif.cb.addr <= addr;
        dut_vif.cb.cmd <= 0;
        
       @(posedge dut_vif.clock);
       dut_vif.en <= 1; 
       @(posedge dut_vif.clock);
       dut_vif.en <= 0; 
      
        data = dut_vif.rdata;
    endtask  
    
      
      virtual task write( input bit [31:0] addr, input logic [31:0] data);
        dut_vif.cb.addr <= addr;
        dut_vif.cb.cmd <= 1;
        dut_vif.cb.wdata <= data;
      
        @(posedge dut_vif.clock);
        dut_vif.en <= 1; 
        @(posedge dut_vif.clock);
        dut_vif.en <= 0; 

   
    endtask   

endclass: my_driver


      
      
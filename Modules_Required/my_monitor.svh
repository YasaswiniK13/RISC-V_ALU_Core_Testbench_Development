class my_monitor extends uvm_component;
  `uvm_component_utils(my_monitor)
  
  uvm_analysis_port#(my_transaction) mon_ap;
    
  
  logic [31:0] wdata;
  logic [31:0] rdata;
  logic [7:0]  addr;
  logic        cmd;
  
  virtual dut_if.MONITORPORT dut_vif; 
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

    
  function void build_phase(uvm_phase phase);
    super.build_phase( phase );

    if( !uvm_config_db #(virtual dut_if.MONITORPORT)::get(this, "*", "dut_if", dut_vif) )
       `uvm_error("", "uvm_config_db::get failed")
            
    mon_ap = new("mon_ap", this);
  endfunction

  
  task run_phase(uvm_phase phase);
    my_transaction req;
    
    @(posedge dut_vif.clock);
    // wait until reset is 0
    while (dut_vif.reset == 1) begin 
       @(posedge dut_vif.clock);
    end

  	forever begin
      @(posedge dut_vif.clock);
      req = my_transaction::type_id::create("req");
      req.cmd = dut_vif.cmd;
      req.addr = dut_vif.addr;
      req.data = (dut_vif.cmd == 0) ? dut_vif.rdata : dut_vif.wdata; 
       
 
      `uvm_info("monitor", $sformatf("cmd: %h, addr: %h, data: %h, wdata %h rdata :%h\n", req.cmd, req.addr, req.data, dut_vif.wdata, dut_vif.rdata), UVM_MEDIUM)
           
      mon_ap.write(req);
                    
      @(posedge dut_vif.clock);
             
    end
 
  endtask
  
endclass : my_monitor
         
      
  
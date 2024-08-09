class my_agent extends uvm_component;
  `uvm_component_utils(my_agent);  
   
  function new(string name="my_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
   
  my_driver driver;
  my_monitor monitor;
  my_sequencer sequencer;
   
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = my_driver::type_id::create("driver", this);
    monitor = my_monitor::type_id::create("monitor", this);
    sequencer = my_sequencer::type_id::create("sequencer", this);
  endfunction
   
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction 
  
endclass : my_agent
        
typedef uvm_reg_predictor#(my_transaction) my_predictor;

class my_reg_env extends uvm_component;
  `uvm_component_utils(my_reg_env);  
   
  function new(string name="my_reg_env", uvm_component parent);
    super.new(name, parent);
  endfunction
   
  my_agent agent;
  my_reg_model reg_model;
  my_adapter adapter;
  my_predictor predictor;
   
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = my_agent::type_id::create("agent", this);
    reg_model = my_reg_model::type_id::create("reg_model", this);
    adapter = my_adapter::type_id::create("adapter", this);
    predictor = my_predictor::type_id::create("predictor", this);
    
    reg_model.build();
    reg_model.lock_model();
    
 
  endfunction
   
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    predictor.map = reg_model.default_map;
    predictor.adapter = adapter;
    agent.monitor.mon_ap.connect(predictor.bus_in);
    reg_model.default_map.set_sequencer(agent.sequencer, adapter);
  endfunction 
  
endclass : my_reg_env
        
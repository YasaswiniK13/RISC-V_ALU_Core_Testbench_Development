class my_test extends uvm_test;
  `uvm_component_utils(my_test);  
   
  function new(string name="my_reg_env", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  my_reg_env reg_env;
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    reg_env = my_reg_env::type_id::create("reg_env", this);
    uvm_top.print_topology();
 
  endfunction
  
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    uvm_top.print_topology();
 
  endfunction
  
  task main_phase(uvm_phase phase);
    
    my_reg_seq seq;
    
    seq = my_reg_seq::type_id::create("seq");
    
    if(! seq.randomize())
      `uvm_error("", "Randomize failed")
      
    seq.reg_model = reg_env.reg_model;
    
    seq.starting_phase = phase;
    
    seq.start(reg_env.agent.sequencer);
      
    
  endtask 
 
  
endclass : my_test
        
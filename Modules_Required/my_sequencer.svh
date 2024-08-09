class my_sequencer extends  uvm_sequencer#(my_transaction);
  `uvm_component_utils(my_sequencer)
 
  
  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  
  
endclass : my_sequencer
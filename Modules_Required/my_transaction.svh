class my_transaction extends uvm_sequence_item;
  `uvm_object_utils(my_transaction)
  
   
  logic cmd;
  rand logic [31:0] addr;
  rand logic [31:0] data;
   
      
  function new (string name = "");
    super.new(name);
  endfunction
    
  function string convert2string;
    return $sformatf("cmd=%b, addr=%0h, data=%0h", cmd, addr, data);
  endfunction



endclass: my_transaction


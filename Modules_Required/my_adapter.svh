class my_adapter extends uvm_reg_adapter;
  `uvm_object_utils(my_adapter)
  
     
  function new (string name = "");
    super.new(name);
  endfunction

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    my_transaction reg_trans;
    reg_trans = my_transaction::type_id::create("reg_trans");
    
    reg_trans.cmd = (rw.kind == UVM_WRITE);
    reg_trans.addr = rw.addr;
    
    if (rw.kind == UVM_WRITE)
      reg_trans.data = rw.data;
    
    `uvm_info("ADAPTER-reg2bus", reg_trans.convert2string, UVM_MEDIUM)
    
    
    return reg_trans;

  endfunction
  
  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    
    my_transaction reg_trans;
    assert($cast(reg_trans, bus_item))
      else `uvm_fatal("", "Adapter bus2reg $cast failed")
    
        `uvm_info("ADAPTER-bus2reg", reg_trans.convert2string, UVM_MEDIUM)
        
    rw.kind = reg_trans.cmd ? UVM_WRITE : UVM_READ;
    rw.addr = reg_trans.addr;
    rw.data = reg_trans.data;
    
    rw.status = UVM_IS_OK;
        
    `uvm_info("ADAPTER-bus2reg", $sformatf("bus2reg: addr %h, data %h, kind %h", rw.addr, rw.data, rw.kind), UVM_MEDIUM)    
        
  endfunction
  
  
endclass : my_adapter
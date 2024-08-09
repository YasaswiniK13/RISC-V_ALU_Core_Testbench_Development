class my_reg_seq extends uvm_sequence;
  `uvm_object_utils(my_reg_seq)
  
      
  function new (string name = "reg_seq");
    super.new(name);
  endfunction

  my_reg_model reg_model;
  
  task body;
    
    uvm_status_e status;
    
    uvm_reg_data_t incoming;
    uvm_reg_data_t reset_val;
    uvm_reg_data_t desired_val;
    uvm_reg_data_t mirrored_val;
    logic [31:0] rval;
    logic [31:0] pval;
    
    if(starting_phase != null)
      starting_phase.raise_objection(this);
    
    //Get the reset value of the CR1 register using get_reset()
    reset_val = reg_model.cr1.get_reset();
    `uvm_info("reg_seq, CR1, reset", $sformatf("reset value of CR1: %h", reset_val), UVM_MEDIUM)
    
    //Set the desired value of the CR1 register using set()
    reg_model.cr1.set(32'h1F2F3F4F);
    
    desired_val = reg_model.cr1.get();
    `uvm_info("reg_seq, CR1, after set", $sformatf("desired value of CR1: %h", desired_val), UVM_MEDIUM)
    
    mirrored_val = reg_model.cr1.get_mirrored_value();
    `uvm_info("reg_seq, CR1, get_mirrored_value", $sformatf("mirrored value of CR1: %h", mirrored_val), UVM_MEDIUM)
    
    reg_model.cr1.update(status);
    #30;
    mirrored_val = reg_model.cr1.get_mirrored_value();
    `uvm_info("reg_seq, CR1, get_mirrored_value after update", $sformatf("mirrored value of CR1: %h", mirrored_val), UVM_MEDIUM)
      
    desired_val = reg_model.cr1.get();
    `uvm_info("reg_seq, CR1, after update", $sformatf("desired value of CR1: %h", desired_val), UVM_MEDIUM)
    
    reg_model.cr1.update(status);
    reg_model.cr1.write(status, .value(32'hA5A5BCBC), .parent(this));
    assert( status == UVM_IS_OK); 
    
    #30;
     mirrored_val = reg_model.cr1.get_mirrored_value();
    `uvm_info("reg_seq, CR1, get_mirrored_value after write", $sformatf("mirrored value of CR1: %h", mirrored_val), UVM_MEDIUM)
      
    desired_val = reg_model.cr1.get();
    `uvm_info("reg_seq, CR1, after write", $sformatf("desired value of CR1: %h", desired_val), UVM_MEDIUM)
    
    reg_model.cr1.read(status, .value(incoming), .parent(this));
    assert( status == UVM_IS_OK);
    assert( incoming == 32'hA5A5BCBC)
      else `uvm_warning("", $sformatf("incoming = %4h, expected = 32'hA5A5BCBC", incoming))
    
    reg_model.cr1.read(status, .value(rval), .parent(this), .path(UVM_BACKDOOR));
    `uvm_info("reg_seq, CR1, after BACKDOOR read", $sformatf("read value of CR1: %h", rval), UVM_MEDIUM)
    
    reg_model.cr1.peek(status, .value(pval), .parent(this));
    `uvm_info("reg_seq, CR1, after peek", $sformatf("real value of CR1: %h", pval), UVM_MEDIUM)
    
     mirrored_val = reg_model.cr1.get_mirrored_value();
    `uvm_info("reg_seq, CR1, get_mirrored_value after peek", $sformatf("mirrored value of CR1: %h", mirrored_val), UVM_MEDIUM)
    
    reg_model.cr1.poke(status, .value(32'hFEDCBA98), .parent(this));
    reg_model.cr1.peek(status, .value(pval), .parent(this));
    `uvm_info("reg_seq, CR1, after poke", $sformatf("real value of CR1: %h", pval), UVM_MEDIUM)
    
     desired_val = reg_model.cr1.get();
    `uvm_info("reg_seq, CR1, after poke", $sformatf("desired value of CR1: %h", desired_val), UVM_MEDIUM)
    
    mirrored_val = reg_model.cr1.get_mirrored_value();
    `uvm_info("reg_seq, CR1, get_mirrored_value after poke", $sformatf("mirrored value of CR1: %h", mirrored_val), UVM_MEDIUM)
    
    reg_model.cr1.mirror(.status(status), .check(UVM_CHECK));
    
    mirrored_val = reg_model.cr1.get_mirrored_value();
    `uvm_info("reg_seq, CR1, get_mirrored_value after mirror", $sformatf("mirrored value of CR1: %h", mirrored_val), UVM_MEDIUM)
    
    
    /*
    reg_model.cr1.write(status, .value(32'hA5A5BCBC), .parent(this));
    assert( status == UVM_IS_OK);
    
    reg_model.cr2.write(status, .value(32'hFFFFAAAA), .parent(this));
    assert( status == UVM_IS_OK);
    
    reg_model.cr1.read(status, .value(incoming), .parent(this));
    assert( status == UVM_IS_OK);
    assert( incoming == 32'hA5A5BCBC)
      else `uvm_warning("", $sformatf("incoming = %4h, expected = 32'hA5A5BCBC", incoming))
    
    reg_model.cr2.read(status, .value(incoming), .parent(this));
    assert( status == UVM_IS_OK);
    assert( incoming == 32'hFFFFAAAA)
      else `uvm_warning("", $sformatf("incoming = %4h, expected = 32'hFFFFAAAA", incoming))
        
        reg_model.cr1.write(status, .value(32'hA5A5BC55), .parent(this));
    assert( status == UVM_IS_OK);
    
    reg_model.cr2.write(status, .value(32'hFFFFAA55), .parent(this));
    assert( status == UVM_IS_OK);
    
    reg_model.cr1.read(status, .value(incoming), .parent(this));
    assert( status == UVM_IS_OK);
    assert( incoming == 32'hA5A5BC55)
      else `uvm_warning("", $sformatf("incoming = %4h, expected = 32'hA5A5BC55", incoming))
    
    reg_model.cr2.read(status, .value(incoming), .parent(this));
    assert( status == UVM_IS_OK);
    assert( incoming == 32'hFFFFAA55)
      else `uvm_warning("", $sformatf("incoming = %4h, expected = 32'hFFFFAA55", incoming))  
       */ 
     if(starting_phase != null)
       #20;
      starting_phase.drop_objection(this);    
    
  endtask : body

endclass: my_reg_seq


class my_reg_cb_seq extends uvm_sequence;
  `uvm_object_utils(my_reg_cb_seq)
  
      
  function new (string name = "reg_seq");
    super.new(name);
  endfunction

  my_reg_model reg_model;
  my_usart_callback cb;
  
  task body;
    
    uvm_status_e status;
    
    uvm_reg_data_t incoming;
    uvm_reg_data_t reset_val;
    uvm_reg_data_t desired_val;
    uvm_reg_data_t mirrored_val;
    logic [31:0] rval;
    logic [31:0] pval;
    
    cb = my_usart_callback::type_id::create("cb");
    cb.isr = reg_model.isr;
    uvm_reg_cb::add(reg_model.rdr, cb);
    uvm_reg_cb::add(reg_model.rqr, cb); 
    
    if(starting_phase != null)
      starting_phase.raise_objection(this);
    
    
    //Set up the initial register values for RDR
    `uvm_info("REQ_CB_SEQ, RDR, WRITE 32'h000000AA", "", UVM_MEDIUM)
    reg_model.rdr.write(status, .value(32'h000000AA), .parent(this));
    
     //Set up the initial register values for TC and RXNE bits in the ISR 
    `uvm_info("REQ_CB_SEQ, RDR, WRITE 1 TO TC AND RXNE BITS (BIT 6 AND BIT 5)", "", UVM_MEDIUM)
    reg_model.isr.write(status, .value(32'h60), .parent(this));
    
     reg_model.isr.peek(status, .value(pval), .parent(this));
    `uvm_info("REQ_CB_SEQ, ISR, AFTER WRITE", $sformatf("real value of ISR: %h", pval), UVM_MEDIUM)
    
    #30;
    
     //Test callback on RDR read to clear RXNE bit
     reg_model.rdr.read(status, .value(rval), .parent(this));
    `uvm_info("REQ_CB_SEQ, RDR, RDR READ", $sformatf("read value of RDR: %h", rval), UVM_MEDIUM)
    
     desired_val = reg_model.isr.get();
    `uvm_info("REQ_CB_SEQ, ISR, DESIRED VALUE AFTER READING RDR", $sformatf("desired value of ISR: %h", desired_val), UVM_MEDIUM)
    
    mirrored_val = reg_model.isr.get_mirrored_value();
    `uvm_info("REQ_CB_SEQ, ISR, MIRRORED VALUE AFTER  READING RQR", $sformatf("mirrored value of ISR: %h", mirrored_val), UVM_MEDIUM)
    
    reg_model.isr.peek(status, .value(pval), .parent(this));
    `uvm_info("REQ_CB_SEQ, ISR, AFTER READING RDR", $sformatf("real value of ISR: %h", pval), UVM_MEDIUM)
    
    #30;
   
     //Set up the initial register values for TC and RXNE bits in the ISR 
    `uvm_info("REQ_CB_SEQ, RDR, WRITE 1 TO TC AND RXNE BITS (BIT 6 AND BIT 5)", "", UVM_MEDIUM)
    reg_model.isr.write(status, .value(32'h60), .parent(this));
    
     reg_model.isr.peek(status, .value(pval), .parent(this));
    `uvm_info("REQ_CB_SEQ, ISR, AFTER WRITE", $sformatf("real value of ISR: %h", pval), UVM_MEDIUM)
    
    #30;
    
    //Test callback on writing 1 to RXFRQ bit in RQR to clear RXNE bit
    `uvm_info("REQ_CB_SEQ, RQR, WRITE 1 TO RXFRQ BIT (BIT 3)", "", UVM_MEDIUM)
    reg_model.rqr.write(status, .value(32'h08), .parent(this));
    
    desired_val = reg_model.isr.get();
    `uvm_info("REQ_CB_SEQ, ISR, DESIRED VALUE AFTER WRITING 1 TO RXFRQ BIT OF RQR REGISTER", $sformatf("desired value of ISR: %h", desired_val), UVM_MEDIUM)
    
    mirrored_val = reg_model.isr.get_mirrored_value();
    `uvm_info("REQ_CB_SEQ, ISR, MIRRORED VALUE AFTER WRITING 1 TO RXFRQ BIT OF RQR REGISTER", $sformatf("mirrored value of ISR: %h", mirrored_val), UVM_MEDIUM)
    
    reg_model.isr.peek(status, .value(pval), .parent(this));
    `uvm_info("REQ_CB_SEQ, ISR, PEEK AFTER WRITING 1 TO RXFRQ BIT OF RQR REGISTER", $sformatf("real value of ISR: %h", pval), UVM_MEDIUM)
    
    /*
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

endclass: my_reg_cb_seq


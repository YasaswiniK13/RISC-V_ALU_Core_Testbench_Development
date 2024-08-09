class my_usart_rqr extends uvm_reg;
  `uvm_object_utils(my_usart_rqr)
  
  rand uvm_reg_field RQR_CONTENT1;
  rand uvm_reg_field RQR_CONTENT2;
  rand uvm_reg_field RXFRQ;
   
  function new (string name = "usart_rqr");
    super.new(name, 32, UVM_NO_COVERAGE);//name, size of the register,coverage 
  endfunction
  
  virtual function void build();
    RQR_CONTENT1 = uvm_reg_field::type_id::create("RQR_CONTENT1");
    RQR_CONTENT2 = uvm_reg_field::type_id::create("RQR_CONTENT2");
    RXFRQ = uvm_reg_field::type_id::create("RXFRQ");
   
    
    /*
    function void configure( uvm_reg parent, 
    int unsigned size,
    int unsigned lsb_position,
    string access,
    bit volatile,
    uvm_reg_data_t reset,
    bit has_reset,
    bit is_rand,
    bit individually_accessible )
    */
    
    RQR_CONTENT1.configure(this, 28, 4, "RW", 0, 28'h0, 1, 1, 1);
    RQR_CONTENT2.configure(this, 3, 0, "RW", 0, 3'h0, 1, 1, 1);
    RXFRQ.configure(this, 1, 3, "RW", 0, 1'b0, 1, 1, 1);
     
    add_hdl_path_slice(.name("RQR_CONTENT1"), .offset(4), .size(28));
    add_hdl_path_slice(.name("RXFRQ"), .offset(3), .size(1));
    add_hdl_path_slice(.name("RQR_CONTENT2"), .offset(0), .size(3));
    
  endfunction
    

endclass: my_usart_rqr


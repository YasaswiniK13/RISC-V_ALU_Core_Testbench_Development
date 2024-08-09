package my_testbench_pkg;
  import uvm_pkg::*;

  `include "my_transaction.svh"
  `include "my_usart_cr1.svh"
  `include "my_usart_cr2.svh"
  `include "my_usart_isr.svh"
  `include "my_usart_rdr.svh"
  `include "my_usart_rqr.svh"
  `include "my_reg_model.svh"
  `include "my_usart_callback.svh"
  `include "my_adapter.svh"
  `include "my_sequencer.svh"
  `include "my_driver.svh"
  `include "my_monitor.svh"
  `include "my_agent.svh"
  `include "my_reg_env.svh"
  `include "my_reg_seq.svh"
  `include "my_reg_cb_seq.svh"
  `include "my_test.svh"
  `include "my_test_cb.svh"

endpackage : my_testbench_pkg
  

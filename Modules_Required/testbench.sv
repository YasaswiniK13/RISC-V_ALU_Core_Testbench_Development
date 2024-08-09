`include "uvm_macros.svh"
`include "my_testbench_pkg.svh"

module top;

  import uvm_pkg::*;
  import my_testbench_pkg::*;
  
  bit clock;
  
  dut_if dut_if1 (clock);
  
   // Instantiate the DUT and connect it to the interface
  
  dut dut1(.clock(dut_if1.clock), .reset(dut_if1.reset), .en(dut_if1.en), .cmd(dut_if1.cmd), .addr(dut_if1.addr), .wdata(dut_if1.wdata), .rdata(dut_if1.rdata));
  

  // Clock generator

  initial begin
    clock = 0;
    forever #5 clock = ~clock;
    
  end
  
    
 // Dump waves
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top);
  end 
  
     
  
  initial
  begin
    uvm_config_db#(virtual dut_if.TESTPORT)::set(null, "*", "dut_if", dut_if1);
    uvm_config_db#(virtual dut_if.MONITORPORT)::set(null, "*", "dut_if", dut_if1);
    uvm_top.finish_on_completion = 1;   
   // run_test("my_test");
    run_test("my_test_cb");
    
    
  end
 
 
  
endmodule: top

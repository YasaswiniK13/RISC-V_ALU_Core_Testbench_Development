`include "uvm_macros.svh"

interface dut_if (input bit clock);

  // Simple synchronous bus interface
  logic reset;
  logic cmd;
  logic en;
  logic [31:0] addr;
  logic [31:0] wdata;
  logic [31:0] rdata;
 
  
  clocking cb @(posedge clock);
     output cmd;
     output addr;
     output wdata;
  endclocking
    
  
   // build a modport for DUT
   modport DUTPORT (
     input clock,
     input reset, 
     input cmd, 
     input en,
     input addr,
     input wdata,
     output rdata);

  
   // build a modport for TEST
   modport TESTPORT (
     input clock,
     clocking cb,
     output reset, 
     output en, 
     input rdata);
   
  
   // build a modport for MONITOR
   modport MONITORPORT (
     input clock,
     input reset, 
     input en,
     input cmd,
     input addr,
     input wdata,
     input rdata);
endinterface


module dut(
  input reset, clock, 
  input en,
  input cmd,
  input [31:0] addr,
  input [31:0] wdata,
  output logic [31:0] rdata);

  import uvm_pkg::*;

  // Two memory-mapped USART congtrol registers 
  
  logic [31:0] cr1, cr2;
  logic [31:0] rdr;
  logic [31:0] tdr;
  // Register fields in ISR
  logic TC, RXNE;  
  logic [24:0] ISR_CONTENT1;
  logic [4:0] ISR_CONTENT2;
  wire [31:0] isr = {ISR_CONTENT1, TC, RXNE, ISR_CONTENT2};
  // Register fields in RQR
  logic RXFRQ; 
  logic [27:0] RQR_CONTENT1;
  logic [2:0] RQR_CONTENT2;
  wire [31:0] rqr = {RQR_CONTENT1, RXFRQ,RQR_CONTENT2};
  // Register fields in ICR
  logic TCCF;
  logic [24:0] ICR_CONTENT1;
  logic [5:0] ICR_CONTENT2;  
  wire [31:0] icr = {ICR_CONTENT1,TCCF, ICR_CONTENT2};
  
  logic cr1_en, cr2_en, tdr_en, isr_en, rdr_en, rqr_en, icr_en, usart1_en;
 
  logic clear_rxne, clear_tc;
  
  //Address decoder 
 always @(*) begin
   usart1_en = (addr[31:8] == 24'h40004c);
   //usart1_en = 1;
  
   cr1_en =  usart1_en && (addr[7:0] == 8'h00);
   cr2_en =  usart1_en && (addr[7:0] == 8'h04);
   rqr_en =  usart1_en && (addr[7:0] == 8'h18);
   isr_en =  usart1_en && (addr[7:0] == 8'h1C);
   icr_en =  usart1_en && (addr[7:0] == 8'h20);
   rdr_en =  usart1_en && (addr[7:0] == 8'h24);
   tdr_en =  usart1_en && (addr[7:0] == 8'h28);
  end
  
 always @(*) begin
   //Clear bit rxne by 
   //Writing a '1' to bit RXFRQ (bit 3) in the USART_RQR (offset 18) or
   //reading from register usart_rdr (offset 24)
   clear_rxne = (rdr_en && (cmd == 0)) || (rqr_en && (cmd == 1) && wdata[3]);
  
   //TC bit is is cleared by software, by writing 1 to the TCCF (bit 6)in the 
   //USART_ICR register (offset 20) or by a write to the USART_TDR register (offset 28). 
   clear_tc = (icr_en && (cmd == 1) && wdata[6]) || (tdr_en && (cmd == 1));
 end

  
  // register read
  always@(*) begin
    if (en && (cmd == 0)) begin
    	if (cr1_en)
      		rdata = cr1;
    	else if (cr2_en)
      		rdata = cr2;
   		else if (isr_en)
          rdata = isr;
    	else if (rdr_en) 
         		rdata = rdr;   
     else if (rqr_en) 
       		rdata = rqr;     
    
     else rdata = 'hz;     		  
    end
  end
 
    
  always @(posedge clock or posedge reset)
  begin
    if (reset) begin
      cr1 <= 32'h0;
      cr2 <= 32'h0;
      rdr <= 32'h0;
      tdr <= 32'h0;
      TC <= 1'b0;
      // register fields in ISR
      RXNE <= 1'b0;
      ISR_CONTENT1 <= 25'h0;
      ISR_CONTENT2 <= 5'h0; 
      // register fields in RQR
      RXFRQ <= 1'b0;
      RQR_CONTENT1 <= 28'h0;
      RQR_CONTENT2 <= 3'h0;
      // register fields in ICR
      TCCF <= 1'b0;
      ICR_CONTENT1 <= 28'h0;
      ICR_CONTENT2 <= 3'h0;  
  	end
     
    else begin

       
      if (clear_tc) 
        TC <= 0;
      else if (isr_en && (cmd == 1))
        TC <= wdata[6];
      
      if (clear_rxne) 
        RXNE <= 0;
      else if (isr_en && (cmd == 1))
        RXNE <= wdata[5];
      
      
      if (isr_en && (cmd == 1)) begin
        ISR_CONTENT1 <= wdata[31:7];
        ISR_CONTENT2 <= wdata[4:0];
        
      end
 
      if (rdr_en && (cmd == 1)) begin
        rdr <= wdata;
    
      end
      
      if (rqr_en && (cmd == 1)) begin
        RQR_CONTENT1 <= wdata[31:4];
        RQR_CONTENT2 <= wdata[2:0];
        RXFRQ <= wdata[3];        
      end
                 
       
      if (icr_en && (cmd == 1)) begin
        ICR_CONTENT1 <= wdata[31:7];
        ICR_CONTENT2 <= wdata[5:0];
        TCCF <= wdata[6];        
      end     
     
      if (cmd == 1) begin //register write
        if (cr1_en) begin
          cr1 <= wdata;
          `uvm_info("DUT-CR1 write successful!", $sformatf("DUT received cmd=%b, addr=%d, wdata=%h", cmd, addr, wdata), UVM_MEDIUM)
        
         end
         else if (cr2_en) begin
          cr2 <= wdata;
           `uvm_info("DUT-CR2 write successful!", $sformatf("DUT received cmd=%b, addr=%d, wdata=%h", cmd, addr, wdata), UVM_MEDIUM)
    
         end
        
 
      end
            
      else if (cmd == 0) begin // register read
        
        `uvm_info("DUT-read", "DUT register read successful!", UVM_MEDIUM)
      end
 
    end
  end   
  
endmodule

 
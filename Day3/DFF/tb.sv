`timescale 1ns/1ps
module tb();
  logic d;
  logic clk; 
  logic rst; 
  logic q_norst; 
  logic q_asyncrst; 
  logic q_syncrst;
  
  //Instantiate the DUT
  dff dff1(.d(d), .clk(clk),.rst(rst),.q_norst(q_norst),.q_asyncrst(q_asyncrst),.q_syncrst(q_syncrst));
  
  integer i;
  initial begin
    rst = 1'b0;
    #2;
    rst = 1'b1;
    #0.5;
    rst = 1'b0;
    #1; rst = 1'b1;
    #0.75; rst = 1'b0;
    #1.25; rst = 1'b1;
    #1.75 rst = 1'b0;
/*    rst <= 1'b0; //Non-blocking synchronous reset doesn't reset the output in the same clock edge since the if condition is evaluated in active region and NB assignment happens in NBA region. However, the waveform for async reset stays the same as blocking statement since the NBA assignment retriggers the always block and more active events.
    #2;
    rst <= 1'b1;
    #0.5;
    rst <= 1'b0;
    #1; rst <= 1'b1;
    #0.75; rst <= 1'b0;
    #1.25; rst <= 1'b1;
    #1.75 rst <= 1'b0;*/  
  end
  initial begin
    d <= 1'b1;
    #3;
    for(i=0;i<40;i=i+1) begin
      d <= $urandom_range(1'b0,1'b1);
      #0.5;
    end
  end
  
  initial begin
    clk = 1;
    #20 $finish;
  end
  
  always begin
    #0.5 clk = ~clk;
  end
  
    initial begin
      $dumpfile("dff.vcd");
      $dumpvars(0, tb);
  end
  
endmodule


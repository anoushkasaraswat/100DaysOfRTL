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
  end
  initial begin
    for(i=0;i<40;i=i+1) begin
      d = $urandom_range(1'b0,1'b1);
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

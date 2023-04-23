// Code your testbench here
// or browse Examples
module tb();
  logic input_stream;
  logic clk;
  logic rst;
  logic out_rising;
  logic out_falling;
  
  edgeDetector ed(.input_stream(input_stream),.clk(clk),.rst(rst),.out_rising(out_rising),.out_falling(out_falling));
  
  integer i;
  initial begin

    rst <= 1'b0;
    #2;
    rst <= 1'b1;
    #0.5;
    rst <= 1'b0;
    #1; rst <= 1'b1;
    #0.75; rst <= 1'b0;
    #1.25; rst <= 1'b1;
    #1.75 rst <= 1'b0;
  end
  initial begin
    for(i=0;i<40;i=i+1) begin
      input_stream <= $urandom_range(1'b0,1'b1);
      #0.5;
    end
  end
  
  initial begin
    clk = 1;
    #24 $finish;
  end
  
  always begin
    #0.5 clk = ~clk;
  end
  
    initial begin
      $dumpfile("edgeDetector.vcd");
      $dumpvars(0, tb);
  end
  
endmodule
 

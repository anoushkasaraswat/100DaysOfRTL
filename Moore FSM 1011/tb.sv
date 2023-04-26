// Code your testbench here
// or browse Examples
module tb();
  logic clk;
  logic rst;
  logic input_stream;
  logic out;
  
  moore_1011 m(.clk(clk), .rst(rst), .input_stream(input_stream),.out(out));
  
  initial begin
    clk = 1;
    #40 $finish;
  end
  
  always begin
    #1 clk = ~clk;
  end
  
  initial begin
    rst <= 1'b1;
    input_stream <= 1'b0;
    @(posedge clk);
    rst <= 1'b0;
    @(posedge clk);
    input_stream <= 1'b1;
    @(posedge clk);
    @(posedge clk);
    input_stream <= 1'b0;
    @(posedge clk);
    input_stream <= 1'b1;    
    @(posedge clk);
    input_stream <= 1'b0;
    input_stream <= 1'b1;
    @(posedge clk);
    @(posedge clk);
    input_stream <= 1'b0;
    @(posedge clk);
    input_stream <= 1'b1;    
    @(posedge clk);
    input_stream <= 1'b1;
  end
  
  initial begin
      $dumpfile("dff.vcd");
      $dumpvars(0, tb);
  end
endmodule

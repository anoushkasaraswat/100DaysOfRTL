module tb();
  reg clk;
  reg rst;
  wire [4:0] out;
  
  lfsr sr(.clk(clk),.rst(rst),.out(out));
  
  initial begin
    clk = 1;
    #40 $finish;
  end
  
  always begin
    #1 clk = ~clk;
  end
  
  initial begin
    rst <= 1'b1;
    @(posedge clk);
    rst <= 1'b0;
  end
  initial begin
      $dumpfile("dff.vcd");
      $dumpvars(0, tb);
  end
endmodule
  

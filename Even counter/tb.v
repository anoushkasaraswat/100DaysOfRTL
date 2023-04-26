module tb();
  reg clk;
  reg rst;
  wire [7:0] count;
  
  even_counter ec(.clk(clk),.rst(rst),.count(count));
  
  always begin
    #1 clk = ~clk;
  end
  
  initial begin
    clk = 1;
    #40 $finish;
  end
  
  initial begin
    rst <= 1'b1;
    @(posedge clk);
    rst <= 1'b0;
  end
  
  initial begin
    $dumpfile("even_counter.vcd");
    $dumpvars(0, tb);
  end
  
endmodule

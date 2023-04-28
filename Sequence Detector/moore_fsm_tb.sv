module tb();
  logic clk;
  logic rst;
  logic in;
  logic out;
  
  moore_1011 m(.clk(clk), .rst(rst), .in(in),.out(out));
  
  initial begin
    clk = 1;
    #40 $finish;
  end
  
  always begin
    #1 clk = ~clk;
  end
  
  initial begin
    rst <= 1'b1;
    in <= 1'b0;
    @(posedge clk);
    rst <= 1'b0;
    @(posedge clk);
    in <= 1'b1;
    @(posedge clk);
    @(posedge clk);
    in <= 1'b0;
    @(posedge clk);
    in <= 1'b1;    
    @(posedge clk);
    in <= 1'b0;
    in <= 1'b1;
    @(posedge clk);
    @(posedge clk);
    in <= 1'b0;
    @(posedge clk);
    in <= 1'b1;    
    @(posedge clk);
    in <= 1'b1;
  end
  
  initial begin
      $dumpfile("dff.vcd");
      $dumpvars(0, tb);
  end
endmodule

module tb();
  reg clk;
  reg rst;
  reg in;
  wire out;
  
  siso s(.clk(clk),.rst(rst),.in(in),.out(out));
  
  initial begin
    clk = 1;
    #20 $finish;
  end
  
  always begin
    #1 clk = ~clk;
  end
  
  integer i;
  initial begin
    rst <= 1'b1;
    @(posedge clk);
    rst <= 1'b0;
    for(i=0;i<20;i=i+1) begin
      in <= {$random}%2;
      #1;
    end
  end
  
  initial begin
      $dumpfile("dff.vcd");
      $dumpvars(0, tb);
  end
endmodule

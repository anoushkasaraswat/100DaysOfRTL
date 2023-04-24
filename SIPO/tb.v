module tb();
  logic in;
  logic clk;
  logic rst;
  logic [3:0] out;
  
  shift_reg sf(.in(in), .clk(clk), .rst(rst), .out(out));
  
  initial begin
    clk = 1;
    #40 $finish;
  end
  
  always begin
    #1 clk = ~clk;
  end
  
  integer i; 
  
  initial begin
    rst <= 1'b1;
    in <= 1'b1;
    @(posedge clk); 
    rst <= 1'b0;
    @(posedge clk);
    for(i=0;i<32;i++) begin
      in <= $urandom_range(1'b0,1'b1);
      @(posedge clk);
    end
  end
  
  initial begin
    $dumpfile("shift_reg.vcd");
    $dumpvars(2, tb);
  end
  
endmodule

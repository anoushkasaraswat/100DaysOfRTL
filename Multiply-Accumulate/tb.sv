`define CLK @(posedge clk)
module tb();
  logic clk;
  logic rst;
  logic signed [7:0] in_a;
  logic signed [7:0] in_b;
  logic signed [15:0] out;  
  
  mac mac(.clk(clk),.rst(rst),.in_a(in_a),.in_b(in_b),.out(out));
  
  initial begin
    clk = 1;
    #40 $finish();
  end
  
  always begin
    #1 clk = ~clk;
  end
  
  integer i;
  initial begin 
    rst <= 1'b1;
    in_a <= 8'h00;
    in_b <= 8'h00;
    `CLK;
    rst <= 1'b0;
    `CLK;
    for(i=0;i<20;i++) begin
      in_a <= $random%128;
      in_b <= $random%128;
      `CLK;
    end
  end
  initial begin
    $dumpfile("mac.vcd");
    $dumpvars(0, tb);
  end
endmodule

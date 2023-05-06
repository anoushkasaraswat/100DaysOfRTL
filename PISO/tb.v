module tb();
  reg clk;
  reg rst;
  reg [3:0] pll_i;
  wire srl_o;
  
  piso ps(.clk(clk),.rst(rst),.pll_i(pll_i),.srl_o(srl_o));
  
  initial begin
    clk = 1;
    #40 $finish;
  end
  
  integer i;
  initial begin
    rst <= 1'b1;
    pll_i <= 4'hF;
    @(posedge clk);
    rst <= 1'b0;
    @(posedge clk);
    for(i=0;i<32;i=i+1) begin
      pll_i = $urandom_range(4'h0,4'hF);
      @(posedge clk);
    end
  end
  
  always begin
    #1 clk = ~clk;
  end
  
  initial begin
      $dumpfile("dff.vcd");
      $dumpvars(0, tb);
  end
endmodule  
      

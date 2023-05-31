module tb();
  logic clk;
  logic rst;
  logic [3:0] pll_in;
  logic pll_vld;
  logic srl_rdy;
  logic srl_ongoing;
  logic srl_out;
  
  serializer ps(.clk(clk),.rst(rst),.pll_in(pll_in),.pll_vld(pll_vld),.srl_rdy(srl_rdy),.srl_ongoing(srl_ongoing),.srl_out(srl_out));
  
  initial begin
    clk = 1;
    #40 $finish;
  end
  
  integer i;
  initial begin
    rst <= 1'b1;
    pll_in <= 4'h0;
    pll_vld <= 1'b0;
    @(posedge clk);
    rst <= 1'b0;
    @(posedge clk);
    for(i=0;i<32;i=i+1) begin
      pll_vld <= 1'b1;
      pll_in = $urandom_range(4'h0,4'hF);
      @(posedge clk);
      while(srl_ongoing) begin
        @(posedge clk);
      end
      pll_vld <= 1'b0;
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
      

module tb();
  logic d;
  logic clk; 
  logic rst; 
  logic q_norst; 
  logic q_asyncrst; 
  logic q_syncrst;
  
  integer i;
  initial begin
    for(i=0;i<10;i=i+1) begin
      d = $urandom_range(1'b0,1'b1);
      rst = $urandom_range(1'b0,1'b1);
      #1;
    end
  end
  
  initial begin
    clk = 0;
    #10 $finish;
  end
  
  always begin
    #1 clk = ~clk;
  end
  
endmodule

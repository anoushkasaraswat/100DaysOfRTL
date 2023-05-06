module tb();
  parameter NUM_REQS = 4;
  reg clk;
  reg rst;
  reg [NUM_REQS-1:0] req_i;
  wire [NUM_REQS-1:0] grant_o;
  
  rr_arbiter#(NUM_REQS) rra(.clk(clk),.rst(rst),.req_i(req_i),.grant_o(grant_o));
  
  initial begin
    clk = 1;
    req_i = 4'b0;
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
    for (i=0;i<40;i=i+1) begin
      req_i = $urandom_range(4'h0,4'hf);
      #1;
    end
  end
  
  initial begin
      $dumpfile("dff.vcd");
      $dumpvars(0, tb);
  end
endmodule
      

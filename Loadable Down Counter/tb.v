module tb();
  
  reg clk;
  reg rst;
  reg load_valid;
  reg [3:0] load;
  wire [3:0] out;
  
  loadable_down_counter lbc(.clk(clk),.rst(rst),.load_valid(load_valid),.load(load),.out(out));
  
  initial begin
    clk = 1;
    #40 $finish;
  end
  
  always begin
    #1 clk = ~clk;
  end
  
  integer i;
  initial begin
    rst = 1'b0;
    load_valid = 0;
    @(negedge clk);
    rst = 1'b1;
    for (i=0;i<32;i=i+1) begin
      load_valid = 0;
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      load_valid = 1;
      load = 4'hc;
      #1;
    end
  end
  
  initial begin
    $dumpfile("counter.vcd");
    $dumpvars(0, tb);
  end
endmodule
    
      
      

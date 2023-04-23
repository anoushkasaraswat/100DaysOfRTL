// Code your testbench here
// or browse Examples
module tb();
  logic input_stream;
  logic clk;
  logic rst;
  logic out_rising;
  logic out_falling;
  
  edgeDetector ed(.input_stream(input_stream),.clk(clk),.rst(rst),.out_rising(out_rising),.out_falling(out_falling));
  
  integer i;
  initial begin
    
    rst <= 1'b1;
    @(posedge clk);
    rst <= 1'b0;
    @(posedge clk);
    //@(posedge clk)

  end
  initial begin
    @(posedge clk);
    for(i=0;i<40;i=i+1) begin
      input_stream <= $urandom_range(1'b0,1'b1);
      @(posedge clk);
    end
  end
  
  initial begin
    clk = 1;
    #40 $finish;
  end
  
  always begin
    #0.5 clk = ~clk;
  end
  
    initial begin
      $dumpfile("edgeDetector.vcd");
      $dumpvars(0, tb);
  end
  
endmodule
 

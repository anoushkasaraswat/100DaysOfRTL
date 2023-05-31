`define CLK @(posedge clk)
module tb();
  logic clk;
  logic rst;
  logic rd_i;     
  logic wr_i;     
  logic rd_valid;   
  logic [31:0] rdata;
  
  apb_sys as(.clk(clk),.rst(rst),.rd_i(rd_i),.wr_i(wr_i),.rd_valid(rd_valid),.rdata(rdata));
  
  initial begin
    clk = 1;
  end
  
  always begin
    #1 clk = ~clk;
  end
  
  integer i;
  initial begin
    rst <= 1'b1;
    rd_i <= 1'b0;
    wr_i <= 1'b0;
    `CLK;
    rst <= 1'b0;
    for(i=0;i<40;i=i+1) begin
      rd_i <= $urandom_range(0,1);
      wr_i <= $urandom_range(0,1);
      `CLK;
    end
    `CLK;
    $finish();
  end
  
  // Dump VCD
  initial begin
    $dumpfile("apb_sys.vcd");
    $dumpvars(0, tb);
  end
endmodule
      
      
    
  

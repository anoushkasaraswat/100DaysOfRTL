`define CLK @(posedge clk)
module tb();
  logic clk;
  logic rst;
  logic req_vld;
  logic req_rnw; //request read = 1,  request write = 0
  logic [3:0] req_addr;
  logic [31:0] wdata;
  logic req_rdy;
  logic [31:0] rdata;
  
  mem_intf mem(.clk(clk),.rst(rst),.req_vld(req_vld),.req_rnw(req_rnw),.req_addr(req_addr),.wdata(wdata),.req_rdy(req_rdy),.rdata(rdata));
  
  initial begin
    clk = 1;
  end
  
  always begin
    #1 clk = ~clk;
  end
  
  logic [3:0] addr;
  
  integer i;
  initial begin
    rst <= 1'b1;
    req_vld <= 1'b0;
    `CLK;
    rst <= 1'b0;
    `CLK;
    for(i=0;i<4;i=i+1) begin
      req_vld <= 1'b1;
      req_rnw <= 1'b0;
      req_addr <= $urandom_range(4'h0,4'hF);
      addr = req_addr[i];
      wdata <= $urandom_range(32'h0,32'hFFFF);
      `CLK;
      while (~req_rdy) begin
        `CLK;
      end
      req_vld <= 1'b0;
      `CLK;
    end
    for (int i=0; i<4; i++) begin
      req_vld   <= 1'b1;
      req_rnw   <= 1;
      req_addr  <= addr[i];
      wdata <= $urandom_range(0, 32'hFFFF);
      // Wait for ready
      while (~req_rdy) begin
        `CLK;
      end
      req_vld <= 1'b0;
      `CLK;
    end
    $finish();
  end
  
  initial begin
    $dumpfile("mem_intf.vcd");
    $dumpvars(0, tb);
  end

  
endmodule
      
  

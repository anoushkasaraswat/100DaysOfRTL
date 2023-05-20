`define CLK @(posedge clk)

module tb();
  logic clk;
  logic rst;
  logic psel;
  logic penable;
  logic [3:0] paddr;
  logic pwrite;
  logic [31:0] pwdata;
  logic [31:0] prdata;
  logic pready;
  
  apb_slave as(.clk(clk),.rst(rst),.psel(psel),.penable(penable),.paddr(paddr),.pwrite(pwrite),.pwdata(pwdata),.prdata(prdata),.pready(pready));
  
  initial begin
    clk = 1;
  end
  
  always begin
    #1 clk = ~clk;
  end
  
  logic [31:0] addr_list [9:0];
  integer i;
  initial begin 
    rst <= 1'b1;
    psel <= 1'b0;
    penable <= 1'b0;
    `CLK;
    rst <= 1'b0;
    `CLK;
    //write txns
    for(i=0;i<6;i=i+1) begin
      psel <= 1'b1;
      `CLK;
      penable <= 1'b1;
      pwrite <= 1'b1;
      pwdata <= $urandom_range(16'h0,16'hFFFF);
      paddr <= $urandom_range(4'h0,4'hF); 
      addr_list[i] = paddr;
      `CLK;
      while(~pready) begin
        `CLK;
      end
      psel <= 1'b0;
      penable <= 1'b0;
      `CLK;
    end
    for(i=0;i<6;i=i+1) begin
      psel <= 1'b1;
      `CLK;
      penable <= 1'b1;
      pwrite <= 1'b0;
      pwdata <= $urandom_range(16'h0,16'hFFFFF);
      paddr = addr_list[i]; 
      `CLK;
      while(~pready) begin
        `CLK;
      end
      psel <= 1'b0;
      penable <= 1'b0;
      `CLK;
    end
    $finish();
  end
  
  // Dump VCD
  initial begin
    $dumpfile("apb_slave.vcd");
    $dumpvars(0, tb);
    for (i = 0; i < 10; i = i + 1) begin 
      $dumpvars(0, addr_list[i]);
    end
  end

endmodule
      
    
    
    
  

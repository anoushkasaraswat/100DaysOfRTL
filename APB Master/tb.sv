module tb();
  
  logic clk;
  logic rst_n;
  logic [1:0] cmd;
  logic pready;
  logic [31:0] prdata;
  logic psel;
  logic penable;
  logic [31:0] paddr;
  logic pwrite;
  logic [31:0] pwdata;
  
  apb_master apbm(.clk(clk),.rst_n(rst_n),.cmd(cmd),.pready(pready),.prdata(prdata),.psel(psel),.penable(penable),.paddr(paddr),.pwrite(pwrite),.pwdata(pwdata));
  
  initial begin
    clk = 1;
  end
  
  always begin
    #1 clk = ~clk;
  end
  
  initial begin
    rst_n <= 1'b0;
    cmd <= 2'b00;
    @(posedge clk)
    rst_n <= 1'b1;
    @(posedge clk);
    @(posedge clk);
    cmd <= 2'b01;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    
    cmd <= 2'b10;
    @(posedge clk);
    cmd <= 2'b00;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    $finish;
  end
  
  always @(posedge clk) begin
    if (~rst_n)
      pready <= 1'b0;
    else begin
    if (psel && penable) begin
      pready <= 1'b1;
      prdata <= $urandom%32'h20;
    end else begin
      pready <= 1'b0;
      prdata <= $urandom%32'hFF;
    end
    end
  end  
               
  
  initial begin
    $dumpfile("apb_master.vcd");
    $dumpvars(2, tb);
  end
  
endmodule

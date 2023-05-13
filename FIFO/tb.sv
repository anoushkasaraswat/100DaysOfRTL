module tb();

  parameter DEPTH = 16;
  parameter WIDTH  = 16;

  logic clk;
  logic rst;
  logic push_i;
  logic[WIDTH-1:0] push_data_i;
  logic pop_i;
  logic[WIDTH-1:0] pop_data_i;
  logic fifo_full;
  logic fifo_empty;

  
  fifo #(DEPTH, WIDTH) ff (.clk(clk),.rst(rst),.push_i(push_i),.push_data_i(push_data_i),.pop_i(pop_i),.pop_data_i(pop_data_i),.fifo_full(fifo_full),.fifo_empty(fifo_empty));

  initial begin
    clk = 1;
  end
  
  always begin
    #1 clk = ~clk;
  end
  
  integer i;
  initial begin
    rst   <= 1'b1;
    push_i  <= 1'b0;
    pop_i   <= 1'b0;
    @(posedge clk);
    rst   <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    // push data / write data to make fifo full
    for (i=0; i<DEPTH; i++) begin
      push_i      <= 1'b1;
      push_data_i <= $urandom_range(0, 2**WIDTH-1);
      @(posedge clk);
    end
    push_i <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    // pop data / read data to make fifo empty
    for (i=0; i<DEPTH; i++) begin
      pop_i      <= 1'b1;
      @(posedge clk);
    end
    pop_i <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    push_i      <= 1'b1;
    push_data_i <= $urandom_range(0, 2**WIDTH-1);
    @(posedge clk);
    push_i      <= 1'b0;
    //read and write together
    for (i=0; i<DEPTH; i++) begin
      push_i      <= 1'b1;
      pop_i       <= 1'b1;
      push_data_i <= $urandom_range(0, 2**WIDTH-1);
      @(posedge clk);
    end
    pop_i <= 1'b0;
    push_i<= 1'b0;
    @(posedge clk);
    @(posedge clk);
    $finish();
  end

  initial begin
    $dumpfile("fifo.vcd");
    $dumpvars(0, tb);
  end

endmodule

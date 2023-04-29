module tb();
  parameter BINARY_WIDTH = 4;
  parameter ONEHOT_WIDTH = 16;
  logic [BINARY_WIDTH-1:0] binary;
  logic [ONEHOT_WIDTH-1:0] onehot;
  
  bin_to_onehot bo(.binary(binary),.onehot(onehot));
  
  initial begin
    #10 $finish;
  end
  
  integer i;
  initial begin
    for (i=0; i<32; i=i+1) begin
      binary = $urandom_range(4'd00, 4'd15);
      #1;
    end
  end
  
  initial begin
    $dumpfile("binarytoonehot.vcd");
    $dumpvars(2, tb);
  end

endmodule

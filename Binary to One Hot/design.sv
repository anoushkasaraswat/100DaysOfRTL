module bin_to_onehot#(
  parameter BINARY_WIDTH = 4, 
  parameter ONEHOT_WIDTH = 16)
  (
    input logic [BINARY_WIDTH-1:0] binary,
    output logic [ONEHOT_WIDTH-1:0] onehot);
  
  assign onehot = 1'b1<<binary;
  
endmodule

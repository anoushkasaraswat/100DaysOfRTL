module moore_1011(
  input logic clk,
  input logic rst,
  input logic input_stream,
  output logic out);
  
  always @(posedge clk) begin
    if (rst) begin
      out <= 1'b0
    end
    else

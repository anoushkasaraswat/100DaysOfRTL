module shift_reg(
  input logic in,
  input logic clk,
  input logic rst,
  output logic [3:0] out);
  
  always @(posedge clk) begin
    if (rst) begin
      out <= 4'b0000;
    end
    else begin
      out[3] <= in;
      out[2] <= out[3];
      out[1] <= out[2];
      out[0] <= out[1];
    end
  end
endmodule
      

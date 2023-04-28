module lfsr(
  input wire clk,
  input wire rst,
  output wire [4:0] out);
  
  wire x_i;
  reg [4:0] out_ff;
  wire [4:0] next_value;
  assign x_i = out_ff[0]^out_ff[3];
  assign next_value = {x_i,out_ff[4:1]};
  assign out = out_ff;
  
  always@(posedge clk or posedge rst) begin
    if (rst) begin
      out_ff <= 5'b10101;
    end
    else begin
      out_ff <= next_value;
    end
  end
endmodule
      

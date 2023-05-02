//Serial In Serial Out
//Right Shift Register :: Input -> out_ff[3] -> out_ff[2] -> out_ff[1] -> out_ff[0]
module siso(
  input wire clk,
  input wire rst, 
  input wire in,
  output wire out);
  
  reg [3:0] out_ff;
  wire [3:0] out_nxt;
  assign out_nxt = {in,out_ff[3:1]};
  assign out = out_ff[0];
  always@(posedge clk or posedge rst) begin
    if (rst) begin
      out_ff <= 4'h0;
    end 
    else begin
      out_ff <= out_nxt;
    end
  end
endmodule

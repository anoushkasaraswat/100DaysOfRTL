module piso(
  input wire clk,
  input wire rst,
  input wire [3:0] pll_i,
  output reg srl_o);
  
  wire [3:0] next_data = {1'b0, pll_i[3:1]};
  wire next_srl_o;
  assign next_srl_o = pll_i[0];
  reg [3:0] data;
  
  always@(posedge clk or posedge rst) begin
    if (rst) begin
      data <= pll_i;
      srl_o <= 1'b0;
    end
    else begin
      data <= next_data;
      srl_o <= next_srl_o;
    end
  end
endmodule

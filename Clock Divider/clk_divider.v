module clk_divider_by_4(
  input wire clk,
  input wire rst,
  output reg out);
  
  reg tmp, tmp_bar, out_bar;
  assign tmp_bar = ~tmp;
  assign out_bar = ~out;
  
  always @(posedge clk) begin
    if (rst) begin
      tmp <= 1'b0;
    end
    else begin
      tmp <= tmp_bar;
    end
  end
  
  /*initial begin
    out <= 0;
  end*/
  
  always @(posedge tmp_bar) begin
    if (rst) begin
      out <= 1'b0;
    end
    else begin
      out <= out_bar;
    end
  end
endmodule

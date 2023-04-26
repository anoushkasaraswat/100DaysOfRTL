module even_counter(
  input wire clk,
  input wire rst,
  output reg [7:0] count);
  
  always @(posedge clk) begin
    if (rst) begin
      count <= 8'd0;
    end
    else begin
      count <= count + 2;
    end
  end
  
endmodule

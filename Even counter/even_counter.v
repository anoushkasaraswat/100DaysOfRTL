module even_counter(
  input wire clk,
  input wire rst,
  output reg [7:0] count,
  output reg cout);
  
  wire [7:0] next_count;
  wire next_carry;
  assign {next_carry, next_count} = count + 2;
  
  always @(posedge clk) begin
    if (rst) begin
      {cout,count} <= {1'd0,8'd0};
    end
    else begin
      {cout,count} <= {next_carry,next_count};
    end
  end
  
endmodule

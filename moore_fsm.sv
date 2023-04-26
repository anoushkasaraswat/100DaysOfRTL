// Code your design here
module moore_1011(
  input logic clk,
  input logic rst,
  input logic input_stream,
  output logic out);
  
  logic [3:0] pattern_dff;
  logic [3:0] nxt_pattern;
  
  assign nxt_pattern = {pattern_dff[2:0],input_stream};
  
  always @(posedge clk) begin
    if (rst) begin
      pattern_dff <= 4'h0;
    end
    else begin
      pattern_dff <= nxt_pattern;
      end
  end
  
  assign out = (pattern_dff == 4'b1011)?1:0;
endmodule
    

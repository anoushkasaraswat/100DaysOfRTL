// Code your design here
module edgeDetector(
  input logic input_stream,
  input logic clk,
  input logic rst,
  output logic out_rising,
  output logic out_falling);
  
  logic input_stream_q; 
  
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      input_stream_q <=1'b0;
    end
    else begin 
      input_stream_q <= input_stream;
    end
  end
  
  assign out_rising = (~input_stream_q) & input_stream;
  assign out_falling = input_stream_q & (~input_stream);
  
endmodule

module mux4to1(
  input wire [7:0] a,
  input wire [7:0] b,
  input wire [7:0] c,
  input wire [7:0] d,
  input wire sel,
  output wire [7:0] out);
  
  assign out = (sel == 2'b00)?a:(sel == 2'b01)?b:(sel == 2'b10)?c:d
  
endmodule
  

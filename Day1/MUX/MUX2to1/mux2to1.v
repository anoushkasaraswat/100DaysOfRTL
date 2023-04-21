module mux2to1(
  input wire [7:0] a,
  input wire [7:0] b,
  input wire sel,
  output wire [7:0] out);
  
  assign out = sel?a:b;
  
endmodule

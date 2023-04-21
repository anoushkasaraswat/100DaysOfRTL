module mux4to1(
  input wire [7:0] a,
  input wire [7:0] b,
  input wire [7:0] c,
  input wire [7:0] d,
  input wire [1:0] sel,
  output wire [7:0] out);
  
   assign out = sel[0]?(sel[1]?d:b):(sel[1]?c:a);
  
endmodule

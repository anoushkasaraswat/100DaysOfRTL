module binary2gray(
  input wire [7:0] input_binary,
  output wire [7:0] output_gray);
  
  assign output_gray[7] = input_binary[7];
  genvar i;
  for(i=6;i>=0;i=i-1)
    assign output_gray[i] = input_binary[i]^input_binary[i+1];

endmodule

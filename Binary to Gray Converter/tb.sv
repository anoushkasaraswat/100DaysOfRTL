module tb();
  reg [7:0] input_binary;
  wire [7:0] output_gray;
  
  binary2gray bg(.input_binary(input_binary),.output_gray(output_gray));
  
  integer i;
  initial begin
    input_binary = 8'h00;
  end
  
  initial begin
    for(i=0;i<10;i=i+1) begin
      input_binary = input_binary + 1;
      #1;
    end
  end
  initial begin
      $dumpfile("dff.vcd");
      $dumpvars(0, tb);
  end
endmodule

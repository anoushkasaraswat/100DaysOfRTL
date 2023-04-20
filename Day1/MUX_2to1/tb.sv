// Code your testbench here
// or browse Examples
module tb();
  
  reg [7:0] a;
  reg [7:0] b;
  reg sel;
  wire [7:0] out;
  
  mux2to1 mux1(.a(a), .b(b), .sel(sel), .out(out));
  
  integer i;
  initial begin
    for(i=0;i<10;i=i+1)begin
      a = {$random}%255;
      b = {$random}%255;
      sel = {$random}%2;
      #1;
    end
  end
  
    initial begin
      $dumpfile("mux2to1.vcd");
      $dumpvars(0, tb);
  end
  
endmodule

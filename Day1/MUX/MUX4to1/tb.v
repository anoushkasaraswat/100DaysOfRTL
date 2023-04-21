module tb();
  
  reg [7:0] a;
  reg [7:0] b;
  reg [7:0] c;
  reg [7:0] d;
  reg [1:0] sel;
  wire [7:0] out;
  
  mux4to1 mux1(.a(a), .b(b), .c(c), .d(d), .sel(sel), .out(out));
  
  integer i;
  initial begin
    for(i=0;i<10;i=i+1)begin
      a = $urandom_range(8'h00,8'hFF);
      b = $urandom_range(8'h00,8'hFF);
      c = $urandom_range(8'h00,8'hFF);
      d = $urandom_range(8'h00,8'hFF);
      sel = $urandom_range(2'b00,2'b11);
      #1;
    end
  end
  
    initial begin
      $dumpfile("mux4to1.vcd");
      $dumpvars(0, tb);
  end
  
endmodule
      

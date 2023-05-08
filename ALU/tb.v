module tb();
  reg [2:0] opcode;
  reg [3:0] a;
  reg [3:0] b;
  wire [3:0] alu_out;
  
  alu alu(.opcode(opcode),.a(a),.b(b),.alu_out(alu_out));
  
  integer i;
  initial begin
    for(i=0;i<32;i=i+1)begin
      opcode = $urandom_range(3'b000,3'b111);
      a = $urandom_range(4'h0,4'hF);
      b = $urandom_range(4'h0,4'hF);
      #2;
    end
  end
  
  initial begin
    $dumpfile("day19.vcd");
    $dumpvars(0, tb);
  end
endmodule  

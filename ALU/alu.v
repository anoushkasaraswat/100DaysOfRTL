module alu(
  input wire [2:0] opcode,
  input wire [3:0] a,
  input wire [3:0] b,
  output reg [3:0] alu_out);
  
  reg carry_out;
  
  parameter ADD = 3'b000,
  			SUB = 3'b001,
  			AND = 3'b010,
  			OR =  3'b011,
  			XOR = 3'b100,
  			LSR = 3'b101,
  			LSL = 3'b111;
  
  always@(*) begin
    case(opcode)
      ADD: {carry_out,alu_out} = a + b;
      SUB: alu_out = a - b;
      AND: alu_out = a & b;
      OR: alu_out = a | b;
      XOR: alu_out = a^b;
      LSR: alu_out = a >> b;
      LSL: alu_out = a << b;
    endcase
  end
  
endmodule

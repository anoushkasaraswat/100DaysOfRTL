// Code your design here
module full_adder(a,b,c,cout,sum);
  
  input wire a;
  input wire b;
  input wire c;
  output wire cout;
  output wire sum;
  
  assign sum = a ^ b ^ c;
  assign cout = (a & b) | ((a ^ b) & c);

endmodule
  
module ripple_carry_adder(a,b,cout,sum);
  input wire [3:0] a;
  input wire [3:0] b;
  output wire cout;
  output wire [3:0] sum;
  wire cout0, cout1, cout2; 
  
  full_adder f0(a[0],b[0],0,cout0,sum[0]);
  full_adder f1(a[1],b[1],cout0,cout1,sum[1]);
  full_adder f2(a[2],b[2],cout1,cout2,sum[2]);
  full_adder f3(a[3],b[3],cout2,cout,sum[3]);

endmodule

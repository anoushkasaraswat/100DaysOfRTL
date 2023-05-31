module mac(
  input clk,
  input rst,
  input signed [7:0] in_a,
  input signed [7:0] in_b,
  output logic signed [15:0] out);
  
  
  logic [7:0] reg_a;
  logic [7:0] reg_b;
  logic [15:0] reg_c;
  
  always@(posedge clk) begin
    if (rst) begin
      reg_a <= 8'h00;
      reg_b <= 8'h00;
    end
    else begin
      reg_a <= in_a;
      reg_b <= in_b;
    end
  end
  
  always@(posedge clk) begin
    if (rst) begin
      reg_c <= 16'h0000;
    end
    else begin
      reg_c <= (reg_a*reg_b) + reg_c;
    end
  end  
  
  assign out = reg_c;
endmodule
  
      
  

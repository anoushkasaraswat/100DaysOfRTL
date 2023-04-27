module shift_reg(
  input logic in,
  input logic clk,
  input logic rst,
  output logic [3:0] out);
  
  logic [4:0] out_ff;
  logic [4:0] next_out;
  
  //Better visibility and representation
  assign next_out = {in, out_ff[3:1]};
  assign out = out_ff;
  
  always @(posedge clk) begin
    if (rst) begin
      out_ff <= 4'b0000;
    end
    else begin
      out_ff <= next_out;
    end
  end  

  /*always @(posedge clk) begin
    if (rst) begin
      out <= 4'b0000;
    end
    else begin
      out[3] <= in;
      out[2] <= out[3];
      out[1] <= out[2];
      out[0] <= out[1];
    end
  end*/
  
endmodule
      

module loadable_down_counter(
  input wire clk,
  input wire rst,
  input wire load_valid,
  input wire [3:0] load,
  output reg [3:0] out);
  
  wire [3:0] out_next;
  reg [3:0] load_ff;
  
  assign out_next = load_valid?load:(out == 4'h0)?4'hF:(out-4'h1);
 
  always@(posedge clk or negedge rst) begin
    if (~rst) begin
      out <= 4'hF;
    end
    else begin
      out <= out_next;
    end
  end
  
endmodule
   

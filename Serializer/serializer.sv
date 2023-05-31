module serializer(
  input wire clk,
  input wire rst,
  input logic [3:0] pll_in,
  input logic pll_vld,
  output logic srl_rdy,
  output logic srl_ongoing,
  output logic srl_out);
  
  wire p2s_txn_start = pll_vld && srl_rdy;
  logic [3:0] nxt_pll_ff;
  wire nxt_srl_out;
  logic [3:0] pll_ff;
  
  assign nxt_pll_ff = p2s_txn_start?pll_in:{1'b0,pll_ff[3:1]};
  assign srl_out = pll_ff[0];
 
  always@(posedge clk) begin
    if (rst) begin
      pll_ff <= 4'b0000;
    end
    else begin
      pll_ff <= nxt_pll_ff;
    end
  end
  
  logic [1:0] count;
  wire [1:0] nxt_count;
  assign nxt_count = p2s_txn_start?0:count + 1;
  always@(posedge clk) begin
    if (rst) begin
      count <= 2'b00;
    end
    else begin
      count <= nxt_count; //will rollback to 0 since no carry
    end
  end
  
  assign srl_ongoing = |count;
  assign srl_rdy = ~|count;
  
endmodule
  
  
  
  
      

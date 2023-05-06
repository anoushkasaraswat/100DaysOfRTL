module rr_arbiter#(parameter NUM_REQS=4)(
  input wire clk,
  input wire rst,
  input wire [NUM_REQS-1:0] req_i,
  output wire [NUM_REQS-1:0] grant_o); 
  
  reg [NUM_REQS-1:0] mask;
  reg [NUM_REQS-1:0] next_mask;
  wire [NUM_REQS-1:0] mask_grant;
  wire [NUM_REQS-1:0] unmask_grant;
  wire [NUM_REQS-1:0] mask_req_i;
  
  always@(*) begin
    next_mask = mask;
    if (grant_o[0]) next_mask = 4'b1110;
    else if (grant_o[1]) next_mask = 4'b1100;
    else if (grant_o[2]) next_mask = 4'b1000;
    else if (grant_o[3]) next_mask = 4'b0000;
  end
  
  always@(posedge clk or posedge rst) begin
    if (rst) begin
      mask <= {NUM_REQS{1'b1}};
    end
    else begin
      mask <= next_mask;
    end
  end
  
  assign mask_req_i = req_i & mask;
  
  fp_arbiter#(NUM_REQS) fp1(.req_i(mask_req_i),.grant_o(mask_grant));
  fp_arbiter#(NUM_REQS) fp2(.req_i(req_i),.grant_o(unmask_grant));
  
  assign grant_o = (|mask_req_i)?mask_grant:unmask_grant;
  

endmodule

module fp_arbiter#(parameter NUM_REQS=4)(
  input wire [NUM_REQS-1:0] req_i,
  output wire [NUM_REQS-1:0] grant_o);
  
  assign grant_o[0] = req_i[0]?1:0;
  
  genvar i;
  for(i=1;i<NUM_REQS;i=i+1) begin
    assign grant_o[i] = req_i[i] & (~|req_i[i-1:0]);
  end
endmodule
  
  
  
  
  
  
  
                
    

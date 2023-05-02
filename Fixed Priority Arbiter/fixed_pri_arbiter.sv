//Lower order bits carry higher priority
//One hot encoding of requesters and grant

module fixed_pri_arbiter#(parameter REQUESTERS = 4)(
  input wire [REQUESTERS-1:0] req_i,
  output wire [REQUESTERS-1:0] grant_i);
  
  assign grant_i[0] = req_i[0]?1:0;
  
  generate
    genvar i;
    for(i=1;i<REQUESTERS;i=i+1) begin
      assign grant_i[i] = req_i[i] & ~(|req_i[i-1:0]);
    end
  endgenerate
endmodule

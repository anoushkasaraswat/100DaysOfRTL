module tb();
  parameter REQUESTERS =  4;
  reg [REQUESTERS-1:0] req_i;
  wire [REQUESTERS-1:0] grant_i;
  
  fixed_pri_arbiter#(REQUESTERS) fp_arb(.req_i(req_i),.grant_i(grant_i));
                        
  initial begin
    req_i = 4'b0;
    #20 $finish;
  end
  
  integer i;                   
  always begin
    for (i=0;i<20;i=i+1) begin
      req_i = $urandom_range(4'h0,4'hf);
      #1;
    end
  end
  
  initial begin
      $dumpfile("dff.vcd");
      $dumpvars(0, tb);
  end
endmodule
                     
  
                     

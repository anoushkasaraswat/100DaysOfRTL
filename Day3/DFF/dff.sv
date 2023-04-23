module dff(
  input logic d, 
  input logic clk, 
  input logic rst, 
  output logic q_norst, 
  output logic q_asyncrst, 
  output logic q_syncrst);
  
  //dff without reset
  always @(posedge clk) begin
    q_norst <= d;
  end
  
  //dff with synchronous reset
  always@(posedge clk) begin
    if (rst) begin
      q_syncrst <= 1'b0;
    end
    else begin
      q_syncrst <=d;
    end
  end

  //dff with asynchronous reset
  always@(posedge clk or posedge rst) begin
    if (rst) begin
      q_asyncrst <= 1'b0;
    end
    else begin
      q_asyncrst <= d;
    end
  end
endmodule
        
        
        

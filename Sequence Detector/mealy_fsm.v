// Code your design here
module mealy_1011(
  input wire clk,
  input wire rst,
  input wire in,
  output reg out);
  
  /*typedef enum logic [2:0] 
  {
    S0, S1, S2, S3
  } state;*/
  
  reg [1:0] pst;
  reg [1:0] nst;
  localparam S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
  
   // combinational next state logic
  always@(*) begin
    case(pst)
      S0: begin
        nst = in?S1:S0;
      end
      S1: begin
        nst = in?S1:S2;
      end
      S2: begin
        nst = in?S3:S0;
      end
      S3: begin
        nst = in?S1:S2;
      end       
    endcase
  end
  
//present state sequential logic
  always@(posedge clk or posedge rst) begin 
    if (rst) begin
      pst <= S0;
    end
    else begin
      pst <= nst;
    end
  end

//registered output
  always@(posedge clk or posedge rst) begin
    if (rst) begin
      out <= 1'b0;
    end
    else begin
      out <= (pst==S3) && in;
    end
  end
endmodule

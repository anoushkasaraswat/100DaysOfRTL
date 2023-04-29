module moore_1011(
  input logic clk,
  input logic rst,
  input logic in,
  output logic out);
  
  typedef enum logic [2:0] 
  {
    S0, S1, S2, S3, S4
  } st;
  
  //localparam S0 = 2'b00, S1 = 2'b01; S2 = 2'b10, S3 = 2'b11;
  st pst; //present state
  logic [2:0] nst; // next state
  
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
        nst = in?S4:S2;
      end       
      S4: begin
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
      out <= (pst==S4);
    end
  end
endmodule

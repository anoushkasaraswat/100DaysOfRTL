module moore_1011(
  input logic clk,
  input logic rst,
  input logic in,
  output logic out);
  
  typedef enum logic [2:0] 
  {
    S0, S1, S2, S3, S4
  } state;
  
  state st;
  
  always@(posedge clk) begin
    if (rst) begin
      st <= S0;
      out <= 1'b0;
    end
    else begin
      case(st)
        S0: begin
          out <= 1'b0;
          if (in) begin
            st <= S1;
          end
        end
        S1: begin
          out <= 1'b0;
          if (~in) begin
            st <= S2;
          end
        end
        S2: begin
          out <= 1'b0;
          if (in) begin
            st <= S3;
          end
          else begin
            st <= S0;
          end
        end
        S3: begin
          out <= 1'b0;
          if (in) begin
            st <= S4;
          end
          else begin
            st <= S2;
          end
        end        
        S4: begin
          out <= 1'b1;
          if (in) begin
            st <= S1;
          end
          else begin
            st <= S2;
          end
        end
      endcase
    end
  end
endmodule

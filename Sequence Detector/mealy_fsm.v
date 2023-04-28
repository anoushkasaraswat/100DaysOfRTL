module mealy_1011(
  input wire clk,
  input wire rst,
  input wire in,
  output reg out);
  
  /*typedef enum logic [2:0] 
  {
    S0, S1, S2, S3
  } state;*/
  
  reg [2:0] st;
  localparam S0 = 1'b00, S1 = 1'b01, S2 = 1'b10, S3 = 1'b11;
  
  always@(posedge clk) begin
    if (rst) begin
      st <= S0;
    end
    else begin
      case(st)
        S0: begin
          if (in) begin
            st <= S1;
            out <= 1'b0;
          end
          else begin
            out <= 1'b0;
          end
        end
        S1: begin
          if (~in) begin
            st <= S2;
            out <= 1'b0;
          end
          else begin
            out <= 1'b0;
          end
        end
        S2: begin
          if (in) begin
            st <= S3;
            out <= 1'b0;
          end
          else begin
            st <= S0;
            out <= 1'b0;
          end
        end
        S3: begin
          if (in) begin
            st <= S1;
            out <= 1'b1;
          end
          else begin
            st <= S2;
            out <= 1'b0;
          end
        end        
      endcase
    end
  end
endmodule

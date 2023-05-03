module loadable_bidir_counter(
  input wire clk,
  input wire rst,
  input wire load_valid,
  input wire [3:0] load,
  input wire dir,
  output logic [3:0] out);
  
  always@(posedge clk or negedge rst) begin
    if (~rst) begin
      if (dir) begin
        out <= 4'b0000;
      end
      else begin
        out <= 4'hF;
      end
      else begin
        if (load_valid) begin
          out <= out_next;
        end
        else if (dir )begin
          out <= out + 4'b001;
        end
        else if (dir) begin
          out <= out - 4'b001;
      end
    end
  end
endmodule 

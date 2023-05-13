// Code your design here
module fifo#(parameter DEPTH = 16,
             parameter WIDTH = 16)(
  	input logic clk,
  	input logic rst,
  	input logic push_i,
    input logic [WIDTH-1:0] push_data_i,
  	input logic pop_i,
    output logic [WIDTH-1:0] pop_data_i,
    output logic fifo_full,
    output logic fifo_empty);
  
  
  localparam addr_bits = $clog2(DEPTH);
  localparam PUSH_ONLY = 2'b10;
  localparam POP_ONLY = 2'b01;
  localparam PUSH_AND_POP = 2'b11;
  
  logic [DEPTH-1:0][WIDTH-1:0] mem_queue;
  logic [addr_bits:0] rd_ptr, wr_ptr, max_index_ptr, min_index_ptr;

  assign max_index_ptr = {1'b1,{addr_bits{1'b0}}};
  assign min_index_ptr = {addr_bits+1{1'b0}};
  
  assign fifo_full = (rd_ptr[addr_bits] != wr_ptr[addr_bits] ) && (rd_ptr[addr_bits-1:0] == wr_ptr[addr_bits-1:0] );
  assign fifo_empty = (rd_ptr == wr_ptr);
  
  always@(posedge clk) begin
    if (rst) begin
      rd_ptr <= {addr_bits+1{1'b0}};
      wr_ptr <= {addr_bits+1{1'b0}};
    end
    else begin
      case({push_i,pop_i})
        PUSH_ONLY: begin
          mem_queue[wr_ptr] <= push_data_i;          
          if (wr_ptr == max_index_ptr) begin
            wr_ptr <= {addr_bits+1{1'b0}};
          end
          else begin
            wr_ptr <= wr_ptr + {{addr_bits{1'b0}},1'b1};
          end
        end
        
        POP_ONLY: begin 
          pop_data_i <= mem_queue[rd_ptr];
          if (rd_ptr == max_index_ptr) begin
            rd_ptr <= {addr_bits+1{1'b0}};
          end
          else begin
          	rd_ptr <= rd_ptr + {{addr_bits{1'b0}},1'b1};
          end
        end
        
        PUSH_AND_POP: begin
          mem_queue[wr_ptr] <= push_data_i;
          pop_data_i <= mem_queue[rd_ptr];
          if (wr_ptr == max_index_ptr) begin
            wr_ptr <= {addr_bits+1{1'b0}};
          end
          else begin
            wr_ptr <= wr_ptr + {{addr_bits{1'b0}},1'b1};
          end    
          if (rd_ptr == max_index_ptr) begin
            rd_ptr <= {addr_bits+1{1'b0}};
          end
          else begin
          	rd_ptr <= rd_ptr + {{addr_bits{1'b0}},1'b1};
          end        
        end
      endcase
    end
  end
endmodule
  

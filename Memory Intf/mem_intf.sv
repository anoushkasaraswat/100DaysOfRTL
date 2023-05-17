module mem_intf(
  input wire clk,
  input wire rst,
  input wire req_vld,
  input wire req_rnw, //request read = 1,  request write = 0
  input wire [3:0] req_addr,
  input wire [31:0] wdata,
  output wire req_rdy,
  output logic [31:0] rdata);
  
  logic [15:0][31:0] mem_array;
  wire memread;
  wire memset;
  wire fifo_full;
  assign memread = req_vld && req_rnw;
  assign memset = req_vld && (~req_rnw);
  
  logic [3:0] count = 0;
  logic pop_entry;
  always@(posedge clk) begin
    if (rst) begin
      count <= 0;
    end
    else begin
      count <= count + 1;
    end
  end
  assign pop_entry = (count==4'hF)?1:0;
  
  fifo#(4,32) f1(.clk(clk),.rst(rst),.push_i(~req_rnw),.push_data_i(wdata),.pop_i(pop_entry),.pop_data_i(),.fifo_full(fifo_full),.fifo_empty());
  
  assign req_rdy = ~fifo_full;
  
  always@(posedge clk) begin
    if (rst) begin
      rdata <= 32'h0;
    end
    else if (req_rdy && memread) begin
      rdata <= mem_array[req_addr];
    end
  end
  
  always@(posedge clk) begin
    if (rst) begin
      mem_array[req_addr] <= 32'h0;
    end
    else if (req_rdy && memset) begin
      mem_array[req_addr] <= wdata;
    end
  end
        
endmodule

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
  logic [addr_bits:0] rd_ptr, wr_ptr, nxt_rd_ptr, nxt_wr_ptr;
  logic [addr_bits:0] max_index_ptr, min_index_ptr;


  assign max_index_ptr = {1'b1,{addr_bits{1'b0}}};
  assign min_index_ptr = {addr_bits+1{1'b0}};
  
  assign fifo_full = (rd_ptr[addr_bits] != wr_ptr[addr_bits] ) && (rd_ptr[addr_bits-1:0] == wr_ptr[addr_bits-1:0] );
  assign fifo_empty = (rd_ptr == wr_ptr);
  
  assign nxt_rd_ptr = (rd_ptr == max_index_ptr)?{addr_bits+1{1'b0}}:rd_ptr + {{addr_bits{1'b0}},1'b1};
  assign nxt_wr_ptr = (wr_ptr == max_index_ptr)?{addr_bits+1{1'b0}}:wr_ptr + {{addr_bits{1'b0}},1'b1};
    
  
  always@(posedge clk) begin
    if (rst) begin
      rd_ptr <= {addr_bits+1{1'b0}};
      wr_ptr <= {addr_bits+1{1'b0}};
    end
    else begin
      case({push_i,pop_i})
        PUSH_ONLY: begin
          mem_queue[wr_ptr] <= push_data_i;          
		  wr_ptr <= nxt_wr_ptr;
        end
        
        POP_ONLY: begin 
          pop_data_i <= mem_queue[rd_ptr];
          rd_ptr <= nxt_rd_ptr;
        end
        
        PUSH_AND_POP: begin
          mem_queue[wr_ptr] <= push_data_i;
          pop_data_i <= mem_queue[rd_ptr];
          wr_ptr <= nxt_wr_ptr;
          rd_ptr <= nxt_rd_ptr;
        end
      endcase
    end
  end
endmodule
  

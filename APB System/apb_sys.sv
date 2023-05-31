module apb_sys(
  input wire clk,
  input wire rst,
  input wire rd_i,     
  input wire wr_i,     
  output wire rd_valid,   
  output wire [31:0] rdata
);
  
  logic rd_gnt;
  logic wr_gnt; //write gets higher priority than reads
  

  fixed_pri_arbiter#(2) arb (.req_i({wr_i, rd_i}),.grant_i({wr_gnt, rd_gnt}));
  
  logic push_i;
  logic [1:0] push_data_i;
  logic [1:0] pop_data_i;
  logic pop_i;
  logic fifo_empty;
  logic fifo_full;
  logic psel;
  logic penable;
  logic [31:0] paddr;
  logic pwrite;
  logic [31:0] pwdata;
  logic [31:0] prdata;
  logic pready;
  
  assign push_i = rd_gnt | wr_gnt;
  assign push_data_i = {wr_gnt,rd_gnt};
  
  fifo#(16,32) ff(.clk(clk),.rst(rst),.push_i(push_i),.push_data_i(push_data_i),.pop_i(pop_i),.pop_data_i(pop_data_i),.fifo_full(fifo_full),.fifo_empty(fifo_empty));
  
  assign pop_i = ~(penable & psel) & ~(fifo_empty);
  
  apb_master am(.clk(clk),.rst(rst),.cmd(pop_data_i),.pready(pready),.prdata(prdata),.psel(psel),.penable(penable),.paddr(paddr),.pwrite(pwrite),.pwdata(pwdata));
  
  apb_slave as(.clk(clk),.rst(rst),.psel(psel),.penable(penable),.paddr(paddr),.pwrite(pwrite),.pwdata(pwdata),.prdata(prdata),.pready(pready));

  assign rd_valid = ~pwrite & pready;
  assign rdata = prdata;
  
endmodule


module fixed_pri_arbiter#(parameter REQUESTERS = 4)(
  input wire [REQUESTERS-1:0] req_i,
  output wire [REQUESTERS-1:0] grant_i);
  
  assign grant_i[0] = req_i[0]?1:0; // Bit0 has highest priority
  
  generate
    genvar i;
    for(i=1;i<REQUESTERS;i=i+1) begin
      assign grant_i[i] = req_i[i] & ~(|req_i[i-1:0]);
    end
  endgenerate
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
  
module apb_master(
  input wire clk,
  input wire rst,
  input wire [1:0] cmd,
  input wire pready,
  input wire [31:0] prdata,
  output logic psel,
  output logic penable,
  output logic [31:0] paddr,
  output logic pwrite,
  output logic [31:0] pwdata);
  
  typedef enum logic[1:0]
  {
    IDLE=2'b00, SETUP=2'b01, ACCESS=2'b10
  } apb_state;
  
  apb_state st;
  apb_state nxt_state;
  localparam const_addr = 32'h0;
  localparam const_data = 32'hFACECAFE;
  logic [31:0] rdata;
  logic apb_access_state; 
  logic apb_setup_state; 
  logic [31:0] nxt_rdata;
  logic nxt_pwrite;
  
  assign apb_access_state = (st == ACCESS);
  assign apb_setup_state = (st == SETUP);
  
  //next state logic
  always@(*) begin
    nxt_state = st;
    nxt_pwrite = pwrite; //prevents unintended latch inference
    nxt_rdata = rdata;
    case(st)
      IDLE: begin
        if (|cmd) begin
          nxt_state = SETUP;
          nxt_pwrite = cmd[1];
        end
      end
      SETUP: begin
        nxt_state = ACCESS;
      end
      ACCESS: begin
        if (pready) begin
          nxt_state = IDLE;
          if (~pwrite) begin
            nxt_rdata = prdata;
          end
        end
      end
    endcase
  end            
  
  //present state logic
  always@(posedge clk) begin
    if (rst) begin
      st <= IDLE;
    end
    else begin
      st <= nxt_state;  
    end
  end
  
  //select and enable control signals
  assign psel = apb_setup_state || apb_access_state;
  assign penable = apb_access_state;
  
  //address
  assign paddr = {32{apb_access_state}} & const_addr;
  
  //pwrite
  always@(posedge clk) begin
    if (rst) begin
      pwrite <= 1'b0;
    end
    else begin
      pwrite <= nxt_pwrite;
    end
  end
  
  assign pwdata = {32{pwrite}} & {32{apb_access_state}} & (rdata + 32'h1);
  
  always@(posedge clk) begin
    if(rst) begin
      rdata <= 0;
    end
    else if (pready && penable) begin
      rdata <= nxt_rdata;
    end
  end
endmodule
        
module apb_slave(
  input wire clk,
  input wire rst,
  input wire psel,
  input wire penable,
  input wire[3:0] paddr,
  input wire pwrite,
  input wire[31:0] pwdata,
  output logic [31:0] prdata,
  output wire pready);
  
  wire req_vld;
  assign req_vld = penable & psel;
  mem_intf m(.clk(clk),.rst(rst),.req_vld(req_vld),.req_rnw(~pwrite),.req_addr(paddr),.wdata(pwdata),.req_rdy(pready),.rdata(prdata));
  
endmodule

module mem_intf(
  input wire clk,
  input wire rst,
  input wire req_vld,
  input wire req_rnw, //request read = 1,  request write = 0
  input wire [3:0] req_addr,
  input wire [31:0] wdata,
  output wire req_rdy,
  output logic [31:0] rdata);
  
  logic [31:0] mem_array [15:0];
  wire memread;
  wire memset;
  wire fifo_full;
  assign memread = req_vld && req_rnw;
  assign memset = req_vld && (~req_rnw);
  
  logic [2:0] count = 3'h0;
  logic pop_entry;
  always@(posedge clk) begin
    if (rst) begin
      count <= 3'h0;
    end
    else begin
      count <= count + 3'h1;
    end
  end
  
  //assert rdy when count is 8
  assign req_rdy = (count==3'h7)?1:0;
 
  always@(posedge clk) begin
    if (rst) begin
      rdata <= 32'h0;
    end
    else if (req_rdy && memread) begin
      rdata <= mem_array[req_addr];
    end
  end
  
  //assign rdata = mem_array[req_addr] & {32{memread}};
  
  always@(posedge clk) begin
    if (rst) begin
      mem_array[req_addr] <= 32'hFACECAFE;
    end
    else if (req_rdy && memset) begin
      mem_array[req_addr] <= wdata;
    end
  end
  
  integer i; //dump memory array into waveform
  initial begin
    for (i = 0; i < 16; i = i + 1) begin 
      $dumpvars(0, mem_array[i]);
    end
  end 
        
endmodule

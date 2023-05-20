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
  assign req_rdy = (count==3'h8)?1:0;
 
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
      mem_array[req_addr] <= 32'h0;
    end
    else if (req_rdy && memset) begin
      mem_array[req_addr] <= wdata;
    end
  end
  
/*  integer i; //dump memory array into waveform
  initial begin
    for (i = 0; i < 16; i = i + 1) begin 
      $dumpvars(0, mem_array[i]);
    end
  end*/ 
        
endmodule

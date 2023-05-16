//cmd[1:0] = 2'b01 // read
//cmd[1:0] = 2'b10 // write

// Code your design here
module apb_master(
  input wire clk,
  input wire rst_n,
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
  localparam const_addr = 32'hABCDEFAB;
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
    if (~rst_n) begin
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
    if (~rst_n) begin
      pwrite <= 1'b0;
    end
    else begin
      pwrite <= nxt_pwrite;
    end
  end
  
  assign pwdata = {32{apb_access_state}} & (rdata + 32'h1);
  
  always@(posedge clk) begin
    if(~rst_n) begin
      rdata <= 32'h0;
    end
    else if (pready && penable) begin
      rdata <= nxt_rdata;
    end
  end
endmodule

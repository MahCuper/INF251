module statem(input clk,reset,modo, output nrc);
reg[1:0] state;
parameter r0=2'd0, r1 = 2'd1, c0 = 2'd2, c1 = 2'd3;
assign nrc = (state == r0 || state == r1);
always @(posedge clk or negedge reset)
     begin
          if (reset==0)
               state = r0;
          else
               case (state)
                    r0:
                      if ( modo == 1'b1 ) state = r1;
                    r1:
                      if ( modo == 1'b0 ) state = c0;
                    c0:
                      if ( modo == 1'b1 ) state = c1;
                    c1:
                      if ( modo == 1'b0 ) state = r0;
               endcase
     end
endmodule
module count99(input clk, input rst, output [6:0] Count, output loop);  reg [6:0] Count;
  always @ (posedge clk or negedge rst)
begin
  if (~rst) 
    Count <= 0;   // reset register
  else if ( Count == 99 ) 
    Count <= 0; 
  else
    Count <= Count + 1;  // increment register
end
  assign loop = (Count == 99);
endmodule

module count59(input clk, input rst, output [6:0] Count, output loop);  reg [6:0] Count;
  always @ (posedge clk or negedge rst)
begin
  if (~rst) 
    Count <= 0;   // reset register
  else if ( Count == 59 ) 
    Count <= 0; 
  else
    Count <= Count + 1;  // increment register
end
assign loop = (Count == 59);
endmodule

module count23(input clk, input rst, output [6:0] Count);  reg [6:0] Count;
always @ (posedge clk or negedge rst)
begin
  if (~rst) 
    Count <= 0;   // reset register
  else if ( Count == 23 ) 
    Count <= 0; 
  else
    Count <= Count + 1;  // increment register
end
endmodule

module relogio(input clk, rst,modo, mais,menos, output [6:0] h,m,s);
wire outs,outs1,routs,routs1;
wire enable,nr;
  wire [6:0] cc,sc,mc,sr,mr,hr;
assign enable = mais & clk;
assign nr = menos & rst;

count99 cen(enable,nr,cc,outs);
count59 seg(~outs,nr,sc,outs1);
count59 min(~outs1,nr,mc);
count59 rseg(clk,rst,sr,routs);
count59 rmin(~routs,rst,mr,routs1);
count23 rhor(~routs1,rst,hr);
  assign h = (nrc)?hr:mc;
  assign m = (nrc)?mr:sc;
  assign s = (nrc)?sr:cc;
  wire nrc;
  statem maq(clk,rst,modo,nrc);
endmodule

module top(input clk, rst,modo, mais,menos, output [6:0] h,m,s);
  relogio r(clk,rst,modo,mais,menos,h,m,s);
endmodule
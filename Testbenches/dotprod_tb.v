`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.02.2022 13:06:44
// Design Name: 
// Module Name: dotprod_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dot_prod_tb #(parameter XLEN_PIXEL = 8 , parameter NUM_OF_PIXELS = 900);
  reg clk, rst;
  reg [XLEN_PIXEL-1 : 0] x_test; 
  reg[XLEN_PIXEL-1 : 0] x_sv;
  wire [4*XLEN_PIXEL -1 : 0] mac_out;
  integer i;
  
dot_prod uut(.clk(clk),.rst(rst), .x_test(x_test), .x_sv(x_sv), .mac_out(mac_out)); 
always #10 clk = ~clk;

initial begin
rst = 1;
clk = 0;
#20
rst = 0;

for (i=0; i<NUM_OF_PIXELS; i=i+1)
begin
#25
x_test = 8'b00000000;
x_sv = 8'b00000001;

#30
x_test = 8'b00000011;
x_sv = 8'b00000001;

#35
x_test = 8'b00000100;
x_sv = 8'b00000001;

#40
x_test = 8'b00000101;
x_sv = 8'b00000010;

#45
x_test = 8'b00000110;
x_sv = 8'b00000010;

#50
x_test = 8'b00000111;
x_sv = 8'b00000010;
end

end


endmodule

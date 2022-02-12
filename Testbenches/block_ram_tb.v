`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2022 11:00:47
// Design Name: 
// Module Name: block_ram_tb
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


module block_ram_tb;
reg clk, we, re; 
parameter SIZE = 1024;
parameter ADDR_WIDTH = 10;
parameter DATA_WIDTH = 8;
reg [ADDR_WIDTH-1:0] addr;
reg [DATA_WIDTH-1:0] di;
wire [DATA_WIDTH-1:0] do;

block_ram uut(.clk(clk), .we(we), .re(re), .addr(addr), .di(di), .do(do));
initial begin 
clk = 0;
di = 8'b11110000;
we = 1;
re = 0;
addr = 10'b0000000001;
#15 we = 0;
re = 1;
#30 we = 1;
re =0;
addr = 10'b0000000100;
di = 8'b00001111;
#45 we = 0;
re = 1;
#55 addr = 10'b1111111011;
end
always
#10 clk = ~clk;
endmodule

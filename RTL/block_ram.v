`timescale 1ns / 1ps
(* bram_map = "yes" *) module block_ram (clk, we, re, addr, di, do);
parameter SIZE = 1024;
parameter ADDR_WIDTH = 10;
parameter DATA_WIDTH = 8;

input clk;
integer i;
input we, re;
input [ADDR_WIDTH-1:0] addr; //address
input [DATA_WIDTH-1:0] di; //di- data input
output reg [DATA_WIDTH-1:0] do; //do - data output
reg [DATA_WIDTH-1:0] RAM [SIZE-1:0];

initial begin
    for(i=0; i<SIZE; i=i+1) begin
        RAM[i] = 0;
    end
end

always @(posedge clk)
begin
    if(re) begin 
    do <= RAM[addr];
    end
    else if(we) begin 
    RAM[addr] <= di;
    end
end 
endmodule
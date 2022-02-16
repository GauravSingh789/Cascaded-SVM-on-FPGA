`timescale 1ns / 1ps
(* bram_map = "yes" *) module block_ram (clk, we, re, addr, di, do);
parameter SIZE = 1024;
parameter ADDR_WIDTH = 10;
parameter XLEN_PIXEL = 8;

input clk;
integer i;
input we, re;
input [ADDR_WIDTH-1:0] addr; //address
input  [XLEN_PIXEL-1:0] di; //di- data input
output reg  [XLEN_PIXEL-1:0] do; //do - data output
reg  [XLEN_PIXEL-1:0] RAM [SIZE-1:0];
integer j;

initial begin
    for(i=0; i<SIZE; i=i+1) begin
        RAM[i] = 0;
    end
end

always @(posedge clk)
begin
    if(re) begin 
    do <= RAM[addr];
    //$display("hello i'm ram output, do=%d ram[addr]=%d addr=%d", do, RAM[addr], addr);
    end
    if(we) begin 
    RAM[addr] <= di;
    //$display("hello i'm ram, di=%d ram[addr]=%d addr=%d", di, RAM[addr], addr);
    end
    //for(j=0; j<6; j=j+1) begin
    //    $display("RAM[%0d] = %0d", j, RAM[j]);
    //end
end 
endmodule
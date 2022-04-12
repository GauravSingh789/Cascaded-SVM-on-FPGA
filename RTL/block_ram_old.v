`timescale 1ns / 1ps
(* bram_map = "yes" *) module block_ram #(parameter SIZE = 1024, parameter ADDR_WIDTH = 10, parameter XLEN_PIXEL = 8)
( input clk, we, re, stall_MEM,
input [ADDR_WIDTH-1:0] addr_read, 
input [ADDR_WIDTH-1:0] addr_write,
input [XLEN_PIXEL-1:0] di,
output reg [XLEN_PIXEL-1:0] do);

reg stall_check;
reg [XLEN_PIXEL-1:0] data_in;
always @(*) begin
stall_check <= stall_MEM;
data_in <= di;
end

reg  [XLEN_PIXEL-1:0] RAM [SIZE-1:0];
integer j;
integer i;

initial begin
    for(i=0; i<SIZE; i=i+1) begin
        RAM[i] = 0;
    end
end

always @(*)
begin
    if(re && !(stall_check)) begin 
    do = RAM[addr_read];
    //$display("hello i'm ram output, do=%d ram[addr]=%d addr=%d", do, RAM[addr_read], addr_read);
    end
    if(we && (stall_check)) begin 
    RAM[addr_write] = di;
    //$display("hello i'm ram, di=%d ram[addr]=%d addr=%d", di, RAM[addr_write], addr_write);
    end
    //for(j=0; j<6; j=j+1) begin
    //    $display("RAM[%0d] = %0d", j, RAM[j]);
    //end
end 
endmodule
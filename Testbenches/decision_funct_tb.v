`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.02.2022 10:40:40
// Design Name: 
// Module Name: decision_funct_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// `
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module decision_funct_tb #(parameter XLEN_PIXEL = 8, parameter NUM_OF_PIXELS =4, parameter NUM_OF_SV = 2, parameter DECISION_FUNCT_SIZE = 48);

reg clk, decision_funct_en;
reg [0:4*XLEN_PIXEL*NUM_OF_SV-1] kernel_out;
wire [0:5*XLEN_PIXEL-1] kernel_out_temp;
reg [(2*XLEN_PIXEL)-1:0] product;
reg [(2*XLEN_PIXEL)-1:0] b;
wire y_class;
reg out;
decision_funct uut(.clk(clk), .kernel_out(kernel_out), .decision_funct_en(decision_funct_en), .product(product), .b(b), .y_class(y_class)); 
always #5 clk = ~clk;
initial begin
    clk = 1;
    decision_funct_en = 0;
    #20
    decision_funct_en = 1;
    kernel_out = 64'b0111_1111_1111_1111_1111_1111_1111_1111_0000_0000_0000_0000_0000_0000_0000_0010;
    product = 16'b00000000_00000001;
    b = 16'b00000000_00000100;
    #5
    product = product+1;
end

endmodule

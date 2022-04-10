`timescale 1ns / 1ps
///this module stores log2(1-2^i) in 32.8 format
module log_mod #(parameter XLEN_PIXEL = 8 , parameter NUM_OF_PIXELS =4, parameter ITERATOR = 8)
(input clk, input [3:0] i, output reg [2*XLEN_PIXEL-1:0] log_val);
always@(posedge clk) begin
    case(i) 
        4'b0001 : log_val = 16'b1000000100000000; //1
        4'b0010 : log_val = 16'b1000000001101010; //2
        4'b0011 : log_val = 16'b1000000000110001; //3
        4'b0100 : log_val = 16'b1000000000010111; //4
        4'b0101 : log_val = 16'b1000000000001011; //5
        4'b0110 : log_val = 16'b1000000000000101; //6
        4'b0111 : log_val = 16'b1000000000000010; //7
        4'b1000 : log_val = 16'b1000000000000001; //8
        4'b1001 : log_val = 16'b1000000000000000; //9
        4'b1010 : log_val = 16'b1000000000000000; //10
        default : log_val = 16'b0000000000000000; 
    endcase
end
endmodule

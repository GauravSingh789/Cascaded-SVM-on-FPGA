`timescale 1ns / 1ps

module hwf_kernel #(parameter XLEN_PIXEL = 8 , parameter NUM_OF_PIXELS =4, parameter ITERATOR = 8)
( input clk, rst, stall_MEM,
  input signed [XLEN_PIXEL-1:0] Bi, //Bi in the hwf expression
  input [XLEN_PIXEL-1:0] x_test, 
  input [XLEN_PIXEL-1:0] x_sv,
  output reg signed [XLEN_PIXEL-1: 0] Ei_next,
  output reg signed [XLEN_PIXEL-1:0] Bi_next);

reg [XLEN_PIXEL-1:0] x_test_arr;
reg [XLEN_PIXEL-1:0] x_sv_arr;

wire gamma;
reg stall_check;
reg c_done;
integer sum_index = ITERATOR;
reg di;

reg signed [XLEN_PIXEL-1:0] Ei, //Ei in the HWF expression
reg signed [XLEN_PIXEL-1:0] norm_temp;
reg signed [XLEN_PIXEL-1:0] temp_sub1; //Temporary register to store subtraction result for checking sign in norm calc
reg signed [XLEN_PIXEL-1:0] temp_sub2;
reg signed [XLEN_PIXEL-1:0] log_val; // Dummy log value register for now

integer k;
initial begin
    norm_temp = 0;
    k=0;
end

assign gamma = 1;

always @(*) begin
    stall_check <= stall_MEM;
    x_test_arr <= x_test;
    x_sv_arr <= x_sv;
    //$display("x_test_arr = %d",x_test_arr);
    //$display("x_sv_arr = %d", x_sv_arr);
end
//--------------- Computing Ei-----------------------------------
always @(posedge clk or posedge rst) begin
    if (rst) begin
    Ei <= 0;
    k <= 0;
    c_done <= 0;
    end
    if(!(stall_check)) begin
        temp_sub = x_sv_arr - x_test_arr;
        if(temp_sub[XLEN_PIXEL-1] == 1'b0) begin
            norm_temp <= norm_temp + temp_sub;
        end else begin
            norm_temp <= norm_temp - temp_sub;
        end
        c_done <= (k == NUM_OF_PIXELS) ? 1 : 0;
        k <= c_done ? k : k + 1;
    end
end
always @(posedge c_done) begin
    Ei <= gamma*norm_temp;
end

//--- Ei part of the block diagram-----------------------------------
always @(posedge clk) begin
    temp_sub2 <= Ei - log_val;
    di <= temp_sub2[0] ? 1 : 0;
    Ei_next <= di ? temp_sub2 : Ei;
end

//-------------Computing Bi/beta : TO DO-----------------------------


 //----- Bi part of block diagram -----------------------------------
always @(posedge clk) begin
    //Arithmetic shift in Bi by i
    if(sum_index) begin
    Bi_next = di ? (Bi - (Bi >>> sum_index)) : Bi - 0; // Mux and subtractor
    sum_index = sum_index - 1;
    end
end
endmodule

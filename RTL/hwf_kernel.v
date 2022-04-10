`timescale 1ns / 1ps

module hwf_kernel #(parameter XLEN_PIXEL = 8 , parameter NUM_OF_PIXELS =4, parameter NUM_OF_SV=87, parameter ITERATOR = 8)
( input clk, rst, stall_MEM,
  input [2*XLEN_PIXEL-1:0] Bi, //Bi in the hwf expression
  input [XLEN_PIXEL-1:0] x_test, 
  input [XLEN_PIXEL-1:0] x_sv,
  output reg [2*XLEN_PIXEL-1: 0] hwf_out);

reg [XLEN_PIXEL-1:0] x_test_arr;
reg [XLEN_PIXEL-1:0] x_sv_arr;

wire gamma;
reg stall_check;
reg c_done;
reg hwf_done;
integer sum_index = 0;
reg di;

reg [XLEN_PIXEL-1:0] Ei; //Ei in the HWF expression , 8.8 format size
reg [2*XLEN_PIXEL-1:0] Ei_FixedPoint;
reg [XLEN_PIXEL-1:0] norm_temp;
reg [XLEN_PIXEL-1:0] temp_sub; //Temporary register to store subtraction result for checking sign in norm calc
reg [XLEN_PIXEL-1:0] temp_sub2;
reg [XLEN_PIXEL-1:0] log_val; // Dummy log value register for now
reg [2*XLEN_PIXEL-1:0] Ei_next;
reg [2*XLEN_PIXEL-1:0] Bi_next;

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
log_mod log_module_hwf (.clk(clk), .i(sum_index), .log_val(log_val)); //Instantiating log module
always @(posedge clk) begin
    Ei_FixedPoint <= {Ei, 8'b00000000};
    temp_sub2 <= Ei_FixedPoint - log_val;
    di <= temp_sub2[XLEN_PIXEL-1] ? 1 : 0;
    Ei_next <= di ? temp_sub2 : Ei;
end
 //----- Bi part of block diagram -----------------------------------
always @(posedge clk) begin
    //Arithmetic shift in Bi by i
    if(sum_index < ITERATOR) begin
    Bi_next = di ? (Bi - (Bi >>> sum_index)) : Bi - 0; // Mux and subtractor
    sum_index = sum_index + 1;
    end
    hwf_done <= (j == ITERATOR) ? 1 : 0;
    j <= hwf_done ? j : j + 1;
end
always@(posedge hwf_done) begin
    hwf_out = Bi_next;
end

endmodule

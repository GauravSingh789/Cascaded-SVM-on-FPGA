`timescale 1ns / 1ps

module hwf_kernel #(parameter XLEN_PIXEL = 8 , parameter NUM_OF_PIXELS =10, parameter NUM_OF_SV=10, parameter ITERATOR = 8)
( input clk, rst, stall_MEM,
  input [2*XLEN_PIXEL-1:0] Bi, //Bi in the hwf expression
  input [XLEN_PIXEL-1:0] x_test, 
  input [XLEN_PIXEL-1:0] x_sv,
  output [2*XLEN_PIXEL-1: 0] hwf_out);

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
wire [2*XLEN_PIXEL-1:0] temp_sub2;
wire [2*XLEN_PIXEL-1:0] log_val; // Dummy log value register for now
reg [2*XLEN_PIXEL-1:0] Ei_next;
reg [2*XLEN_PIXEL-1:0] Bi_next;

integer k,j;
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
always @(posedge clk) begin
    if (rst) begin
    Ei <= 0;
    k <= 0;
    norm_temp <=0; 
    temp_sub <= 0;
    c_done <= 0;
    j<=0;
    hwf_done<=0;
    end

    if(!(stall_check) && !(c_done)) begin
        temp_sub <= (x_sv_arr >= x_test_arr) ? (x_sv_arr - x_test_arr) : (x_test_arr - x_sv_arr);
        norm_temp <= norm_temp + temp_sub;
        /*temp_sub = x_sv_arr - x_test_arr;
        if(temp_sub[XLEN_PIXEL-1] == 1'b0) begin
            norm_temp <= norm_temp + temp_sub;
        end else begin
            norm_temp <= norm_temp - temp_sub;
        end*/
        $display("x_sv = %d,x_test =%d, temp_sub = %d, norm_temp = %d, c_done=%d, k=%d",x_sv_arr, x_test_arr, temp_sub, norm_temp, c_done, k);
        c_done <= (k == NUM_OF_PIXELS) ? 1 : 0;
        k <= c_done ? k : k + 1;
    end
end
always @(posedge c_done) begin
    Ei = gamma*norm_temp;
    $display("Ei=%d gamma=%d",Ei,gamma);
end

//--- Ei part of the block diagram-----------------------------------
log_mod log_module_hwf (.clk(clk), .i(sum_index), .log_val(log_val)); //Instantiating log module
fixed_pt_sub sub(.a(Ei_FixedPoint), .b(log_val), .out(temp_sub2));
always @(posedge clk && c_done && !(hwf_done)) begin
    Ei_FixedPoint <= {Ei, 8'b00000000};
    $display("Ei_fixedpoint=%d, logval=%d, temp_sub2=%d",Ei_FixedPoint, log_val,temp_sub2);
    di <= temp_sub2[2*XLEN_PIXEL-1] ? 1 : 0;
    Ei_next <= di ? temp_sub2 : Ei_FixedPoint;
end
 //----- Bi part of block diagram -----------------------------------
always @(posedge clk && c_done && !(hwf_done)) begin
    //Arithmetic shift in Bi by i
    if(sum_index < ITERATOR) begin
    Bi_next = di ? (Bi - (Bi >>> sum_index)) : (Bi - 0); // Mux and subtractor
    sum_index = sum_index + 1;
    $display("sum_index=%d Bi=%d Bi_next=%d di=%d",sum_index,Bi,Bi_next,di);
    j = hwf_done ? j : j + 1;
    hwf_done = (j == ITERATOR) ? 1 : 0;
    $display("hwf_done=%d j=%d",hwf_done,j);
    end
end
//always@(hwf_done) begin
//    $display("helo im last loop hwf_done=%d j=%d",hwf_done,j);
    assign hwf_out = hwf_done ? Bi_next : 8'b11111111;
//end

endmodule

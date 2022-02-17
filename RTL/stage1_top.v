`timescale 1ns / 1ps

module stage1_top #(parameter XLEN_PIXEL = 8, parameter NUM_OF_PIXELS = 4, parameter NUM_OF_SV = 100)
(input clk, rst, en,
output y_class);

wire re, we, stall_MEM;
// Variables we are storing in BRAM
wire [XLEN_PIXEL-1:0] sv_load1, sv_load2;
wire [XLEN_PIXEL-1 :0] x_test; 

//Fetched stuff from BRAM
wire [XLEN_PIXEL-1 :0] x_sv1;
wire [XLEN_PIXEL-1 :0] x_sv2;
wire [XLEN_PIXEL-1 :0] x_sv3;
wire [XLEN_PIXEL-1 :0] x_sv4;
wire [XLEN_PIXEL-1 :0] x_sv5;
wire [XLEN_PIXEL-1 :0] x_sv6;
wire [XLEN_PIXEL-1 :0] x_sv7;
wire [XLEN_PIXEL-1 :0] x_sv8;
wire [XLEN_PIXEL-1 :0] x_sv9;
wire [XLEN_PIXEL-1 :0] x_sv10;
wire [XLEN_PIXEL-1 :0] x_testdata_fetched; 

// Instantiate control module
mem_control mem_control_inst (.clk(clk), .rst (rst), .en(en), .re(re), .we(we), .stall_MEM(stall_MEM), .sv_load1(sv_load1), .sv_load2(sv_load2), .x_test(x_test));

// Load support vectors from RAM

RAM_fetch x_sv_fetch1 (.clk(clk), .re(re), .we(re), .stall_MEM(stall_MEM), .data_load(sv_load1), .data_out(x_sv1));
RAM_fetch x_sv_fetch2 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2), .data_out(x_sv2));
RAM_fetch x_sv_fetch3 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2), .data_out(x_sv3));
RAM_fetch x_sv_fetch4 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2), .data_out(x_sv4));
RAM_fetch x_sv_fetch5 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2), .data_out(x_sv5));
RAM_fetch x_sv_fetch6 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2), .data_out(x_sv6));
RAM_fetch x_sv_fetch7 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2), .data_out(x_sv7));
RAM_fetch x_sv_fetch8 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2), .data_out(x_sv8));
RAM_fetch x_sv_fetch9 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2), .data_out(x_sv9));
RAM_fetch x_sv_fetch10 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2), .data_out(x_sv10));

// Load test vector from RAM
RAM_fetch x_test_fetch1 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(x_test), .data_out(x_testdata_fetched));

// Output from each Dsp/Mac slice

wire [0:4*XLEN_PIXEL-1] kernel_out_sv1;
wire [0:4*XLEN_PIXEL-1] kernel_out_sv2;
wire [0:4*XLEN_PIXEL-1] kernel_out_sv3;
wire [0:4*XLEN_PIXEL-1] kernel_out_sv4;
wire [0:4*XLEN_PIXEL-1] kernel_out_sv5;
wire [0:4*XLEN_PIXEL-1] kernel_out_sv6;
wire [0:4*XLEN_PIXEL-1] kernel_out_sv7;
wire [0:4*XLEN_PIXEL-1] kernel_out_sv8;
wire [0:4*XLEN_PIXEL-1] kernel_out_sv9;
wire [0:4*XLEN_PIXEL-1] kernel_out_sv10;

//Instantiate dot_prod logic. In each cycle, dot prod for one pixel computed
 
    dot_prod dspslice1(.clk(clk), .rst(rst), .stall_MEM(stall_MEM), .x_test(x_testdata_fetched), .x_sv(x_sv1), .mac_out(kernel_out_sv1));
    dot_prod dspslice2(.clk(clk), .rst(rst), .stall_MEM(stall_MEM), .x_test(x_testdata_fetched), .x_sv(x_sv2), .mac_out(kernel_out_sv2));
    dot_prod dspslice3(.clk(clk), .rst(rst), .stall_MEM(stall_MEM), .x_test(x_testdata_fetched), .x_sv(x_sv3), .mac_out(kernel_out_sv3));
    dot_prod dspslice4(.clk(clk), .rst(rst), .stall_MEM(stall_MEM), .x_test(x_testdata_fetched), .x_sv(x_sv4), .mac_out(kernel_out_sv4));
    dot_prod dspslice5(.clk(clk), .rst(rst), .stall_MEM(stall_MEM), .x_test(x_testdata_fetched), .x_sv(x_sv5), .mac_out(kernel_out_sv5));
    dot_prod dspslice6(.clk(clk), .rst(rst), .stall_MEM(stall_MEM), .x_test(x_testdata_fetched), .x_sv(x_sv6), .mac_out(kernel_out_sv6));
    dot_prod dspslice7(.clk(clk), .rst(rst), .stall_MEM(stall_MEM), .x_test(x_testdata_fetched), .x_sv(x_sv7), .mac_out(kernel_out_sv7));
    dot_prod dspslice8(.clk(clk), .rst(rst), .stall_MEM(stall_MEM), .x_test(x_testdata_fetched), .x_sv(x_sv8), .mac_out(kernel_out_sv8));
    dot_prod dspslice9(.clk(clk), .rst(rst), .stall_MEM(stall_MEM), .x_test(x_testdata_fetched), .x_sv(x_sv9), .mac_out(kernel_out_sv9));
    dot_prod dspslice10(.clk(clk), .rst(rst), .stall_MEM(stall_MEM), .x_test(x_testdata_fetched), .x_sv(x_sv10), .mac_out(kernel_out_sv10));

//Shifting values across registers
reg [0:4*XLEN_PIXEL*NUM_OF_PIXELS-1] kernel_out;

always @(posedge clk or posedge rst && en) begin 
    /*if (rst) begin
        kernel_out_sv10 <= 0;
    end
    for (i=0; i < NUM_OF_SV; i=i+1) begin
        if (comp_count >= (NUM_OF_PIXELS*NUM_OF_SV + 25)) begin
            kernel_out_sv2[0:4*XLEN_PIXEL-1] <= kernel_out_sv1[0:4*XLEN_PIXEL-1];
            kernel_out_sv3[0:4*XLEN_PIXEL-1] <= kernel_out_sv2[0:4*XLEN_PIXEL-1];
            kernel_out_sv4[0:4*XLEN_PIXEL-1] <= kernel_out_sv3[0:4*XLEN_PIXEL-1];
            kernel_out_sv5[0:4*XLEN_PIXEL-1] <= kernel_out_sv4[0:4*XLEN_PIXEL-1];
            kernel_out_sv6[0:4*XLEN_PIXEL-1] <= kernel_out_sv5[0:4*XLEN_PIXEL-1];
            kernel_out_sv7[0:4*XLEN_PIXEL-1] <= kernel_out_sv6[0:4*XLEN_PIXEL-1];
            kernel_out_sv8[0:4*XLEN_PIXEL-1] <= kernel_out_sv7[0:4*XLEN_PIXEL-1];
            kernel_out_sv9[0:4*XLEN_PIXEL-1] <= kernel_out_sv8[0:4*XLEN_PIXEL-1];
            kernel_out_sv10[0:4*XLEN_PIXEL-1] <= kernel_out_sv9[0:4*XLEN_PIXEL-1];
        end
    end */
    kernel_out[0:4*XLEN_PIXEL-1] <= kernel_out_sv1[0:4*XLEN_PIXEL-1];
    kernel_out[4*XLEN_PIXEL:4*2*XLEN_PIXEL-1]   <= kernel_out_sv2[0:4*XLEN_PIXEL-1];
    kernel_out[4*2*XLEN_PIXEL:4*3*XLEN_PIXEL-1] <= kernel_out_sv3[0:4*XLEN_PIXEL-1];
    kernel_out[4*3*XLEN_PIXEL:4*4*XLEN_PIXEL-1] <= kernel_out_sv4[0:4*XLEN_PIXEL-1];
    kernel_out[4*4*XLEN_PIXEL:4*5*XLEN_PIXEL-1] <= kernel_out_sv5[0:4*XLEN_PIXEL-1];
    kernel_out[4*5*XLEN_PIXEL:4*6*XLEN_PIXEL-1] <= kernel_out_sv6[0:4*XLEN_PIXEL-1];
    kernel_out[4*6*XLEN_PIXEL:4*7*XLEN_PIXEL-1] <= kernel_out_sv7[0:4*XLEN_PIXEL-1];
    kernel_out[4*7*XLEN_PIXEL:4*8*XLEN_PIXEL-1] <= kernel_out_sv8[0:4*XLEN_PIXEL-1];
    kernel_out[4*8*XLEN_PIXEL:4*9*XLEN_PIXEL-1] <= kernel_out_sv9[0:4*XLEN_PIXEL-1];

    //$display("Big reg out = %d", kernel_out);
end
assign y_class = 1; // Temp dummy line to run the tb

endmodule

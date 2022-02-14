`timescale 1ns / 1ps

module stage1_top #(parameter XLEN_PIXEL = 8, parameter NUM_OF_PIXELS = 30, parameter NUM_OF_SV = 10)
(input clk, rst, en,
output y_class);

reg [XLEN_PIXEL-1:0] x_test;

reg [XLEN_PIXEL-1 :0] x_sv1;
reg [XLEN_PIXEL-1 :0] x_sv2;
reg [XLEN_PIXEL-1 :0] x_sv3;
reg [XLEN_PIXEL-1 :0] x_sv4;
reg [XLEN_PIXEL-1 :0] x_sv5;
reg [XLEN_PIXEL-1 :0] x_sv6;
reg [XLEN_PIXEL-1 :0] x_sv7;
reg [XLEN_PIXEL-1 :0] x_sv8;
reg [XLEN_PIXEL-1 :0] x_sv9;
reg [XLEN_PIXEL-1 :0] x_sv10;

integer comp_count;

// <------------->Instantiate RAM_Fetch module here to get x_test and x_sv(n) <----------->
// <----------->  Fetch test vector <----------------------------------------------------->

// Storing each Dsp slice output in a register
reg [4*XLEN_PIXEL-1:0] kernel_out_sv1;
reg [4*XLEN_PIXEL-1:0] kernel_out_sv2;
reg [4*XLEN_PIXEL-1:0] kernel_out_sv3;
reg [4*XLEN_PIXEL-1:0] kernel_out_sv4;
reg [4*XLEN_PIXEL-1:0] kernel_out_sv5;
reg [4*XLEN_PIXEL-1:0] kernel_out_sv6;
reg [4*XLEN_PIXEL-1:0] kernel_out_sv7;
reg [4*XLEN_PIXEL-1:0] kernel_out_sv8;
reg [4*XLEN_PIXEL-1:0] kernel_out_sv9;
reg [4*XLEN_PIXEL-1:0] kernel_out_sv10;

//Instantiate dot_prod logic. In each cycle, dot prod for one pixel computed  
    dot_prod dspslice1(.clk(clk), .rst(rst), .x_test(x_test), .x_sv(x_sv1), .mac_out(kernel_out_sv1));
    dot_prod dspslice2(.clk(clk), .rst(rst), .x_test(x_test), .x_sv(x_sv2), .mac_out(kernel_out_sv2));
    dot_prod dspslice3(.clk(clk), .rst(rst), .x_test(x_test), .x_sv(x_sv3), .mac_out(kernel_out_sv3));
    dot_prod dspslice4(.clk(clk), .rst(rst), .x_test(x_test), .x_sv(x_sv4), .mac_out(kernel_out_sv4));
    dot_prod dspslice5(.clk(clk), .rst(rst), .x_test(x_test), .x_sv(x_sv5), .mac_out(kernel_out_sv5));
    dot_prod dspslice6(.clk(clk), .rst(rst), .x_test(x_test), .x_sv(x_sv6), .mac_out(kernel_out_sv6));
    dot_prod dspslice7(.clk(clk), .rst(rst), .x_test(x_test), .x_sv(x_sv7), .mac_out(kernel_out_sv7));
    dot_prod dspslice8(.clk(clk), .rst(rst), .x_test(x_test), .x_sv(x_sv8), .mac_out(kernel_out_sv8));
    dot_prod dspslice9(.clk(clk), .rst(rst), .x_test(x_test), .x_sv(x_sv9), .mac_out(kernel_out_sv9));
    dot_prod dspslice10(.clk(clk), .rst(rst), .x_test(x_test), .x_sv(x_sv10), .mac_out(kernel_out_sv10));

always @(posedge clk) begin

        comp_count = comp_count + 1;
end

//Shifting values across registers
always @(posedge clk or posedge rst && en) begin 
    if (rst) begin
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
    end
end    

endmodule

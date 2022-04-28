`timescale 1ns / 1ps
module stage1_top_hwf #(parameter XLEN_PIXEL = 8, parameter NUM_OF_PIXELS = 4, parameter NUM_OF_SV = 10)
(input clk, rst, en, 
output y_class);

wire re, we, stall_MEM, decision_funct_en;
// Variables we are storing in BRAM
wire [XLEN_PIXEL-1:0] sv_load1, sv_load2;
wire [XLEN_PIXEL-1 :0] x_test; 
wire [XLEN_PIXEL-1 :0] coeff_alpha; 

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

//HWF Kernel output
wire [0:2*XLEN_PIXEL-1] kernel_out_sv1;
wire [0:2*XLEN_PIXEL-1] kernel_out_sv2;
wire [0:2*XLEN_PIXEL-1] kernel_out_sv3;
wire [0:2*XLEN_PIXEL-1] kernel_out_sv4;
wire [0:2*XLEN_PIXEL-1] kernel_out_sv5;
wire [0:2*XLEN_PIXEL-1] kernel_out_sv6;
wire [0:2*XLEN_PIXEL-1] kernel_out_sv7;
wire [0:2*XLEN_PIXEL-1] kernel_out_sv8;
wire [0:2*XLEN_PIXEL-1] kernel_out_sv9;
wire [0:2*XLEN_PIXEL-1] kernel_out_sv10;

// Instantiate control module
mem_control mem_control_inst (.clk(clk), .rst(rst), .en(en), .re(re), .we(we), .stall_MEM(stall_MEM), 
.decision_funct_en(decision_funct_en), .sv_load1(sv_load1), .sv_load2(sv_load2), .x_test(x_test));

// -------Hardware Friendly Kernel----------------------------------------
//Load alpha_values for HWF
reg [2*XLEN_PIXEL-1:0] alpha_values [86:0];
reg [2*XLEN_PIXEL-1:0] Bi; //Bi for HWF compuation
reg [6:0] alpha_values_counter;

initial begin
    $readmemb("E:/CURRICULUM/ECE Core/8th sem/FYP/Vivado files/FYP_SVM_on_FPGA/FYP_SVM_on_FPGA.sim/sim_1/behav/xsim/alpha_bin.data", alpha_values, 0, 86);
    alpha_values_counter=7'b0000000;
end
always @(posedge clk) begin
Bi <= alpha_values[alpha_values_counter];
alpha_values_counter = alpha_values_counter + 1;
if(alpha_values_counter == 7'b1010110) begin
    alpha_values_counter=7'b0000000;
end

$display("TOP HERE - Bi = %d",alpha_values[alpha_values_counter]);
end 

// Load support vectors from RAM
/*RAM_fetch_SV x_sv_fetch1 (.clk(clk), .re(re), .we(re), .stall_MEM(stall_MEM), .data_out(x_sv1));
RAM_fetch_SV x_sv_fetch2 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_out(x_sv2));
RAM_fetch_SV x_sv_fetch3 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_out(x_sv3));
RAM_fetch_SV x_sv_fetch4 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_out(x_sv4));
RAM_fetch_SV x_sv_fetch5 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_out(x_sv5));
RAM_fetch_SV x_sv_fetch6 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_out(x_sv6));
RAM_fetch_SV x_sv_fetch7 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_out(x_sv7));
RAM_fetch_SV x_sv_fetch8 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_out(x_sv8));
RAM_fetch_SV x_sv_fetch9 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_out(x_sv9));
RAM_fetch_SV x_sv_fetch10 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_out(x_sv10));*/

RAM_fetch x_sv_fetch1 (.clk(clk), .re(re), .we(re), .stall_MEM(stall_MEM), .data_load(sv_load1),.data_out(x_sv1));
RAM_fetch x_sv_fetch2 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2),.data_out(x_sv2));
RAM_fetch x_sv_fetch3 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2),.data_out(x_sv3));
RAM_fetch x_sv_fetch4 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2),.data_out(x_sv4));
RAM_fetch x_sv_fetch5 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2),.data_out(x_sv5));
RAM_fetch x_sv_fetch6 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2),.data_out(x_sv6));
RAM_fetch x_sv_fetch7 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2),.data_out(x_sv7));
RAM_fetch x_sv_fetch8 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2),.data_out(x_sv8));
RAM_fetch x_sv_fetch9 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2),.data_out(x_sv9));
RAM_fetch x_sv_fetch10 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(sv_load2),.data_out(x_sv10));

// Load test vector from RAM
//RAM_fetch_SV x_test_fetch1 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_out(x_testdata_fetched));
RAM_fetch x_test_fetch1 (.clk(clk), .re(re), .we(we), .stall_MEM(stall_MEM), .data_load(x_test), .data_out(x_testdata_fetched));

//Instantiating HWF Kernel modules
hwf_kernel hwf_kernel_inst1(.clk(clk), .rst(rst), .stall_MEM(stall_MEM), .Bi(Bi), .x_test(x_test), .x_sv(x_sv1), .hwf_out(kernel_out_sv1));
hwf_kernel hwf_kernel_inst2(.clk(clk), .rst(rst), .stall_MEM(stall_MEM),.Bi(Bi), .x_test(x_test), .x_sv(x_sv2), .hwf_out(kernel_out_sv2));
hwf_kernel hwf_kernel_inst3(.clk(clk), .rst(rst), .stall_MEM(stall_MEM),.Bi(Bi), .x_test(x_test), .x_sv(x_sv3), .hwf_out(kernel_out_sv3));
hwf_kernel hwf_kernel_inst4(.clk(clk), .rst(rst), .stall_MEM(stall_MEM),.Bi(Bi), .x_test(x_test), .x_sv(x_sv4), .hwf_out(kernel_out_sv4));
hwf_kernel hwf_kernel_inst5(.clk(clk), .rst(rst), .stall_MEM(stall_MEM),.Bi(Bi), .x_test(x_test), .x_sv(x_sv5), .hwf_out(kernel_out_sv5));
hwf_kernel hwf_kernel_inst6(.clk(clk), .rst(rst), .stall_MEM(stall_MEM),.Bi(Bi), .x_test(x_test), .x_sv(x_sv6), .hwf_out(kernel_out_sv6));
hwf_kernel hwf_kernel_inst7(.clk(clk), .rst(rst), .stall_MEM(stall_MEM),.Bi(Bi), .x_test(x_test), .x_sv(x_sv7), .hwf_out(kernel_out_sv7));
hwf_kernel hwf_kernel_inst8(.clk(clk), .rst(rst), .stall_MEM(stall_MEM),.Bi(Bi), .x_test(x_test), .x_sv(x_sv8), .hwf_out(kernel_out_sv8));
hwf_kernel hwf_kernel_inst9(.clk(clk), .rst(rst), .stall_MEM(stall_MEM),.Bi(Bi), .x_test(x_test), .x_sv(x_sv9), .hwf_out(kernel_out_sv9));
hwf_kernel hwf_kernel_inst10(.clk(clk), .rst(rst), .stall_MEM(stall_MEM),.Bi(Bi), .x_test(x_test), .x_sv(x_sv10),.hwf_out(kernel_out_sv10));

//Shifting values across registers
reg [(2*XLEN_PIXEL*NUM_OF_SV)-1:0] hwf_kernel_out;

always @(posedge clk) begin //or posedge rst && en) begin 

    hwf_kernel_out[2*XLEN_PIXEL-1:0] <= kernel_out_sv1[0:2*XLEN_PIXEL-1];
    hwf_kernel_out[2*2*XLEN_PIXEL-1:2*XLEN_PIXEL]   <= kernel_out_sv2[0:2*XLEN_PIXEL-1];
    hwf_kernel_out[2*3*XLEN_PIXEL-1:2*2*XLEN_PIXEL] <= kernel_out_sv3[0:2*XLEN_PIXEL-1];
    hwf_kernel_out[2*4*XLEN_PIXEL-1:2*3*XLEN_PIXEL] <= kernel_out_sv4[0:2*XLEN_PIXEL-1];
    hwf_kernel_out[2*5*XLEN_PIXEL-1:2*4*XLEN_PIXEL] <= kernel_out_sv5[0:2*XLEN_PIXEL-1];
    hwf_kernel_out[2*6*XLEN_PIXEL-1:2*5*XLEN_PIXEL] <= kernel_out_sv6[0:2*XLEN_PIXEL-1];
    hwf_kernel_out[2*7*XLEN_PIXEL-1:2*6*XLEN_PIXEL] <= kernel_out_sv7[0:2*XLEN_PIXEL-1];
    hwf_kernel_out[2*8*XLEN_PIXEL-1:2*7*XLEN_PIXEL] <= kernel_out_sv8[0:2*XLEN_PIXEL-1];
    hwf_kernel_out[2*9*XLEN_PIXEL-1:2*8*XLEN_PIXEL] <= kernel_out_sv9[0:2*XLEN_PIXEL-1];
    hwf_kernel_out[2*10*XLEN_PIXEL-1:2*9*XLEN_PIXEL] <= kernel_out_sv10[0:2*XLEN_PIXEL-1];

$display("Kernel big reg out = %d", hwf_kernel_out);
end
//-------------------------------Decision Function Module--------------------------------- 
reg [XLEN_PIXEL-1:0] product_load;
wire[XLEN_PIXEL-1:0] product_out;
reg [(2*XLEN_PIXEL)-1:0] b = 16'b10000000_00000001;
reg [(2*XLEN_PIXEL)-1:0] product;
//Product values for testing 
initial begin 
    product = 16'b00000000_00000000;
end
always@(posedge clk) begin
    product <= product+1;
end

RAM_fetch product_fetch(.clk(clk), .re(re), .we(re), .stall_MEM(!decision_funct_en), .data_load(product_load), .data_out(product_out));
decision_funct_hwf decision_funct_module(.clk(clk), .kernel_out(hwf_kernel_out), .decision_funct_en(decision_funct_en), 
            .product(product), .b(b), .y_class(y_class));

endmodule

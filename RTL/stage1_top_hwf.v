`timescale 1ns / 1ps
module stage1_top_hwf #(parameter XLEN_PIXEL = 8, parameter NUM_OF_PIXELS = 784, parameter NUM_OF_SV = 10)
(input clk, rst, en, 
output y_class);

wire re, we, stall_MEM, decision_funct_en;
wire [XLEN_PIXEL-1:0] x_test;
// Instantiate control module
mem_control_hwf mem_control_inst (.clk(clk), .rst(rst), .en(en), .re(re), .we(we), .stall_MEM(stall_MEM), .decision_funct_en(decision_funct_en), 
.x_test(x_test));

// -------Hardware Friendly Kernel----------------------------------------
//Load alpha_values for HWF
reg [2*XLEN_PIXEL-1:0] alpha_values [NUM_OF_SV-1:0];
reg [2*XLEN_PIXEL-1:0] Bi; //Bi for HWF compuation
reg [6:0] alpha_values_counter;

initial begin
    $readmemb("D:/Acads/SEMESTERS/Sem 8/FYP - SVM/Verilog implementation/SVM_on_FPGA/SVM_on_FPGA.srcs/alpha_hwf_bin.data", alpha_values, 0,9);
    alpha_values_counter=7'b0000000;
end

/*always @(posedge clk) begin
Bi <= alpha_values[alpha_values_counter];
alpha_values_counter = alpha_values_counter + 1;
if(alpha_values_counter == 7'b1010110) begin
    alpha_values_counter=7'b0000000;
end
$display("TOP HERE - Bi = %d",alpha_values[alpha_values_counter]);
end */

// Load support vectors from RAM
reg [NUM_OF_PIXELS*XLEN_PIXEL-1:0] support_vectors [NUM_OF_SV-1:0];
reg [16:0] support_vectors_counter;
initial begin
    $readmemb("D:/Acads/SEMESTERS/Sem 8/FYP - SVM/Verilog implementation/SVM_on_FPGA/SVM_on_FPGA.srcs/sources_1/new/support_vect_bin_hwf_edited.data", support_vectors, 0, 9);
    support_vectors_counter=17'b0_00000000_00000000;
end

genvar c;
genvar i;
generate for(c = 0; c < NUM_OF_SV; c = c + 1) begin
    for(i=0;i<NUM_OF_PIXELS;i=i+1) begin
        hwf_kernel hwf_kernel_inst1(.clk(clk), .rst(rst), .stall_MEM(stall_MEM), .Bi(alpha_values[c]), .x_test(x_test), .x_sv(support_vectors[c]), .hwf_out(hwf_kernel_out[(c*2*XLEN_PIXEL) +: 2*XLEN_PIXEL]), .c(c));
    end
end endgenerate 

//Instantiating HWF Kernel modules

//Shifting values across registers
wire [(2*XLEN_PIXEL*NUM_OF_SV)-1:0] hwf_kernel_out;

always @(posedge clk) begin //or posedge rst && en) begin 
//$display("Kernel big reg out = %d", hwf_kernel_out);
//$display("x_sv=%d", support_vectors[7]);
end
//-------------------------------Decision Function Module--------------------------------- 
reg [XLEN_PIXEL-1:0] product_load;
wire[XLEN_PIXEL-1:0] product_out;
reg [(2*XLEN_PIXEL)-1:0] b = 16'b10000000_00000001;
reg [(2*XLEN_PIXEL)-1:0] product_arr [NUM_OF_SV-1:0];
reg [(2*XLEN_PIXEL)-1:0] product;
integer row_count;

//Product values for testing 
initial begin
    $readmemb("D:/Acads/SEMESTERS/Sem 8/FYP - SVM/Verilog implementation/SVM_on_FPGA/SVM_on_FPGA.srcs/sources_1/new/alpha_bin.data",product_arr,0,9);
    row_count = 0;
end

//Product values
always@(posedge clk) begin
    if(row_count<NUM_OF_SV && decision_funct_en) begin
        product = product_arr[row_count];
        row_count = row_count+1;
        //$display("product=%d row_count=%d", product, row_count); 
    end
end

//RAM_fetch product_fetch(.clk(clk), .re(re), .we(re), .stall_MEM(!decision_funct_en), .data_load(product_load), .data_out(product_out));
decision_funct_hwf decision_funct_module(.clk(clk), .kernel_out(hwf_kernel_out), .decision_funct_en(decision_funct_en), 
            .product(product), .b(b), .y_class(y_class));

endmodule

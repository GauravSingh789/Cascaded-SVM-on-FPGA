`timescale 1ns / 1ps

module stage1_top #(parameter XLEN_PIXEL = 8, parameter NUM_OF_PIXELS = 784, parameter NUM_OF_SV = 87, parameter DECISION_FUNCT_SIZE = 56)
(input clk, rst, en,
output y_class);

wire re, we, stall_MEM, decision_funct_en;
// Variables we are storing in BRAM
//wire [XLEN_PIXEL-1:0] sv_load1, sv_load2; 

// Instantiate control module
mem_control mem_control_inst (.clk(clk), .rst (rst), .en(en), .re(re), .we(we), .stall_MEM(stall_MEM), .x_test(x_test), .decision_funct_en(decision_funct_en));

// Load support vectors from RAM
reg [NUM_OF_PIXELS*XLEN_PIXEL-1:0] support_vectors [NUM_OF_SV-1:0];
reg [4*XLEN_PIXEL-1:0] kernel_out_arr [NUM_OF_SV-1:0];
reg [16:0] support_vectors_counter;
integer i,j;
initial begin
    $readmemb("E:/CURRICULUM/ECE Core/8th sem/FYP/Vivado files/FYP_SVM_on_FPGA/FYP_SVM_on_FPGA.srcs/support_vect_bin_edited.data", support_vectors,0,86);
    support_vectors_counter=17'b0_00000000_00000000;
    //for(i=0;i<NUM_OF_SV-1;i=i+1) begin
    //    $display("support_vectors=%b",support_vectors[i]);
    //end
end

//Instantiating kernel modules for each support vector
genvar c;
generate for(c = 0; c < NUM_OF_SV; c = c + 1) begin
    dot_prod dspslice1(.clk(clk), .rst(rst), .stall_MEM(stall_MEM), .x_test(x_test), .x_sv(support_vectors[c]), .mac_out(kernel_out[(c*5*XLEN_PIXEL) +: 5*XLEN_PIXEL]));//kernel_out_arr[c]));//
end endgenerate 

//Main register containing output from all kernel modules
wire [((5*XLEN_PIXEL*NUM_OF_SV)-1):0] kernel_out;

//-------------------------------Decision Function Module--------------------------------- 
reg [XLEN_PIXEL-1:0] product_load;
wire[XLEN_PIXEL-1:0] product_out;
reg [(2*XLEN_PIXEL)-1:0] b = 16'b10000000_00000001;
reg [(2*XLEN_PIXEL)-1:0] product_arr [NUM_OF_SV-1:0];
reg [(2*XLEN_PIXEL)-1:0] product;
integer row_count;

//Product values
always@(posedge clk) begin
    if(row_count<NUM_OF_SV && decision_funct_en) begin
        product = product_arr[row_count];
        row_count = row_count+1;
        //$display("product=%d row_count=%d", product, row_count); 
    end
end
initial begin
    $readmemb("E:/CURRICULUM/ECE Core/8th sem/FYP/Vivado files/FYP_SVM_on_FPGA/FYP_SVM_on_FPGA.srcs/product_bin.data",product_arr,0,86);
    row_count = 0;
end

//RAM_fetch product_fetch(.clk(clk), .re(re), .we(re), .stall_MEM(!decision_funct_en), .data_load(product_load), .data_out(product_out));
decision_funct decision_funct_module(.clk(clk), .kernel_out(kernel_out), .decision_funct_en(decision_funct_en), 
            .product(product), .b(b), .decision_funct_out(decision_funct_out), .y_class(y_class));

endmodule

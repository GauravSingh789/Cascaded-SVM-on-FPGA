`timescale 1ns / 1ps

module cascade_top#(parameter XLEN_PIXEL = 8, parameter NUM_OF_PIXELS = 784, parameter NUM_OF_TEST_VECTORS = 10, parameter DECISION_FUNCT_SIZE = 56)
(input clk, rst, en,
output y_class1,
output y_class2
);

reg [NUM_OF_PIXELS*XLEN_PIXEL-1:0] x_test [0:0];
reg hwf_en;

reg [DECISION_FUNCT_SIZE-1:0] decision_val;
wire [DECISION_FUNCT_SIZE-1:0] decision_funct_out;

always @(*) begin
   decision_val <= decision_funct_out;
end

initial begin
    $readmemb("E:/CURRICULUM/ECE Core/8th sem/FYP/Vivado files/FYP_SVM_on_FPGA/FYP_SVM_on_FPGA.srcs/test_pics_bin_1.data", x_test, 0, 0);
    hwf_en = 0;
end

stage1_top stage1_polynomial_kernel(.clk(clk),.rst(rst), .en(en), .x_test(x_test[0]), .decision_funct_out(decision_funct_out), .y_class(y_class1));

always @(posedge clk) begin
   //$display ("Decision Val = %d", decision_funct_out);
 if(decision_val[DECISION_FUNCT_SIZE-2:0] < 1) begin
    hwf_en = 1;
 end else begin
    hwf_en = 0;
 end
end

stage1_top_hwf stage2_hwf_kernel(.clk(clk), .rst(rst), .en(en), .x_test(x_test[0]), .y_class(y_class2), .hwf_en(hwf_en));

endmodule

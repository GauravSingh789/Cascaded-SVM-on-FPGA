`timescale 1ns / 1ps

module hwf_kernel_tb #(parameter XLEN_PIXEL = 8 , parameter NUM_OF_PIXELS =4, parameter NUM_OF_SV=87, parameter ITERATOR = 8);

reg clk, rst, stall_MEM;
reg [2*XLEN_PIXEL-1:0] Bi;
reg [XLEN_PIXEL-1:0] x_test, x_sv;
reg [2*XLEN_PIXEL-1:0] alpha_values[NUM_OF_SV-1:0];
wire [2*XLEN_PIXEL-1: 0] hwf_out; 
reg [6:0] i;

hwf_kernel uut( .clk(clk), .rst(rst), .stall_MEM(stall_MEM), .Bi(Bi), .x_test(x_test), .x_sv(x_sv), 
  .hwf_out(hwf_out));

always #10 clk = ~clk;

initial begin
    $readmemb("alpha_bin.txt", alpha_values);
    i = 0;
end

initial begin
rst = 1;
clk = 0;
stall_MEM = 1;
#20
rst = 0;
stall_MEM = 0;
x_test = 8'b00000001;
x_sv = 8'b00000000;

for (i=0; i<NUM_OF_PIXELS; i=i+1)
begin
#20
x_test = x_test + 8'b00000001;
x_sv = x_sv + 8'b00000001;
if (x_test== 8'b11111111) begin
  x_test = 8'b00000000; end
if (x_sv == 8'b11111111) begin
  x_sv = 8'b00000000; end

end
end

always@(posedge clk) begin
    Bi <= alpha_values[i];
    i = i+1;
end
endmodule

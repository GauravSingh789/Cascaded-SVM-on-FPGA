`timescale 1ns / 1ps

module RAM_fetch_tb #(parameter XLEN_PIXEL=8, NUM_OF_PIXELS = 900);
reg [XLEN_PIXEL-1:0] data_load;
wire [XLEN_PIXEL-1:0] data_out;
reg re,we,clk;
integer i;

RAM_fetch uut(.clk(clk), .re(re), .we(we), .data_load(data_load), .data_out(data_out));

always #5 clk = ~clk;
initial begin
clk = 0;
re = 0;
we = 0;
for(i=0; i<5; i=i+1) begin
    #15 we = 1;
    data_load = i;
end
we = 0;
#10 re = 1;
end
endmodule

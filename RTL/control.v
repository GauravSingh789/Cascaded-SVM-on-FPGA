`timescale 1ns / 1ps

module mem_control #(parameter XLEN_PIXEL = 8, parameter NUM_OF_PIXELS = 784, parameter NUM_OF_SV = 10)
(input clk, rst, en,
output reg re, we, stall_MEM, 
output reg [XLEN_PIXEL-1:0]x_test,
output reg decision_funct_en);

reg [31:0] comp_count;
integer i=0;
//reg [XLEN_PIXEL-1:0] sv_load1, sv_load2;
initial begin
    re =0;
    we =1;
    comp_count=0;
    stall_MEM =0;
    decision_funct_en=0;
    x_test = 20;
    //sv_load1 = 13;
    //sv_load2 = 17;

end
//reg [XLEN_PIXEL-1:0] sv_load1;
//reg [XLEN_PIXEL-1:0] sv_load2;

//------------ SV Values for time being------------
/*always @(posedge clk) begin
    sv_load1 <= sv_load1+1;
    sv_load2 <= sv_load2+3;
    x_test <= x_test + 1;

    if(sv_load1 > 255) begin
        sv_load1 <= 0;
    end
    if(sv_load2 > 255) begin
        sv_load2 <=0;
    end
    if(x_test > 15) begin
        x_test <=10;
    end    */
    //$display ("x_test = %d", x_test);
    //$display ("sv_load1 = %d", sv_load1);
    //$display ("sv_load2 = %d", sv_load2);
//end
//-----------------------------------------------------

always @(posedge clk)begin
    if(rst) begin
        re <=0;
        we <=1;
        stall_MEM <=1;
    end else if(comp_count < NUM_OF_PIXELS+10) begin
        re <=0;
        we <=1;
        stall_MEM <=1;
    end else begin
    re <=1;
    we <=0;
    stall_MEM <=0;
    decision_funct_en <=1;
    end
    //$display("comp_count=%d stall_MEM = %d", comp_count, stall_MEM);
end

always @(posedge clk) begin

        comp_count <= comp_count + 1;
        //$display("comp_count = %d",comp_count);
end
endmodule

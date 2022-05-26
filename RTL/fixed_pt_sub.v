`timescale 1ns / 1ps
//A-B
module fixed_pt_sub#(parameter XLEN_PIXEL = 8)
(input [2*XLEN_PIXEL-1:0] a, input [2*XLEN_PIXEL-1:0] b, output reg [2*XLEN_PIXEL-1:0] out);
reg a_sign;
reg b_sign, comp;
reg [2*XLEN_PIXEL-2:0] a_val;
reg [2*XLEN_PIXEL-2:0] b_val, result_temp;

always@(*) begin
a_sign = a[2*XLEN_PIXEL-1];
b_sign = b[2*XLEN_PIXEL-1];
a_val = a[2*XLEN_PIXEL-2:0];
b_val = b[2*XLEN_PIXEL-2:0];
comp = a_val>b_val;
//$display("comp=%d",comp);
if(a_sign == 0 && b_sign ==0) begin
    result_temp = comp ? (a_val-b_val) : (b_val - a_val);
    out = {comp, result_temp};
end
else if(a_sign==1 && b_sign==0) begin
    result_temp = a_val+b_val;
    out = {1'b1,result_temp};
end
else if(a_sign==0 && b_sign==1) begin
    result_temp = a_val+b_val;
    out = {1'b0,result_temp};
end
else if(a_sign==1 && b_sign==1) begin //-A+B
    result_temp = comp ? (a_val-b_val) : (b_val - a_val);
    out = {comp,result_temp};
end else
    out = 0;

end

endmodule

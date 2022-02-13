`timescale 1ns / 1ps

module dot_prod_tb #(parameter XLEN_PIXEL = 8 , parameter NUM_OF_PIXELS = 30);
  reg clk, rst;
  reg [NUM_OF_PIXELS*XLEN_PIXEL-1 : 0] x_test; 
  reg [NUM_OF_PIXELS*XLEN_PIXEL-1 : 0] x_sv;
  wire [4*XLEN_PIXEL -1 : 0] mac_out;
  integer i;
  
dot_prod uut(.clk(clk),.rst(rst), .x_test(x_test), .x_sv(x_sv), .mac_out(mac_out)); 
always #10 clk = ~clk;

initial begin
rst = 1;
clk = 0;
#20
rst = 0;
x_test = 8'b00000000;
x_sv = 8'b00000001;

for (i=0; i<NUM_OF_PIXELS; i=i+1)
begin
#20
x_test = x_test + 8'b00000001;
x_sv = x_sv + 8'b00000001;
if (x_test== 8'b11111111) begin
  x_test = 8'b00000000; end
if (x_sv == 8'b11111111) begin
  x_sv = 8'b00000000; end

//#30
//x_test = 8'b00000011;
//x_sv = 8'b00000001;

//#35
//x_test = 8'b00000100;
//x_sv = 8'b00000001;

//#40
//x_test = 8'b00000101;
//x_sv = 8'b00000010;

//#45
//x_test = 8'b00000110;
//x_sv = 8'b00000010;

//#50
//x_test = 8'b00000111;
//x_sv = 8'b00000010;

end
end

endmodule

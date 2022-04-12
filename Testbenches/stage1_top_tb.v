`timescale 1ns / 1ps


module stage1_top_tb #(parameter XLEN_PIXEL = 8, parameter NUM_OF_PIXELS = 4, parameter NUM_OF_SV = 10);
  reg clk, rst, en;
  wire y_class;

stage1_top_hwf uut (.clk(clk), .rst(rst), .en(en), .y_class(y_class));  

initial begin
    rst=1;
    clk=0;
    en=0;
    #5
    rst=0;
    en=1;
  end

  always #5 clk = ~clk;
endmodule

`timescale 1ns / 1ps
module cascade_top_tb#(parameter XLEN_PIXEL = 8, parameter NUM_OF_PIXELS = 784, parameter NUM_OF_SV = 87);
  reg clk, rst, en;
  wire y_class;

  cascade_top uut (.clk(clk), .rst(rst), .en(en), .y_class(y_class));

  initial begin
    rst=0;
    #5
    rst=1;
    clk=0;
    en=0;
    #10
    rst=0;
    en=1;
  end

  always #5 clk = ~clk;
  
endmodule

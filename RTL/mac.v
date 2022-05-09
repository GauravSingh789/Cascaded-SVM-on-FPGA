`timescale 1ns / 1ps

(* use_dsp = "yes" *) module dot_prod #(parameter XLEN_PIXEL = 8 , parameter NUM_OF_PIXELS =784)
( input clk, rst, stall_MEM, input [XLEN_PIXEL-1:0] c,
  input [(NUM_OF_PIXELS*XLEN_PIXEL)-1:0] x_test, 
  input [(NUM_OF_PIXELS*XLEN_PIXEL)-1:0] x_sv,
  output [5*XLEN_PIXEL-1: 0] mac_out); // (2^16)*2^10 = 2^26 (so, 26 bits. Taking the size as 32) (roughly 900 taken as 2^10)
  
  reg [NUM_OF_PIXELS*XLEN_PIXEL-1:0] x_test_arr;
  //reg [XLEN_PIXEL-1:0] x_sv_arr;
  reg stall_check;
  reg kat;

  always @(*) begin
   stall_check <= stall_MEM;
   x_test_arr <= x_test;
  end  
  reg [5*XLEN_PIXEL -1 : 0] result; 
  reg c_done;
  integer k,i;  
  always @(posedge clk or posedge rst)
  begin
      if (rst) begin
         result <= 0;
          k <= 0;
          c_done <= 0;
          i<=0;
          kat <= 0;
      end 
      else if(!(stall_check) && !(kat)) begin
          for(i=0;i<NUM_OF_PIXELS;i=i+1) begin
          //result  <= c_done ? result : (result + x_test_arr*x_sv[i*XLEN_PIXEL +: XLEN_PIXEL]);
          result = result + x_test_arr[i*XLEN_PIXEL +: XLEN_PIXEL]*x_sv[i*XLEN_PIXEL +: XLEN_PIXEL];
          end
          //$display("cat=%d result=%d module_num=%d", kat, result, c);
          result = (1 + result)*(1 + result);
          $display("mac_out=%d c=%d",result, c);
          kat=1;
      end
  end
  //assign kat_out = kat;
  assign mac_out = result;
    
  endmodule

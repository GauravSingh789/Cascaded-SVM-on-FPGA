`timescale 1ns / 1ps

(* use_dsp = "yes" *) module dot_prod #(parameter XLEN_PIXEL = 8 , parameter NUM_OF_PIXELS =30)
( input clk, rst,
  input [XLEN_PIXEL-1:0] x_test, 
  input [XLEN_PIXEL-1:0] x_sv,
  output [4*XLEN_PIXEL-1: 0] mac_out); // (2^16)*2^10 = 2^26 (so, 26 bits. Taking the size as 32) (roughly 900 taken as 2^10)
  reg [XLEN_PIXEL-1:0] x_test_arr;
  reg [XLEN_PIXEL-1:0] x_sv_arr;  
  // reg [XLEN_PIXEL-1:0] x_test_arr [0:NUM_OF_PIXELS-1];
 // reg [XLEN_PIXEL-1:0] x_sv_arr [0:NUM_OF_PIXELS-1];  
  reg [4*XLEN_PIXEL -1 : 0] result; 
  reg k,c_done;
  
 integer i;
 always @ (x_test)
  begin
    x_test_arr = x_test;
    $display("x_test_arr = %d",x_test_arr);
    end
     /*for (i=0; i < XLEN_PIXEL; i=i+1) begin
          x_test_arr[i] = x_test[i*(XLEN_PIXEL-1) +: (XLEN_PIXEL-1)];
          $display("x_test_arr[%d] = %d", i, x_test_arr[i]);
      end*/
 
  
  always @ (x_sv)
   begin 
    x_sv_arr = x_sv;
    $display("x_sv_arr = %d", x_sv_arr);
    end
    /*for (i=0; i < XLEN_PIXEL; i=i+1) begin
           x_sv_arr[i] = x_sv[i*(XLEN_PIXEL-1) +: (XLEN_PIXEL-1)];
           $display("x_sv_arr[%d] = %d", i, x_sv_arr[i]);
     end*/
   
  /*  always @(posedge clk or posedge rst or x_test_arr or x_sv_arr)
  begin
      if (rst) begin
         result <= 0;
          k <= 0;
          c_done <= 0;
      end else begin
          result  <= c_done ? result : (result + x_test_arr[k]* x_sv_arr[k]);
          k <= c_done ? k : k + 1;
          c_done <= c_done ? 1 : (k == NUM_OF_PIXELS);
      end
  end*/
  always @(posedge clk or posedge rst)
  begin
      if (rst) begin
         result <= 0;
          k <= 0;
          c_done <= 0;
      end else begin
          result  <= c_done ? result : (result + x_test_arr*x_sv_arr);
          $display("result rn = %d", result);
          k <= c_done ? k : k + 1;
          c_done <= (k == NUM_OF_PIXELS) ? 1 : 0;
      end
  end
  
    assign mac_out = result;
    
  endmodule

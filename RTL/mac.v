`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2022 18:46:56
// Design Name: 
// Module Name: mac
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

(* use_dsp = "yes" *) module dot_prod #(parameter DBUS_LENGTH = 16, parameter XLEN_PIXEL = 8 , parameter NUM_OF_PIXELS = 900)
( input clk, rst,
  input [DBUS_LENGTH-1 : 0] x_test,  //Doubtful on the input port size.
  input [DBUS_LENGTH-1 : 0] x_sv,
  output [2*DBUS_LENGTH -1 : 0] mac_out); // (2^16)*2^10 = 2^26 (so, 26 bits. Taking the size as 32) (roughly 900 taken as 2^10)
  
  reg [XLEN_PIXEL-1:0] x_test_arr [0:NUM_OF_PIXELS];
  reg [XLEN_PIXEL-1:0] x_sv_arr [0:NUM_OF_PIXELS];  
  reg [2*DBUS_LENGTH -1 : 0] result; 
  reg k,c_done;
  
  integer i;
  always @ (x_test)
  begin
      for (i=0; i< NUM_OF_PIXELS; i=i+1) begin
          x_test_arr[i] = x_test[i*XLEN_PIXEL +: XLEN_PIXEL];
      end
  end
  
  always @ (x_sv)
  begin 
      for (i=0; i<NUM_OF_PIXELS; i=i+1) begin
           x_sv_arr[i] = x_sv[i*XLEN_PIXEL +: XLEN_PIXEL];
      end
  
  end 
  
  always @(posedge clk or posedge rst)
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
  end
  
    assign mac_out = result;
    
  endmodule

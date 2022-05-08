`timescale 1ns / 1ps

(* use_dsp = "yes" *) module decision_funct #(parameter XLEN_PIXEL = 8, parameter NUM_OF_PIXELS =784, parameter NUM_OF_SV = 87, parameter DECISION_FUNCT_SIZE = 56)
(input clk, [(5*XLEN_PIXEL*NUM_OF_SV)-1:0] kernel_out, input decision_funct_en, [(2*XLEN_PIXEL)-1:0] product, [(2*XLEN_PIXEL)-1:0] b, 
output reg y_class); 

reg [6*XLEN_PIXEL-1:0] kernel_out_temp;   //product - 8.8, b - 8.8
reg [DECISION_FUNCT_SIZE+XLEN_PIXEL-1:0] decision_funct_out_temp; //48.16 output from multiplier
reg [DECISION_FUNCT_SIZE-1:0] decision_funct_out; //48.8 output after adding b
reg sign_b, sign_out_temp,sign_out, comp;
reg [(2*XLEN_PIXEL)-2:0] value_b;
reg [DECISION_FUNCT_SIZE-2:0] value_out;
reg [DECISION_FUNCT_SIZE+XLEN_PIXEL-2:0] value_temp;
integer i;

initial begin
    i = 0;
    kernel_out_temp = 0;
    decision_funct_out_temp = 64'b00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
end

always@(posedge clk) begin
    if(decision_funct_en) begin
        //$display("dft=%b",decision_funct_out_temp);
        if(i<NUM_OF_SV) begin
            if(i==0) begin
                decision_funct_out_temp = 64'b00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000;    
                //$display("dft=%b",decision_funct_out_temp);   
            end
            kernel_out_temp = {kernel_out[5*i*XLEN_PIXEL +: 5*XLEN_PIXEL],8'b00000000}; //part of kernel out in 40.8 format
            $display("i = %d", i);
            $display("dft=%b",decision_funct_out_temp);   
            decision_funct_out_temp = decision_funct_out_temp + (kernel_out_temp*{1'b0,product[(2*XLEN_PIXEL)-2:0]}); //40.8 * 8.8 = 48.16
            decision_funct_out_temp[DECISION_FUNCT_SIZE+XLEN_PIXEL-1] = kernel_out_temp[6*XLEN_PIXEL-1] ^ product[(2*XLEN_PIXEL)-1]; // Assigning Sign bit to output
            $display("kernel_out_temp=%h, decision_funct_out_temp=%d, product=%h", kernel_out_temp, decision_funct_out_temp, product);
            i = i+1;
        end
    end
end 

always@(posedge clk) begin
    if(i >= NUM_OF_SV) begin
        sign_b = b[(2*XLEN_PIXEL)-1];
        sign_out_temp = decision_funct_out_temp[DECISION_FUNCT_SIZE+XLEN_PIXEL-1];
        sign_out = decision_funct_out[DECISION_FUNCT_SIZE-1];
        value_temp = decision_funct_out_temp[DECISION_FUNCT_SIZE+XLEN_PIXEL-2 : 0];
        value_b = b[(2*XLEN_PIXEL)-2:0];
        value_out = decision_funct_out[DECISION_FUNCT_SIZE-2:0];
        comp <= value_temp > value_b;
        //$display("sign_b = %h, sign_out_temp = %h, sign_out=%h, value_out=%h, value_temp=%h, value_b=%h comp=%h",sign_b, sign_out_temp, sign_out, 
        //                                                        value_out, value_temp, value_b, comp);
        if(sign_b^sign_out_temp==0) begin
            value_out = value_temp  +  value_b;
            sign_out = sign_out_temp;
            decision_funct_out = {sign_out,value_out};
        //    $display("exor is 0, out=%h",decision_funct_out);
        end
        else if(sign_b^sign_out_temp == 1) begin
            value_out = value_temp - value_b;
            sign_out = comp ? sign_out_temp : sign_b;
            decision_funct_out = {sign_out, value_out};
        //    $display("exor is 1, out=%h",decision_funct_out);
        end
        y_class = sign_out ? 1 : 0;
    end
end
endmodule

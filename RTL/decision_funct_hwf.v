`timescale 1ns / 1ps

module decision_funct_hwf#(parameter XLEN_PIXEL = 8, parameter NUM_OF_PIXELS =784, parameter NUM_OF_SV = 10, parameter DECISION_FUNCT_SIZE = 24)
(input clk, [(2*XLEN_PIXEL*NUM_OF_SV)-1:0] kernel_out, input decision_funct_en, [(2*XLEN_PIXEL)-1:0] product, [(2*XLEN_PIXEL)-1:0] b, 
output reg y_class); 
reg [2*XLEN_PIXEL-1:0] kernel_out_temp;   //product - 8.8, b - 8.8
reg [DECISION_FUNCT_SIZE+XLEN_PIXEL-1:0] decision_funct_out_temp; //16.16 output from multiplier
reg [DECISION_FUNCT_SIZE-1:0] decision_funct_out; //16.8 output after adding b
reg sign_b, sign_out_temp,sign_out, comp;
reg [(2*XLEN_PIXEL)-2:0] value_b; //7.8
reg [DECISION_FUNCT_SIZE-2:0] value_out; //15.8
reg [DECISION_FUNCT_SIZE+XLEN_PIXEL-2:0] value_temp; //15.16
integer i;

initial begin
    i = 0;
    kernel_out_temp = 0;
    decision_funct_out_temp = 0;
end

always@(posedge clk) begin
    if(decision_funct_en) begin
        if(i<NUM_OF_SV) begin            
            kernel_out_temp = kernel_out[2*i*XLEN_PIXEL +: 2*XLEN_PIXEL]; //part of kernel out in 8.8 format
            i = i+1;
        //    $display("i = %d", i);
            decision_funct_out_temp = decision_funct_out_temp + (kernel_out_temp*product[(2*XLEN_PIXEL)-2:0]); //8.8 * 8.8 = 16.16
            decision_funct_out_temp[DECISION_FUNCT_SIZE+XLEN_PIXEL-1] = kernel_out_temp[2*XLEN_PIXEL-1] ^ product[(2*XLEN_PIXEL)-1]; // Assigning aign bit to output
            $display("kernel_out_temp=%h, decision_funct_out_temp=%h, product=%h", kernel_out_temp, decision_funct_out_temp, product);
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
        $display("sign_b = %h, sign_out_temp = %h, sign_out=%h, value_out=%h, value_temp=%h, value_b=%h comp=%h",sign_b, sign_out_temp, sign_out, 
                                                                value_out, value_temp, value_b, comp);
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


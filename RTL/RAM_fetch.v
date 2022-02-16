`timescale 1ns / 1ps

module RAM_fetch #(parameter XLEN_PIXEL=8, NUM_OF_PIXELS = 900, ADDR_WIDTH = 10)
    (input clk, input re, input we, input [XLEN_PIXEL-1:0] data_load, 
    output reg  [XLEN_PIXEL-1:0] data_out);
    reg [ADDR_WIDTH-1:0] addr;
    wire [XLEN_PIXEL-1:0] do;
    integer i,j;
    block_ram mem_module(.clk(clk), .we(we), .re(re), .addr(addr), .di(data_load), 
                        .do(do));
    initial begin
        i = 0;
        j = 0;
        data_out = 0;
    end
    //read the block ram 
    always@(negedge clk && re) begin
        if(i< NUM_OF_PIXELS) begin
            addr = i;
            data_out = do[XLEN_PIXEL-1 : 0];
            $display("%d = i and %d = addr data_out = %d do = %d", i,addr, data_out, do);
            i = i+1;
        end
    end
    //write data to block ram 
    always@(data_load) begin
        if (j<NUM_OF_PIXELS && we) begin
            addr = j;
            $display("%d = j and %d = addr %d = data_load", j,addr,data_load);
            j = j+1;
        end
        else begin
            addr = 0; 
            $display("memory is full or write is not enabled (j = %d)", j);
        end
    end

endmodule

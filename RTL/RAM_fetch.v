`timescale 1ns / 1ps

module RAM_fetch_SV #(parameter XLEN_PIXEL=8, NUM_OF_PIXELS = 4, ADDR_WIDTH = 10)
    (input clk, input re, stall_MEM, 
    output reg [XLEN_PIXEL-1:0] data_out);

    reg [ADDR_WIDTH-1:0] addr_read;
    //reg [ADDR_WIDTH-1:0] addr_write;
    wire [XLEN_PIXEL-1:0] do;
    integer i,j;

    reg stall_check;
    always @(*) begin
    stall_check <= stall_MEM;
    end

  //block_ram mem_module(.clk(clk), .we(we), .re(re), .stall_MEM(stall_MEM), .addr_read(addr_read), .addr_write(addr_write), .di(data_load), .do(do));
    block_ram_SV SV_mem_module(.clk(clk), .re(re), .stall_MEM(stall_MEM), .addr_read(addr_read), .do(do));

    initial begin
        i = 0;
        //j = 0;
        addr_read=0;
        //addr_write=0;
        data_out = 0;
    end
    //read the block ram 
    always@(posedge clk && re) begin
        if(i< NUM_OF_PIXELS && !(stall_check)) begin
            addr_read = i;
            data_out = do[XLEN_PIXEL-1 : 0];
            //$display("%d = i, %d = addr_read, %d = data_out , %d =do", i, addr_read, data_out, do);
            i = i+1;
        end else begin
            addr_read = 0;
        end
    end
    //write data to block ram 
    /*always@(posedge clk && stall_check) begin
        if (j < NUM_OF_PIXELS && we && stall_check) begin
            addr_write = j;
            //$display("%d = j, %d = addr_write , %d = data_load", j,addr_write,data_load);
            j = j+1;
        end else begin 
            //$display("memory is full or write is not enabled (j = %d)", j);
        end
    end */

endmodule
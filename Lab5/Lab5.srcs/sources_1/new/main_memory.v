`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 20:50:04
// Design Name: 
// Module Name: main_memory
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


module main_memory(
    input wire read_write_mem,
    input wire [9:0] address_mem,
    input wire [31:0] write_data_mem,
    output reg [31:0] read_data_mem,
    output reg Done
    );

    reg [7:0] RAM [1023:0];
    integer i;

    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            RAM[i] = 8'b0;
        end
        Done = 1'b0;
        read_data_mem = 32'b0;
    end

    always @(read_write_mem or address_mem) begin
        #2 Done = 1'b0;
        if(read_write_mem == 1'b1) begin // write in data in main memory.
            RAM[address_mem] = write_data_mem[7:0];
            RAM[address_mem + 1] = write_data_mem[15:8];
            RAM[address_mem + 2] = write_data_mem[23:16];
            RAM[address_mem + 3] = write_data_mem[31:24];
        end

        if(read_write_mem == 1'b0) begin // read data from main memory to cache.
            read_data_mem[7:0] = RAM[address_mem];
            read_data_mem[15:8] = RAM[address_mem + 1];
            read_data_mem[23:16] = RAM[address_mem + 2];
            read_data_mem[31:24] = RAM[address_mem + 3];
        end
        #2 Done = 1'b1;
    end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 21:10:21
// Design Name: 
// Module Name: top
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


module top( input clk);
    wire read_write_cache; /* 1 if write, 0 if read */
    wire hit_miss; /* 1 if hit, 0 if miss */
    wire [9:0]   address_cache;
    wire [31:0]  read_data_cache, write_data_cache;
    // interface between cache and main memory
    wire [31:0]  write_data_mem, read_data_mem;
    wire [9:0]   address_mem;
    wire read_write_mem, Done;
    // You may add the signal you need. However, you cannot change the signals above.

    Cache   Cache(read_write_cache, address_cache, write_data_cache, Done, read_data_mem, read_data_cache, hit_miss, read_write_mem, address_mem, write_data_mem);
    main_memory            mem_db(read_write_mem, address_mem, write_data_mem, read_data_mem, Done);
    CPU                 CPU_db(hit_miss, clk,read_data_cache,read_write_cache, address_cache, write_data_cache);
endmodule

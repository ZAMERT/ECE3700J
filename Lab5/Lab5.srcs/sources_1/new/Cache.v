`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/02 22:15:29
// Design Name: 
// Module Name: Cache
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


module Cache(
    input wire read_write_cache,  // 1'b1 write, 1'b0 read.
    input wire [9:0] address_cache,
    input wire[31:0] write_data_cache,
    input wire Done,
    input wire [31:0] read_data_mem,
    output reg [31:0] read_data_cache,
    output wire hit_miss,
    output reg read_write_mem,
    output reg [9:0] address_mem,
    output reg [31:0] write_data_mem
    );

    parameter block_index = 4; // 64 bytes = 16 words = 4 blocks * (4 words per block)
    parameter Tag_size = 4; // Address - Byte_offset - Word_offset - block_index.
    parameter block_width = 134; // Valid + Dirty + Tag_size + 4 * word_width.

    wire Valid;
    wire Dirty;
    wire [Tag_size-1:0] Tag;
    wire [1:0] blockIndex;
    wire [block_width-1:0] block;
    wire isTag;
    wire [1:0] Byte_offset;
    wire [1:0] Word_offset;
    reg [block_width-1:0] cache [block_index-1:0]; // 4 blocks, each 134 bits.

    integer i;
    initial begin
        read_write_mem = 0;
        address_mem = 0;
        write_data_mem = 0;
        for (i = 0; i < block_index; i = i + 1) begin
            cache[i] = 0;
        end
    end

    assign blockIndex = address_cache[5:4];
    assign block = cache[blockIndex];
    assign Valid = block[block_width-1];
    assign Dirty = block[block_width-2];
    assign Tag = block[block_width-3 : block_width-6];
    assign isTag = (Tag == address_cache[9:6]);
    assign Word_offset = address_cache[3:2];
    assign Byte_offset = address_cache[1:0];
    and(hit_miss, Valid, isTag); // If this block is valid, and the tag is same as the address in, then it is a hit. 

    always @(*) begin
        // if (Valid & isTag) hit_miss = 1;
        if(read_write_cache) begin // This is a write in instruction. sw
            if (hit_miss) begin // There is data in the cache now. Then just write in the data. 
                case (Word_offset)
                    2'b00: cache[blockIndex][31:0] = write_data_cache;
                    2'b01: cache[blockIndex][63:32] = write_data_cache;
                    2'b10: cache[blockIndex][95:64] = write_data_cache;
                    2'b11: cache[blockIndex][127:96] = write_data_cache;
                    default: cache[blockIndex] = 0;
                endcase
                cache[blockIndex][block_width-2] = 1'b1; // Set Dirty bit to dirty. 
            end

            else if (!hit_miss) begin
                if (Dirty) begin // Need to write back to Main Memory first, then change the cache. 
                    read_write_mem = 1'b1; // Write to main memory. 
                    address_mem = {{Tag, blockIndex}, {4{1'b0}}}; // Start from word0.
                    for (i = 0; i < 4; i = i + 1) begin
                        // address_mem = {Tag, blockIndex, i[1:0]};
                        case (i)
                            0: write_data_mem = block[31:0];
                            1: write_data_mem = block[63:32];
                            2: write_data_mem = block[95:64];
                            3: write_data_mem = block[127:96];
                            default: write_data_mem = 32'b0;
                        endcase
                        @(posedge Done) begin
                            address_mem = address_mem + 4;
                        end
                    end
                    #7;
                end

                // Now read from main memory
                read_write_mem = 1'b0; // Read from main memory.
                address_mem = {address_cache[9:4], {4{1'b0}}};
                for (i = 0; i < 4; i = i + 1) begin
                    @(posedge Done) begin
                        case (i)
                            0: cache[blockIndex][31:0] = read_data_mem;
                            1: cache[blockIndex][63:32] = read_data_mem;
                            2: cache[blockIndex][95:64] = read_data_mem;
                            3: cache[blockIndex][127:96] = read_data_mem;
                            default: cache[blockIndex] = 0;
                        endcase
                        address_mem = address_mem + 4;
                    end
                end

                cache[blockIndex][block_width-1] = 1'b1; //  Set Valid bit = 1.
                cache[blockIndex][block_width-2] = 1'b1; // Set Dirty bit = 1.
                cache[blockIndex][block_width-3:block_width-6] = address_cache[9:6]; // Update the tag. 

                case (Word_offset) // Write in the data to the right place of the block according to the word offset. 
                    2'b00: cache[blockIndex][31:0] = write_data_cache;
                    2'b01: cache[blockIndex][63:32] = write_data_cache;
                    2'b10: cache[blockIndex][95:64] = write_data_cache;
                    2'b11: cache[blockIndex][127:96] = write_data_cache;
                    default: cache[blockIndex] = 0;
                endcase
            end
        end

        else begin // read data instruction // lw. 
            if (hit_miss) begin // data is already in cache.
                i = 31 + 32 * Word_offset + 8 * Byte_offset;
                read_data_cache = cache[blockIndex][i-:32];
            end

            else if (!hit_miss) begin
                if (Dirty) begin // Need to write back to Main Memory first, then change the cache. 
                    read_write_mem = 1'b1; // Write to main memory. 
                    address_mem = {{Tag, blockIndex}, {4{1'b0}}}; // Start from word0.
                    for (i = 0; i < 4; i = i + 1) begin
                        case (i)
                            0: write_data_mem = block[31:0];
                            1: write_data_mem = block[63:32];
                            2: write_data_mem = block[95:64];
                            3: write_data_mem = block[127:96];
                            default: write_data_mem = 32'b0;
                        endcase

                        @(posedge Done) begin
                            address_mem = address_mem + 4;
                        end
                    end
                    #1;
                end

                // Now read from main memory
                read_write_mem = 1'b0; // Read from main memory.
                address_mem = {address_cache[9:4], {4{1'b0}}};

                for (i = 0; i < 4; i = i + 1) begin
                    @(posedge Done) begin
                        case (i)
                            0: cache[blockIndex][31:0] = read_data_mem;
                            1: cache[blockIndex][63:32] = read_data_mem;
                            2: cache[blockIndex][95:64] = read_data_mem;
                            3: cache[blockIndex][127:96] = read_data_mem;
                            default: cache[blockIndex] = 0;
                        endcase
                        address_mem = address_mem + 4;
                    end
                end
                
                cache[blockIndex][block_width-1] = 1'b1; //  Set Valid bit = 1.
                cache[blockIndex][block_width-2] = 1'b0; // Set Dirty bit = 1.
                cache[blockIndex][block_width-3:block_width-6] = address_cache[9:6]; // Update the tag. 

                i = 31 + 32 * Word_offset + 8 * Byte_offset;
                read_data_cache = cache[blockIndex][i-:32];
            end
        end
    end


endmodule

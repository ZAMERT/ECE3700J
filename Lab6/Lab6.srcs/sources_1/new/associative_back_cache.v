`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/11 19:30:05
// Design Name: 
// Module Name: associative_back_cache
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


module associative_back_cache(
    input wire read_write_cache,  // 1'b1 write, 1'b0 read.
    input wire [9:0] address_cache,
    input wire[31:0] write_data_cache, // From TLB physical address. 
    input wire done,
    input wire PA_done, // From TLB
    input wire [31:0] read_data_mem,
    output reg [31:0] read_data_cache,
    output wire hit_miss,
    output reg read_write_mem,
    output reg [9:0] address_mem,
    output reg [31:0] write_data_mem
    );

    parameter set_index = 2; // 64 bytes = 16 words = 4 blocks * (4 words per block) = 2 sets * (2 blocks per set) * (4 words per block)
    parameter block_width = 2;
    parameter block_index = 4;
    parameter Tag_size = 5; // Address - Byte_offset - Word_offset - set_index = 10 - 2 - 2 - 1.
    parameter cache_width = 135; // Valid + Dirty + Tag_size + 4 * word_width.

    wire Valid_A, Valid_B;
    wire Dirty_A, Dirty_B;
    wire [Tag_size-1:0] Tag_A, Tag_B;
    wire setIndex;
    wire [cache_width-1:0] block_A, block_B;
    wire isTag_A, isTag_B;
    wire hit_A, hit_B;
    wire [1:0] Byte_offset;
    wire [1:0] Word_offset;
    // reg [cache_width-1:0] set_A [set_index-1:0]; // 2 blocks, each 135 bits.
    // reg [cache_width-1:0] set_B [set_index-1:0]; // 2 blocks, each 135 bits.
    reg [cache_width-1:0] block [block_index-1:0]; // block[0] & block[1]: set[0] // block[2] & block[3]: set[1];
    reg valid [block_index-1:0]; 
    reg dirty [block_index-1:0]; 
    reg [Tag_size-1:0] tag [block_index-1:0]; // 4 tags, each 5 bit.
    reg LRU [set_index-1:0]; // 2bit. 

    integer i;
    initial begin
        read_write_mem = 0;
        address_mem = 0;
        write_data_mem = 0;
        for (i = 0; i < set_index; i = i + 1) begin
            LRU[i] = 0;
        end
        for (i = 0; i < block_index; i = i + 1) begin
            block[i] = 0;
            valid[i] = 0;
            dirty[i] = 0;
            tag[i] = 0;
        end
    end

    assign setIndex = address_cache[4];
    assign block_A = block[{setIndex,1'b0}]; // 00 or 10, block[0] or block[2]
    assign block_B = block[{setIndex,1'b1}]; // 01 or 11, block[1] or block[3]
    assign Valid_A = block_A[cache_width-1];
    assign Valid_B = block_B[cache_width-1];
    assign Dirty_A = block_A[cache_width-2];
    assign Dirty_B = block_B[cache_width-2];
    assign Tag_A = block_A[cache_width-3 : cache_width-7];
    assign Tag_B = block_B[cache_width-3 : cache_width-7];
    assign isTag_A = (Tag_A == address_cache[9:5]);
    assign isTag_B = (Tag_B == address_cache[9:5]);
    assign Word_offset = address_cache[3:2];
    assign Byte_offset = address_cache[1:0];
    and(hit_A, Valid_A, isTag_A); // If this block is valid, and the tag is same as the address in, then it is a hit. 
    and(hit_B, Valid_B, isTag_B); // If this block is valid, and the tag is same as the address in, then it is a hit. 
    or(hit_miss, hit_A, hit_B);

    always @(*) begin
        #2
        if (PA_done) begin // TLB has complete the translation from VA to PA.
        // if (Valid & isTag) hit_miss = 1;
            if(read_write_cache) begin // This is a write in instruction. sw
                if (hit_miss) begin // There is data in the cache now. Then just write in the data. 
                    if (hit_A) begin             
                        // block A is the required position.   
                        if(Byte_offset == 2'b00) begin // sw
                            case (Word_offset)
                                2'b00: block[{setIndex,1'b0}][127:96] = write_data_cache;
                                2'b01: block[{setIndex,1'b0}][95:64] = write_data_cache;
                                2'b10: block[{setIndex,1'b0}][63:32] = write_data_cache;
                                2'b11: block[{setIndex,1'b0}][31:0] = write_data_cache;
                                default: block[{setIndex,1'b0}] = 0;
                            endcase
                        end
                        else begin // sb
                            i = 127 - 32 * Word_offset - 8 * (3-Byte_offset);
                            block[{setIndex,1'b0}][i-:8] = write_data_cache;
                        end
                        block[{setIndex,1'b0}][cache_width-2] = 1'b1; // Set Dirty bit to dirty. 
                        dirty[{setIndex,1'b0}] = 1'b1;
                        LRU[setIndex] = 1'b1;
                    end
                    else if (hit_B) begin
                        if (Byte_offset == 2'b00) begin
                            case (Word_offset)
                                2'b00: block[{setIndex,1'b1}][127:96] = write_data_cache;
                                2'b01: block[{setIndex,1'b1}][95:64] = write_data_cache;
                                2'b10: block[{setIndex,1'b1}][63:32] = write_data_cache;
                                2'b11: block[{setIndex,1'b1}][31:0] = write_data_cache;
                                default: block[{setIndex,1'b1}] = 0;
                            endcase
                        end
                        else begin
                            i = 127 - 32 * Word_offset - 8 * (3-Byte_offset);
                            block[{setIndex,1'b1}][i-:8] = write_data_cache;
                        end
                        block[{setIndex,1'b1}][cache_width-2] = 1'b1; // Set Dirty bit to dirty. 
                        dirty[{setIndex,1'b1}] = 1'b1;
                        LRU[setIndex] = 1'b0;
                    end
                end

                else if (!hit_miss) begin
                    if (LRU[setIndex] == 1'b0) begin
                        if (Dirty_A) begin // Need to write back to Main Memory first, then change the cache. 
                            read_write_mem = 1'b1; // Write to main memory. 
                            address_mem = {{Tag_A, setIndex}, {4{1'b0}}}; // Start from word0.
                            for (i = 0; i < 4; i = i + 1) begin
                                // address_mem = {Tag, blockIndex, i[1:0]};
                                case (i)
                                    0: write_data_mem = block_A[127:96];
                                    1: write_data_mem = block_A[95:64];
                                    2: write_data_mem = block_A[63:32];
                                    3: write_data_mem = block_A[31:0];
                                    default: write_data_mem = 32'b0;
                                endcase
                                @(posedge done) begin
                                    address_mem = address_mem + 4;
                                end
                            end
                            #7;
                        end

                        // Now read from main memory
                        read_write_mem = 1'b0; // Read from main memory.
                        address_mem = {address_cache[9:4], {4{1'b0}}};
                        for (i = 0; i < 4; i = i + 1) begin
                            @(posedge done) begin
                                case (i)
                                    0: block[{setIndex,1'b0}][127:96] = read_data_mem;
                                    1: block[{setIndex,1'b0}][95:64] = read_data_mem;
                                    2: block[{setIndex,1'b0}][63:32] = read_data_mem;
                                    3: block[{setIndex,1'b0}][31:0] = read_data_mem;
                                    default: block[{setIndex,1'b0}] = 0;
                                endcase
                                address_mem = address_mem + 4;
                            end
                        end

                        block[{setIndex,1'b0}][cache_width-1] = 1'b1; //  Set Valid bit = 1.
                        valid[{setIndex,1'b0}] = 1'b1;
                        block[{setIndex,1'b0}][cache_width-2] = 1'b1; // Set Dirty bit = 1.
                        dirty[{setIndex,1'b0}] = 1'b1;
                        block[{setIndex,1'b0}][cache_width-3:cache_width-7] = address_cache[9:5]; // Update the tag. 
                        tag[{setIndex,1'b0}] = address_cache[9:5];
                        LRU[setIndex] = 1'b1;

                        if(Byte_offset == 2'b00) begin // sw
                            case (Word_offset)
                                2'b00: block[{setIndex,1'b0}][127:96] = write_data_cache;
                                2'b01: block[{setIndex,1'b0}][95:64] = write_data_cache;
                                2'b10: block[{setIndex,1'b0}][63:32] = write_data_cache;
                                2'b11: block[{setIndex,1'b0}][31:0] = write_data_cache;
                                default: block[{setIndex,1'b0}] = 0;
                            endcase
                        end
                        else begin // sb
                            i = 127 - 32 * Word_offset - 8 * (3-Byte_offset);
                            block[{setIndex,1'b0}][i-:8] = write_data_cache;
                        end                   
                    end
                    else begin
                        if (Dirty_B) begin // Need to write back to Main Memory first, then change the cache. 
                            read_write_mem = 1'b1; // Write to main memory. 
                            address_mem = {{Tag_B, setIndex}, {4{1'b0}}}; // Start from word0.
                            for (i = 0; i < 4; i = i + 1) begin
                                // address_mem = {Tag, blockIndex, i[1:0]};
                                case (i)
                                    0: write_data_mem = block_B[127:96];
                                    1: write_data_mem = block_B[95:64];
                                    2: write_data_mem = block_B[63:32];
                                    3: write_data_mem = block_B[31:0];
                                    default: write_data_mem = 32'b0;
                                endcase
                                @(posedge done) begin
                                    address_mem = address_mem + 4;
                                end
                            end
                            #7;
                        end

                        // Now read from main memory
                        read_write_mem = 1'b0; // Read from main memory.
                        address_mem = {address_cache[9:4], {4{1'b0}}};
                        for (i = 0; i < 4; i = i + 1) begin
                            @(posedge done) begin
                                case (i)
                                    0: block[{setIndex,1'b1}][127:96] = read_data_mem;
                                    1: block[{setIndex,1'b1}][95:64] = read_data_mem;
                                    2: block[{setIndex,1'b1}][63:32] = read_data_mem;
                                    3: block[{setIndex,1'b1}][31:0] = read_data_mem;
                                    default: block[{setIndex,1'b1}] = 0;
                                endcase
                                address_mem = address_mem + 4;
                            end
                        end

                        block[{setIndex,1'b1}][cache_width-1] = 1'b1; //  Set Valid bit = 1.
                        valid[{setIndex,1'b1}] = 1'b1;
                        block[{setIndex,1'b1}][cache_width-2] = 1'b1; // Set Dirty bit = 1.
                        dirty[{setIndex,1'b1}] = 1'b1;
                        block[{setIndex,1'b1}][cache_width-3:cache_width-7] = address_cache[9:5]; // Update the tag. 
                        tag[{setIndex,1'b1}] = address_cache[9:5];
                        LRU[{setIndex,1'b1}] = 1'b0;

                        if (Byte_offset == 2'b00) begin
                            case (Word_offset)
                                2'b00: block[{setIndex,1'b1}][127:96] = write_data_cache;
                                2'b01: block[{setIndex,1'b1}][95:64] = write_data_cache;
                                2'b10: block[{setIndex,1'b1}][63:32] = write_data_cache;
                                2'b11: block[{setIndex,1'b1}][31:0] = write_data_cache;
                                default: block[{setIndex,1'b1}] = 0;
                            endcase
                        end
                        else begin
                            i = 127 - 32 * Word_offset - 8 * (3-Byte_offset);
                            block[{setIndex,1'b1}][i-:8] = write_data_cache;
                        end                     
                    end
                end
            end

            else begin // read data instruction // lw. 
                if (hit_miss) begin // data is already in cache.
                    if (hit_A) begin
                        if (Byte_offset == 2'b00) begin
                            i = 127 - 32 * Word_offset;
                            read_data_cache = block[{setIndex,1'b0}][i-:32];
                            LRU[setIndex] = 1'b1;
                        end
                        else begin
                            i = 127 - 32 * Word_offset - 8 * (3-Byte_offset);
                            read_data_cache = block[{setIndex,1'b0}][i-:8];
                            LRU[setIndex] = 1'b1;
                        end
                    end
                    else if (hit_B) begin
                        if (Byte_offset == 2'b00) begin
                            i = 127 - 32 * Word_offset;
                            read_data_cache = block[{setIndex,1'b1}][i-:32];
                            LRU[setIndex] = 1'b0;
                        end
                        else begin
                            i = 127 - 32 * Word_offset - 8 * (3-Byte_offset);
                            read_data_cache = block[{setIndex,1'b1}][i-:8];
                            LRU[setIndex] = 1'b0;
                        end
                    end

                end

                else if (!hit_miss) begin // Replace refer to LRU
                    if (LRU[setIndex] == 1'b0) begin // Replace set A.
                        if (Dirty_A) begin // Need to write back to Main Memory first, then change the cache. 
                            read_write_mem = 1'b1; // Write to main memory. 
                            address_mem = {{Tag_A, setIndex}, {4{1'b0}}}; // Start from word0.
                            for (i = 0; i < 4; i = i + 1) begin
                                case (i)
                                    0: write_data_mem = block_A[127:96];
                                    1: write_data_mem = block_A[95:64];
                                    2: write_data_mem = block_A[63:32];
                                    3: write_data_mem = block_A[31:0];
                                    default: write_data_mem = 32'b0;
                                endcase

                                @(posedge done) begin
                                    address_mem = address_mem + 4;
                                end
                            end
                            #1;
                        end

                        // Now read from main memory
                        read_write_mem = 1'b0; // Read from main memory.
                        address_mem = {address_cache[9:4], {4{1'b0}}};

                        for (i = 0; i < 4; i = i + 1) begin
                            @(posedge done) begin
                                case (i)
                                    0: block[{setIndex,1'b0}][127:96] = read_data_mem;
                                    1: block[{setIndex,1'b0}][95:64] = read_data_mem;
                                    2: block[{setIndex,1'b0}][63:32] = read_data_mem;
                                    3: block[{setIndex,1'b0}][31:0] = read_data_mem;
                                    default: block[{setIndex,1'b0}] = 0;
                                endcase
                                address_mem = address_mem + 4;
                            end
                        end
                        
                        block[{setIndex,1'b0}][cache_width-1] = 1'b1; //  Set Valid bit = 1.
                        valid[{setIndex,1'b0}] = 1'b1;
                        block[{setIndex,1'b0}][cache_width-2] = 1'b0; // Set Dirty bit = 0.
                        dirty[{setIndex,1'b0}] = 1'b0;
                        block[{setIndex,1'b0}][cache_width-3:cache_width-7] = address_cache[9:5]; // Update the tag. 
                        tag[{setIndex,1'b0}] = address_cache[9:5];

                        if (Byte_offset == 2'b00) begin
                            i = 127 - 32 * Word_offset;
                            read_data_cache = block[{setIndex,1'b0}][i-:32];
                            LRU[setIndex] = 1'b1;
                        end
                        else begin
                            i = 127 - 32 * Word_offset - 8 * (3-Byte_offset);
                            read_data_cache = block[{setIndex,1'b0}][i-:8];
                            LRU[setIndex] = 1'b1;
                        end
                    end

                    else begin // LRU[setIndex] = 1'b1; Least used block is in set B. 
                            if (Dirty_B) begin // Need to write back to Main Memory first, then change the cache. 
                            read_write_mem = 1'b1; // Write to main memory. 
                            address_mem = {{Tag_B, setIndex}, {4{1'b0}}}; // Start from word0.
                            for (i = 0; i < 4; i = i + 1) begin
                                case (i)
                                    0: write_data_mem = block_B[127:96];
                                    1: write_data_mem = block_B[95:64];
                                    2: write_data_mem = block_B[63:32];
                                    3: write_data_mem = block_B[31:0];
                                    default: write_data_mem = 32'b0;
                                endcase

                                @(posedge done) begin
                                    address_mem = address_mem + 4;
                                end
                            end
                            #1;
                        end

                        // Now read from main memory
                        read_write_mem = 1'b0; // Read from main memory.
                        address_mem = {address_cache[9:4], {4{1'b0}}};

                        for (i = 0; i < 4; i = i + 1) begin
                            @(posedge done) begin
                                case (i)
                                    0: block[{setIndex,1'b1}][127:96] = read_data_mem;
                                    1: block[{setIndex,1'b1}][95:64] = read_data_mem;
                                    2: block[{setIndex,1'b1}][63:32] = read_data_mem;
                                    3: block[{setIndex,1'b1}][31:0] = read_data_mem;
                                    default: block[{setIndex,1'b1}] = 0;
                                endcase
                                address_mem = address_mem + 4;
                            end
                        end
                        
                        block[{setIndex,1'b1}][cache_width-1] = 1'b1; //  Set Valid bit = 1.
                        valid[{setIndex,1'b1}] = 1'b1;
                        block[{setIndex,1'b1}][cache_width-2] = 1'b0; // Set Dirty bit = 0.
                        dirty[{setIndex,1'b1}] = 1'b0;
                        block[{setIndex,1'b1}][cache_width-3:cache_width-7] = address_cache[9:5]; // Update the tag. 
                        tag[{setIndex,1'b1}] = address_cache[9:5];

                        if (Byte_offset == 2'b00) begin
                            i = 127 - 32 * Word_offset;
                            read_data_cache = block[{setIndex,1'b1}][i-:32];
                            LRU[setIndex] = 1'b0;     
                        end
                        else begin
                            i = 127 - 32 * Word_offset - 8 * (3-Byte_offset);
                            read_data_cache = block[{setIndex,1'b1}][i-:8];
                            LRU[setIndex] = 1'b0;    
                        end
                    end
                end
            end
        end
    end


endmodule

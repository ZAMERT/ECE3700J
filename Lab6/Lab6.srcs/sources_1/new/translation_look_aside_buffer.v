`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/11 21:50:49
// Design Name: 
// Module Name: translation_look_aside_buffer
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


module translation_look_aside_buffer(
    input wire [13:0] virtual_address, // From CPU
    input wire input_read_write, // 1'b0 for read data, lw; 1'b1 for write data, sw; // From CPU
    input wire [1:0] physical_page_tag, // From PT
    input wire PT_done, // From PT
    input wire page_fault,
    input wire dirty_fetched,
    input wire reference_fetched,
    output reg[9:0] physical_address, // to Cache
    output wire output_read_write, // to Cache, 1'b0 for read data, 1'b1 for write data. 
    output reg[5:0] virtual_page_tag, // to PT
    output reg PA_done, // to Cache
    output reg read_write_PT,
    output reg dirty_write_back,
    output reg reference_write_back
    );

    parameter TLB_index = 4;
    parameter Page_offset = 8;

    wire isTag_A, isTag_B, isTag_C, isTag_D;
    wire hit_A, hit_B, hit_C, hit_D;
    wire [5:0] VPN;
    wire [7:0] PO;
    reg [5:0] tag [TLB_index-1:0];
    reg valid [TLB_index-1:0];
    reg dirty [TLB_index-1:0];
    reg reference [TLB_index-1:0];
    reg [1:0] block [TLB_index-1:0]; // 2 bit PPN
    reg [1:0] LRU [TLB_index-1:0];
    reg TLB_hit;

    integer i, j, k;
    initial begin
        #10;
        physical_address = 0;
        virtual_page_tag = 0;
        PA_done = 0;
        read_write_PT = 0;
        dirty_write_back = 0;
        reference_write_back = 0;
        for (i = 0; i < TLB_index; i = i + 1) begin
            tag[i] = 0;
            valid[i] = 0;
            dirty[i] = 0;
            reference[i] = 0;
            block[i] = 0;
        end
        LRU[0] = 2'b11;
        LRU[1] = 2'b10;
        LRU[2] = 2'b01;
        LRU[3] = 2'b00;

    end

    assign output_read_write = input_read_write;
    assign VPN = virtual_address[13:8];
    assign PO = virtual_address[Page_offset:0];
    assign isTag_A = (VPN == tag[0]);
    assign isTag_B = (VPN == tag[1]);
    assign isTag_C = (VPN == tag[2]);
    assign isTag_D = (VPN == tag[3]);

    and(hit_A, valid[0], isTag_A);
    and(hit_B, valid[1], isTag_B);
    and(hit_C, valid[2], isTag_C);
    and(hit_D, valid[3], isTag_D);

    always @(*) begin
        if (hit_A || hit_B || hit_C || hit_D) begin
            TLB_hit = 1'b1;
        end
        else begin
            TLB_hit = 1'b0;
        end
        
        if(!TLB_hit) begin // Miss, need to get from PT. 
            PA_done = 1'b0;
            for (i = 0; i < TLB_index; i = i + 1) begin
                if (LRU[i] == 2'b11) begin
                    if (dirty[i]) begin
                        virtual_page_tag = VPN;
                        dirty_write_back = dirty[i];
                        reference_write_back = reference[i];
                        read_write_PT = 1'b1;
                    end

                    // #1

                    read_write_PT = 1'b0;
                    virtual_page_tag = VPN;
                    #1

                    if (!page_fault) begin
                        if(PT_done) begin
                            tag[i] = VPN;
                            block[i] = physical_page_tag;
                            dirty[i] = dirty_fetched;
                            reference[i] = reference_fetched;
                        end

                        valid[i] = 1'b1;
                        reference[i] = 1'b1;
                        if (input_read_write) begin
                            dirty[i] = 1'b1;
                        end
                    end
                end
            end

        end
        else begin // VPN to PPN translation is already in TLB. 
            read_write_PT = 1'b0;
            virtual_page_tag = VPN;
            #1
            physical_address[Page_offset-1:0] = PO;
            if (hit_A) begin
                physical_address[9:8] = block[0];
                j = 0;
            end
            else if (hit_B) begin
                physical_address[9:8] = block[1];
                j = 1;
            end
            else if (hit_C) begin
                physical_address[9:8] = block[2];
                j = 2;
            end
            else begin // hit_D == 1
                physical_address[9:8] = block[3];
                j = 3;
            end
            PA_done = 1'b1;
            // LRU[j] = 2'b00;
            for (k = 0; k < TLB_index; k = k + 1) begin
                // if (k != j) begin
                if (LRU[k] < LRU[j]) begin 
                    LRU[k] = LRU[k] + 2'b01;
                end
            end
            LRU[j] = 2'b00;

            if (input_read_write) begin
                dirty[j] = 1'b1;
            end
        end
    end

endmodule

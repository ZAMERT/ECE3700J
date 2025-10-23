`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/12 02:00:11
// Design Name: 
// Module Name: page_table
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


module page_table(
    input wire read_write_PT,
    input wire [5:0] virtual_page_tag,
    input wire dirty_write_back,
    input wire reference_write_back,
    output reg [1:0] physical_page_tag,
    output reg page_fault,
    output reg PT_done,
    output reg dirty_fetched,
    output reg reference_fetched
    );

    reg [31:0] Page_Table [63:0];

    integer i;

    initial begin
        #10
        PT_done = 1'b0;
        page_fault = 1'b0;
        physical_page_tag = 2'b0;
        dirty_fetched = 0;
        reference_fetched = 0;
        for (i = 0; i < 64; i = i + 1) begin
            Page_Table[i] = 0;
        end
        Page_Table[0] = {1'b1, 29'b0, 2'd1};
        Page_Table[1] = {1'b1, 29'b0, 2'd3};
        Page_Table[2] = {1'b0, 29'b0, 2'd2};
        Page_Table[3] = {1'b1, 29'b0, 2'd3};
        Page_Table[4] = {1'b1, 29'b0, 2'd2};
        Page_Table[5] = 32'b0;
        Page_Table[6] = 32'b0;
        Page_Table[7] = {1'b1, 29'b0, 2'd1}; 
        Page_Table[8] = {1'b1, 29'b0, 2'd1};
        Page_Table[9] = 32'b0;
        Page_Table[10] = {1'b1, 29'b0, 2'd1}; 
    end

    always @(*) begin
        #1
        if (read_write_PT == 1'b1) begin
            Page_Table[virtual_page_tag][3] = 1'b1;
            Page_Table[virtual_page_tag][2] = 1'b1;
        end
        if (read_write_PT == 1'b0) begin
            if (Page_Table[virtual_page_tag][31] == 1'b1) begin // Not page fault.
                physical_page_tag = Page_Table[virtual_page_tag][1:0];
                dirty_fetched = Page_Table[virtual_page_tag][3];
                reference_fetched = Page_Table[virtual_page_tag][2];
                page_fault = 1'b0;
            end
            else begin
                page_fault = 1'b1;
            end
        end
        #1 PT_done = 1'b1;
        #1 PT_done = 1'b0;
    end

endmodule

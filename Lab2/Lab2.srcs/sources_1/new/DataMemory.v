`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 02:38:25
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
    input wire [31:0] Address,
    input wire [31:0] writeData,
    input wire memRead,
    input wire memWrite,
    input wire clk,
    output reg [31:0] readData
    );

    integer i;

    reg[7:0] memory [0:255];

    initial begin
        for (i = 0; i < 256 ; i = i + 1) begin
            memory[i] <= 32'b0;
        end
    end

    always @(posedge clk) begin
        if (memWrite) begin
            memory[Address[7:0]] <= writeData[7:0];
            memory[Address[7:0] + 1] <= writeData[15:8];
            memory[Address[7:0] + 2] <= writeData[23:16];
            memory[Address[7:0] + 3] <= writeData[31:24];
        end
    end

    always @(*) begin
        if (memRead) begin
            readData <= {memory[Address[7:0]+3],memory[Address[7:0]+2],memory[Address[7:0]+1],memory[Address[7:0]]};
        end
    end

endmodule

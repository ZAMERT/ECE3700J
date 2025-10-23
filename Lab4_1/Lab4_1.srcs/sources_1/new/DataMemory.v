`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 12:02:26
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
    input wire [2:0] Funct3,
    output reg [31:0] readData
    );

    integer i;

    reg[7:0] memory [0:255];

    initial begin
        for (i = 0; i < 256 ; i = i + 1) begin
            memory[i] <= 32'b0;
        end
    end

    always @(*) begin // sw, sb // Write.
        if (memWrite) begin
            case (Funct3)
                3'b010: begin //sw
                    memory[Address[7:0]] = writeData[7:0];
                    memory[Address[7:0] + 1] = writeData[15:8];
                    memory[Address[7:0] + 2] = writeData[23:16];
                    memory[Address[7:0] + 3] = writeData[31:24];
                end
                3'b000: begin
                    memory[Address[7:0]] = writeData[7:0];
                    memory[Address[7:0] + 1] = {8{writeData[7]}};
                    memory[Address[7:0] + 2] = {8{writeData[7]}};
                    memory[Address[7:0] + 3] = {8{writeData[7]}};
                end
                default: begin
                    memory[Address[7:0]] = 8'b0;
                    memory[Address[7:0] + 1] = 8'b0;
                    memory[Address[7:0] + 2] = 8'b0;
                    memory[Address[7:0] + 3] = 8'b0;
                end
            endcase
        end
    end

    always @(*) begin
        if (memRead) begin
            case (Funct3)
                3'b010: readData = {memory[Address[7:0]+3],memory[Address[7:0]+2],memory[Address[7:0]+1],memory[Address[7:0]]}; // lw
                3'b100: readData = {24'b0, memory[Address[7:0]]}; // lbu
                3'b000: readData = {{24{memory[Address[7:0]][7]}}, memory[Address[7:0]]}; // lb
                default: readData = 32'b0;
            endcase
        end
    end

endmodule

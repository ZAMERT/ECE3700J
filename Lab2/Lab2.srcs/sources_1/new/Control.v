`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/26 22:08:05
// Design Name: 
// Module Name: Control
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


module Control(
    input wire [6:0] Instruction,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg [1:0] ALUOp,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite
    );

    always@(Instruction)begin
        case(Instruction)
            7'b0110011: begin // add, sub, and, or
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = 2'b10;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b1;
            end
            7'b0010011: begin // addi
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = 2'b11; // User defined
                MemWrite = 1'b0;
                ALUSrc = 1'b1;
                RegWrite = 1'b1;
            end
            7'b0000011:begin // lw
                Branch = 1'b0;
                MemRead = 1'b1;
                MemtoReg = 1'b1;
                ALUOp = 2'b00;
                MemWrite = 1'b0;
                ALUSrc = 1'b1;
                RegWrite = 1'b1;
            end
            7'b0100011: begin // sw
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0; // Doesn't matter.
                ALUOp = 2'b00;
                MemWrite = 1'b1;
                ALUSrc = 1'b1;
                RegWrite = 1'b0;
            end
            7'b1100011: begin // beq, ben
                Branch = 1'b1;
                MemRead = 1'b0;
                MemtoReg = 1'b0; // Doesn't matter.
                ALUOp = 2'b01;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;
            end
            default: begin
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = 2'b00;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;
            end
        endcase
    end

endmodule

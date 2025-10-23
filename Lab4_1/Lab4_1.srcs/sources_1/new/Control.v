`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 12:01:53
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
    output reg [1:0] MemtoReg,
    output reg [1:0] ALUOp,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite,
    output reg [1:0] Jump
    );

    always@(Instruction)begin
        case(Instruction)
            7'b0110011: begin // add, sub, and, or, sll, srl, sra
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 2'b00;
                ALUOp = 2'b10;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b1;
                Jump = 2'b00;
            end
            7'b0010011: begin // addi, slli, srli, andi
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 2'b00;
                ALUOp = 2'b11; // User defined
                MemWrite = 1'b0;
                ALUSrc = 1'b1;
                RegWrite = 1'b1;
                Jump = 2'b00;
            end
            7'b0000011:begin // lw, lb, lbu
                Branch = 1'b0;
                MemRead = 1'b1;
                MemtoReg = 2'b01;
                ALUOp = 2'b00;
                MemWrite = 1'b0;
                ALUSrc = 1'b1;
                RegWrite = 1'b1;
                Jump = 2'b00;
            end
            7'b0100011: begin // sw, sb
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 2'b00; // Doesn't matter.
                ALUOp = 2'b00;
                MemWrite = 1'b1;
                ALUSrc = 1'b1;
                RegWrite = 1'b0;
                Jump = 2'b00;
            end
            7'b1100011: begin // beq, ben, bge, blt
                Branch = 1'b1;
                MemRead = 1'b0;
                MemtoReg = 2'b00; // Doesn't matter.
                ALUOp = 2'b01;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;
                Jump = 2'b00;
            end
            7'b1101111: begin // jal
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 2'b10; // x1 = PC + 4.
                ALUOp = 2'b00;
                MemWrite = 1'b0;
                ALUSrc = 1'b1;
                RegWrite = 1'b1;
                Jump = 2'b01;
            end
            7'b1100111: begin // jalr
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 2'b10; // x0 = PC + 4.
                ALUOp = 2'b00;
                MemWrite = 1'b0;
                ALUSrc = 1'b1;
                RegWrite = 1'b1;
                Jump = 2'b10;
            end
            default: begin
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 2'b00;
                ALUOp = 2'b00;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;
                Jump = 2'b00;
            end
        endcase
    end

endmodule

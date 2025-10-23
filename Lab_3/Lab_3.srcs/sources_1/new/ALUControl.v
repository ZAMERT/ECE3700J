`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/14 19:05:24
// Design Name: 
// Module Name: ALUControl
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


module ALUControl(
    input wire [1:0] ALUOp,
    input wire [3:0] infunct3,
    output reg [3:0] Control
    );
    always @(ALUOp, infunct3) begin
        case(ALUOp)
            2'b00: begin // lw, sw, lb, lbu, sb, jal
                Control = 4'b0010;
            end
            2'b01: begin // beq or bne or bge or blt
                case (infunct3)
                    4'b0000: Control = 4'b0110; // beq. 
                    4'b1000: Control = 4'b0110; // beq.
                    4'b0001: Control = 4'b1100; // Custom defined. bne
                    4'b1001: Control = 4'b1100; // Custom defined. bne
                    4'b0101: Control = 4'b1000; // bge
                    4'b1101: Control = 4'b1000; // bge
                    4'b0100: Control = 4'b1001; // blt
                    4'b1100: Control = 4'b1001; // blt
                    default: Control = 4'b1111;
                endcase
            end
            2'b10: begin // add, sub, and, or, sll, srl, sra
                case (infunct3)
                    4'b0000: Control = 4'b0010; // add
                    4'b1000: Control = 4'b0110; // sub
                    4'b0111: Control = 4'b0000; // AND
                    4'b0110: Control = 4'b0001; // OR
                    4'b0001: Control = 4'b0011; // sll
                    4'b0101: Control = 4'b0100; // srl
                    4'b1101: Control = 4'b0101; // sra
                    default: Control = 4'b1111;
                endcase
            end
            2'b11: begin // Customer defined ALUOp for addi, slli, srli, andi.
                case (infunct3)
                    4'b0000: Control = 4'b0010; // addi
                    4'b1000: Control = 4'b0010; // addi
                    4'b0001: Control = 4'b0011; // slli
                    4'b1001: Control = 4'b0011; // slli
                    4'b0101: Control = 4'b0100; // srli
                    4'b1101: Control = 4'b0100; // srli
                    4'b0111: Control = 4'b0000; // andi
                    4'b1111: Control = 4'b0000; // andi
                    default: Control = 4'b1111;
                endcase
            end
            default: Control = 4'b1111;
        endcase
    end
endmodule

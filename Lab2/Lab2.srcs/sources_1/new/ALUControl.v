`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/26 23:03:02
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
            2'b00: begin // lw or sw
                Control = 4'b0010;
            end
            2'b01: begin // beq or bne
                case (infunct3)
                    4'b0000: Control = 4'b0110; // beq. 
                    4'b1000: Control = 4'b0110; // beq.
                    4'b0001: Control = 4'b1100; // Custom defined. bne
                    4'b1001: Control = 4'b1100; // Custom defined. bne
                    default: Control = 4'b1111;
                endcase
            end
            2'b10: begin // add, sub, and or
                case (infunct3)
                    4'b0000: Control = 4'b0010; // add
                    4'b1000: Control = 4'b0110; // sub
                    4'b0111: Control = 4'b0000; // AND
                    4'b0110: Control = 4'b0001; // OR
                    default: Control = 4'b1111;
                endcase
            end
            2'b11: begin // Customer defined ALUOp for addi.
                case (infunct3)
                    4'b0000: Control = 4'b0010;
                    4'b1000: Control = 4'b0010;
                    default: Control = 4'b1111;
                endcase
            end
            default: Control = 4'b1111;
        endcase
    end
endmodule

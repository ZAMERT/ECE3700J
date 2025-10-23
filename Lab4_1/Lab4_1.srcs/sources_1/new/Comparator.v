`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 12:01:13
// Design Name: 
// Module Name: Comparator
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


module Comparator(
    input wire [31:0] readData1,
    input wire [31:0] readData2,
    input wire [2:0] funct3,
    output reg Equal
    );

    initial begin
        Equal = 1'b0;
    end

    always @(*) begin
        case (funct3)
            3'b000: begin // beq
                if (readData1 == readData2) begin
                    Equal = 1'b1;
                end
                else begin
                    Equal = 1'b0;
                end
            end
            3'b001: begin // bne
                if ((readData1 - readData2) != 0) begin
                    Equal = 1'b1;
                end
                else begin
                    Equal = 1'b0;
                end
            end
            3'b100: begin // blt
                if ($signed(readData1) < $signed(readData2)) begin
                    Equal = 1'b1;
                end
                else begin
                    Equal = 1'b0;
                end
            end
            3'b101: begin // bge
                if ($signed(readData1) >= $signed(readData2)) begin
                    Equal = 1'b1;
                end
                else begin
                    Equal = 1'b0;
                end
            end
            default: begin
                Equal = 1'b0;
            end
        endcase
    end
endmodule

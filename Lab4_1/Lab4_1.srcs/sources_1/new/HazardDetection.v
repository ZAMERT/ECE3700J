`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 12:05:12
// Design Name: 
// Module Name: HazardDetection
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


module HazardDetection(
    input wire [4:0] rs1_ID,
    input wire [4:0] rs2_ID,
    input wire [4:0] rd_EX,
    input wire [4:0] rd_MEM,
    input wire MemWrite_ID,
    input wire MemRead_EX,
    input wire MemRead_MEM,
    input wire RegWrite_EX, 
    input wire Branch_ID,
    output reg LUSrc,
    output reg PCWrite,
    output reg IF_IDWrite
    );

    initial begin
        LUSrc = 1'b0;
        PCWrite = 1'b1;
        IF_IDWrite = 1'b1;
    end

    always @(*) begin
        // Load Use Hazard
        if (MemRead_EX && ((rd_EX == rs1_ID) || (rd_EX == rs2_ID)) && (!MemWrite_ID)) begin
            LUSrc = 1'b1; // add a nop.
            PCWrite = 1'b0;
            IF_IDWrite = 1'b0;
        end
        // Branch Hazard 1 // Eg. add & beq
        else if (RegWrite_EX && Branch_ID && (rd_EX != 0) && ((rd_EX == rs1_ID) || (rd_EX == rs2_ID))) begin
            LUSrc = 1'b1; // add a nop.
            PCWrite = 1'b0;
            IF_IDWrite = 1'b0;
        end
        // Branch Hazard 2 // Eg. lw & add & beq
        else if (MemRead_MEM && Branch_ID && (rd_MEM != 0) && ((rd_MEM == rs1_ID) || (rd_MEM == rs2_ID))) begin
            LUSrc = 1'b1; // add a nop.
            PCWrite = 1'b0;
            IF_IDWrite = 1'b0;
        end
        else begin
            LUSrc = 1'b0;
            PCWrite = 1'b1;
            IF_IDWrite = 1'b1;
        end
    end

endmodule

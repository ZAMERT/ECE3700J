`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/15 01:42:20
// Design Name: 
// Module Name: EX_MEM_Reg
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


module EX_MEM_Reg(
    input wire clk,
    input wire RegWrite, // WB1
    input wire[1:0] MemtoReg, //WB2
    input wire Branch, // MEM1
    input wire MemWrite, // MEM2
    input wire MemRead, // MEM3
    input wire[1:0] Jump, // MEM4
    // input wire[31:0] AddSum, 
    input wire zero,
    input wire[31:0] ALUResult, 
    input wire[31:0] readData2,
    input wire[2:0] Funct3,
    input wire[4:0] WriteRd, 
    input wire[31:0] PCnext,
    output reg RegWrite_out, // WB1
    output reg[1:0] MemtoReg_out, // WB2
    output reg Branch_out, // MEM1
    output reg MemWrite_out, // MEM2
    output reg MemRead_out, // MEM3
    output reg[1:0] Jump_out, // MEM4
    // output reg[31:0] AddSum_out, 
    output reg zero_out,
    output reg[31:0] ALUResult_out,
    output reg[31:0] readData2_out,
    output reg[2:0] Funct3_out,
    output reg[4:0] WriteRd_out,
    output reg[31:0] PCnext_out
    );

    initial begin
        RegWrite_out = 1'b0;
        MemtoReg_out = 2'b0;
        Branch_out = 1'b0;
        MemWrite_out = 1'b0;
        MemRead_out = 1'b0;
        Jump_out = 2'b0;
        // AddSum_out = 32'b0;
        zero_out = 1'b0;
        ALUResult_out = 32'b0;
        readData2_out = 32'b0;
        Funct3_out = 3'b0;
        WriteRd_out = 5'b0;
        PCnext_out = 32'b0;
    end

    always @(posedge clk ) begin
        RegWrite_out <= RegWrite;
        MemtoReg_out <= MemtoReg;
        Branch_out <= Branch;
        MemWrite_out <= MemWrite;
        MemRead_out <= MemRead;
        Jump_out <= Jump;
        // AddSum_out <= AddSum;
        zero_out <= zero;
        ALUResult_out <= ALUResult;
        readData2_out <= readData2;
        Funct3_out <= Funct3;
        WriteRd_out <= WriteRd;
        PCnext_out <= PCnext;
    end

endmodule

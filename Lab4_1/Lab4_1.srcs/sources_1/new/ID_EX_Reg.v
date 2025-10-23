`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 12:05:48
// Design Name: 
// Module Name: ID_EX_Reg
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


module ID_EX_Reg(
    input wire clk,
    input wire RegWrite, // WB1
    input wire[1:0] MemtoReg, //WB2
    input wire MemWrite, // MEM2
    input wire MemRead, // MEM3
    input wire[1:0] Jump, // MEM4
    input wire ALUSrc, // EX1
    input wire[1:0] ALUOp, // EX2
    input wire[31:0] PC,
    input wire[31:0] readData1, 
    input wire[31:0] readData2,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire[31:0] ImmGen,
    input wire[3:0] infunct3,
    input wire[4:0] WriteRd,
    input wire[31:0] PCnext,
    output reg RegWrite_out, // WB1
    output reg[1:0] MemtoReg_out, // WB2
    output reg MemWrite_out, // MEM2
    output reg MemRead_out, // MEM3
    output reg[1:0] Jump_out, // MEM4
    output reg ALUSrc_out, // EX1
    output reg[1:0] ALUOp_out, // EX2
    output reg[31:0] PC_out, 
    output reg[31:0] readData1_out, 
    output reg[31:0] readData2_out, 
    output reg[4:0] rs1_out,
    output reg[4:0] rs2_out,
    output reg[31:0] ImmGen_out, 
    output reg[3:0] infunct3_out,
    output reg[4:0] WriteRd_out,
    output reg[31:0] PCnext_out
    );

    initial begin
        RegWrite_out = 1'b0;
        MemtoReg_out = 2'b0;
        // Branch_out = 1'b0;
        MemWrite_out = 1'b0;
        MemRead_out = 1'b0;
        Jump_out = 2'b0;
        ALUSrc_out = 1'b0;
        ALUOp_out = 2'b0;
        PC_out = 32'b0;
        readData1_out = 32'b0;
        readData2_out = 32'b0;
        rs1_out = 5'b0;
        rs2_out = 5'b0;
        ImmGen_out = 32'b0;
        infunct3_out = 5'b0;
        WriteRd_out = 32'b0;
        PCnext_out = 32'b0;
    end

    always @(posedge clk ) begin
        RegWrite_out <= RegWrite;
        MemtoReg_out <= MemtoReg;
        // Branch_out <= Branch;
        MemWrite_out <= MemWrite;
        MemRead_out <= MemRead;
        Jump_out <= Jump;
        ALUSrc_out <= ALUSrc;
        ALUOp_out <= ALUOp;
        PC_out <= PC;
        readData1_out <= readData1;
        readData2_out <= readData2;
        rs1_out <= rs1;
        rs2_out <= rs2;
        ImmGen_out <= ImmGen;
        infunct3_out <= infunct3;
        WriteRd_out <= WriteRd;
        PCnext_out <= PCnext;
    end
endmodule

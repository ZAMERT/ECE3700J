`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 12:09:14
// Design Name: 
// Module Name: MEM_WB_Reg
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


module MEM_WB_Reg(
    input wire clk,
    input wire RegWrite, // WB1
    input wire[1:0] MemtoReg, //WB2
    input wire[31:0] PCnext,
    input wire[31:0] ReadData,
    input wire[31:0] ALUResult,
    input wire[4:0] WriteRd,
    input wire MemRead, 
    output reg RegWrite_out, // WB1
    output reg[1:0] MemtoReg_out, // WB2
    output reg[31:0] PCnext_out,
    output reg[31:0] ReadData_out,
    output reg[31:0] ALUResult_out,
    output reg[4:0] WriteRd_out,
    output reg MemRead_out
    );

    initial begin
        RegWrite_out = 1'b0;
        MemtoReg_out = 2'b0;
        PCnext_out = 32'b0;
        ReadData_out = 32'b0;
        ALUResult_out = 32'b0;
        WriteRd_out = 5'b0;
        MemRead_out = 1'b0;
    end

    always @(posedge clk ) begin
        RegWrite_out <= RegWrite;
        MemtoReg_out <= MemtoReg;
        PCnext_out <= PCnext;
        ReadData_out <= ReadData;
        ALUResult_out <= ALUResult;
        WriteRd_out <= WriteRd;
        MemRead_out <= MemRead;
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/14 18:58:29
// Design Name: 
// Module Name: top
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


module top(
    input wire clk
    );

    reg [31:0] pc;
    wire [31:0] inst_IF, pc4, nextPC;
    wire [31:0] inst_ID, readData1_ID, readData2_ID, imm_ID, pc_ID, PCnext_ID; 
    wire [31:0] readData1_EX, readData2_EX, ALUin2, ALUResult_EX, imm_EX, immShift, pc_EX, pcImm_EX, PCnext_EX; 
    wire [31:0] ALUResult_MEM, readData2_MEM, readData_MEM, PCnext_MEM; 
    wire [31:0] writeData_WB, readData_WB, PCnext_WB, ALUResult_WB; 
    wire [4:0] rd_EX, rd_MEM, rd_WB; 
    wire [3:0] infunct3_EX, ALUControl; 
    wire [2:0] Funct3_MEM; 
    wire [1:0] MemtoReg_ID, MemtoReg_EX, MemtoReg_MEM, ALUOp_ID, Jump_ID, ALUOp_EX, MemtoReg_WB, Jump_EX, Jump_Mem; 
    wire Branch_ID, MemRead_ID, MemWrite_ID, ALUSrc_ID, RegWrite_ID, RegWrite_EX, RegWrite_WB, zero_EX, MemRead_MEM, MemWrite_MEM, Branch_MEM, zero_MEM;
    wire Branch_EX, MemRead_EX, MemWrite_EX, ALUSrc_EX, RegWrite_MEM;

    initial begin
        pc = 32'b0;
    end

    always @(posedge clk ) begin
        pc <= nextPC;
    end

    InstructionMemory InstMem(pc,inst_IF);
    Adder pcplus4(pc, 32'h0000_0004, pc4);
    Control conl(inst_ID[6:0], Branch_ID, MemRead_ID, MemtoReg_ID, ALUOp_ID, MemWrite_ID, ALUSrc_ID, RegWrite_ID, Jump_ID);
    RegisterFile RF(inst_ID[19:15], inst_ID[24:20], rd_WB, writeData_WB, RegWrite_WB, readData1_ID, readData2_ID);
    ImmGen immGen(inst_ID, imm_ID);
    Mux ALUinMux(readData2_EX, imm_EX, ALUSrc_EX, ALUin2);
    ALUControl ALUcon(ALUOp_EX, infunct3_EX, ALUControl);
    ALU alu(readData1_EX, ALUin2, ALUControl, zero_EX, ALUResult_EX);
    ShiftLeft SL(imm_EX, immShift);
    Adder pcplusImm(pc_EX, immShift, pcImm_EX);
    DataMemory DataMem(ALUResult_MEM, readData2_MEM, MemRead_MEM, MemWrite_MEM, Funct3_MEM, readData_MEM);
    Mux4to1 writeDataMux(ALUResult_WB, readData_WB, PCnext_WB, 32'b0, MemtoReg_WB, writeData_WB);
    // Mux8to1 pcNextMux(pc4, pcImm_MEM, pcImm_MEM, pcImm_MEM, ALUResult_MEM, ALUResult_MEM, 32'b0, 32'b0, {Jump_Mem[1:0], (Branch_MEM & zero_MEM)}, nextPC);
    Mux8to1 pcNextMux(pc4, pcImm_EX, pcImm_EX, pcImm_EX, ALUResult_EX, ALUResult_EX, 32'b0, 32'b0, {Jump_EX[1:0], (Branch_EX & zero_EX)}, nextPC);

    IF_ID_Reg IF_ID(inst_IF, pc, pc4, clk, inst_ID, pc_ID, PCnext_ID);
    ID_EX_Reg ID_EX(clk, RegWrite_ID, MemtoReg_ID, Branch_ID, MemWrite_ID, MemRead_ID, Jump_ID, ALUSrc_ID, ALUOp_ID, pc_ID, readData1_ID, readData2_ID, imm_ID, {inst_ID[30], inst_ID[14:12]}, inst_ID[11:7], PCnext_ID, 
    RegWrite_EX, MemtoReg_EX, Branch_EX, MemWrite_EX, MemRead_EX, Jump_EX, ALUSrc_EX, ALUOp_EX, pc_EX, readData1_EX, readData2_EX, imm_EX, infunct3_EX, rd_EX, PCnext_EX);
    EX_MEM_Reg EX_MEM(clk, RegWrite_EX, MemtoReg_EX, Branch_EX, MemWrite_EX, MemRead_EX, Jump_EX, zero_EX, ALUResult_EX, readData2_EX, infunct3_EX[2:0], rd_EX, PCnext_EX, 
    RegWrite_MEM, MemtoReg_MEM, Branch_MEM, MemWrite_MEM, MemRead_MEM, Jump_Mem, zero_MEM, ALUResult_MEM, readData2_MEM, Funct3_MEM, rd_MEM, PCnext_MEM);
    MEM_WB_Reg MEM_WB(clk, RegWrite_MEM, MemtoReg_MEM, PCnext_MEM, readData_MEM, ALUResult_MEM, rd_MEM, RegWrite_WB, MemtoReg_WB, PCnext_WB, readData_WB, ALUResult_WB, rd_WB);
endmodule

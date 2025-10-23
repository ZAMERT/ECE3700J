`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 12:13:42
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

    // IF Stage // Var
    wire [31:0] inst_IF, pc4, nextPC;


    // ID Stage
    wire [31:0] inst_ID, readData1_ID, readData2_ID, imm_ID, immShift, pc_ID, PCnext_ID, pcImm_ID, readData1_IDFinal, readData2_IDFinal; 
    wire [1:0] MemtoReg_ID_o, MemtoReg_ID, ALUOp_ID_o, ALUOp_ID, Jump_ID_o, Jump_ID;
    wire Branch_ID_o, Branch_ID, MemRead_ID_o, MemRead_ID, MemWrite_ID_o, MemWrite_ID, ALUSrc_ID_o, ALUSrc_ID, RegWrite_ID_o, RegWrite_ID;
    wire Forward1, Forward2;
    wire Equal_ID; // Comparator.


    // EX Stage
    wire [31:0] readData1_EX, readData2_EX, ALUSource1, ALUin1, ALUin2, ALUResult_EX, imm_EX, pc_EX, PCnext_EX; 
    wire [4:0] rs1_EX, rs2_EX, rd_EX;
    wire [3:0] infunct3_EX, ALUControl;
    wire [1:0] MemtoReg_EX, ALUOp_EX, Jump_EX, ForwardA, ForwardB;
    wire RegWrite_EX, MemRead_EX, MemWrite_EX, ALUSrc_EX, Branch_EX, zero_EX;


    // MEM Stage
    wire [31:0] ALUResult_MEM, readData2_MEM, readData_MEM, PCnext_MEM, DMwriteIn; 
    wire [4:0] rs2_MEM, rd_MEM;
    wire [2:0] Funct3_MEM;
    wire [1:0] MemtoReg_MEM;
    wire RegWrite_MEM, MemRead_MEM, MemWrite_MEM, MemSrc;


    // WB Stage
    wire [31:0] writeData_WB, readData_WB, PCnext_WB, ALUResult_WB; 
    wire [4:0] rd_WB; 
    wire [1:0] MemtoReg_WB; 
    wire RegWrite_WB, MemRead_WB;


    wire LUSrc, PCWrite, IF_IDWrite, IF_Flush; // Hazard Detection. 
    wire [1:0] JumpSrc;

    initial begin
        pc = 32'b0;
    end

    always @(posedge clk ) begin
        if (PCWrite == 1'b1) begin
            pc <= nextPC;
        end
    end
    

    // IF Modules.
    InstructionMemory InstMem(pc,inst_IF);
    Adder pcplus4(pc, 32'h0000_0004, pc4);

    // ID Modules. 
    Control conl(inst_ID[6:0], Branch_ID_o, MemRead_ID_o, MemtoReg_ID_o, ALUOp_ID_o, MemWrite_ID_o, ALUSrc_ID_o, RegWrite_ID_o, Jump_ID_o);
    Mux11bit ConlMux({Branch_ID_o, MemRead_ID_o, MemtoReg_ID_o, ALUOp_ID_o, MemWrite_ID_o, ALUSrc_ID_o, RegWrite_ID_o, Jump_ID_o}, 11'b0, 
        LUSrc, {Branch_ID, MemRead_ID, MemtoReg_ID, ALUOp_ID, MemWrite_ID, ALUSrc_ID, RegWrite_ID, Jump_ID});
    RegisterFile RF(inst_ID[19:15], inst_ID[24:20], rd_WB, writeData_WB, RegWrite_WB, readData1_ID, readData2_ID);
    Mux RFForward1(readData1_ID, ALUResult_MEM, Forward1, readData1_IDFinal);
    Mux RFForward2(readData2_ID, ALUResult_MEM, Forward2, readData2_IDFinal);
    Comparator Comp(readData1_IDFinal, readData2_IDFinal, inst_ID[14:12], Equal_ID);
    ImmGen immGen(inst_ID, imm_ID);
    ShiftLeft SL(imm_ID, immShift); 
    Adder pcplusImm(pc_ID, immShift, pcImm_ID); 

    // EX Modules.
    Mux4to1 ALUForwardA(readData1_EX, writeData_WB, ALUResult_MEM, 32'b0, ForwardA, ALUin1);
    Mux4to1 ALUForwardB(readData2_EX, writeData_WB, ALUResult_MEM, 32'b0, ForwardB, ALUSource1);
    Mux ALUinMux(ALUSource1, imm_EX, ALUSrc_EX, ALUin2);
    // Mux ALUinMux(readData2_EX, imm_EX, ALUSrc_EX, ALUin2);
    ALUControl ALUcon(ALUOp_EX, infunct3_EX, ALUControl);
    ALU alu(ALUin1, ALUin2, ALUControl, zero_EX, ALUResult_EX);

    // MEM Modules.
    Mux DMin(readData2_MEM, writeData_WB, MemSrc, DMwriteIn);
    DataMemory DataMem(ALUResult_MEM, DMwriteIn, MemRead_MEM, MemWrite_MEM, Funct3_MEM, readData_MEM);
    // DataMemory DataMem(ALUResult_MEM, readData2_MEM, MemRead_MEM, MemWrite_MEM, Funct3_MEM, readData_MEM);

    // WB Modules.
    Mux4to1 writeDataMux(ALUResult_WB, readData_WB, PCnext_WB, 32'b0, MemtoReg_WB, writeData_WB);



    isJump isjump(Jump_ID, Jump_EX, JumpSrc);
    Mux8to1 pcNextMux(pc4, pcImm_ID, pcImm_ID, pcImm_ID, ALUResult_EX, ALUResult_EX, 32'b0, 32'b0, {JumpSrc, (Branch_ID & Equal_ID)}, nextPC);
    // Mux8to1 pcNextMux(pc4, pcImm_ID, pcImm_ID, pcImm_ID, ALUResult_EX, ALUResult_EX, 32'b0, 32'b0, {JumpSrc, Branch_ID}, nextPC);

    IF_ID_Reg IF_ID(inst_IF, pc, pc4, clk, IF_Flush, IF_IDWrite, inst_ID, pc_ID, PCnext_ID);
    // IF_ID_Reg IF_ID(inst_IF, pc, pc4, clk, inst_ID, pc_ID, PCnext_ID);
    ID_EX_Reg ID_EX(clk, RegWrite_ID, MemtoReg_ID, MemWrite_ID, MemRead_ID, Jump_ID, ALUSrc_ID, ALUOp_ID, pc_ID, readData1_IDFinal, readData2_IDFinal, inst_ID[19:15], inst_ID[24:20], imm_ID, {inst_ID[30], inst_ID[14:12]}, inst_ID[11:7], PCnext_ID, 
        RegWrite_EX, MemtoReg_EX, MemWrite_EX, MemRead_EX, Jump_EX, ALUSrc_EX, ALUOp_EX, pc_EX, readData1_EX, readData2_EX, rs1_EX, rs2_EX, imm_EX, infunct3_EX, rd_EX, PCnext_EX);
    // ID_EX_Reg ID_EX(clk, RegWrite_ID, MemtoReg_ID, MemWrite_ID, MemRead_ID, Jump_ID, ALUSrc_ID, ALUOp_ID, pc_ID, readData1_ID, readData2_ID, inst_ID[19:15], inst_ID[24:20], imm_ID, {inst_ID[30], inst_ID[14:12]}, inst_ID[11:7], PCnext_ID, 
    //     RegWrite_EX, MemtoReg_EX, MemWrite_EX, MemRead_EX, Jump_EX, ALUSrc_EX, ALUOp_EX, pc_EX, readData1_EX, readData2_EX, rs1_EX, rs2_EX, imm_EX, infunct3_EX, rd_EX, PCnext_EX);
    EX_MEM_Reg EX_MEM(clk, RegWrite_EX, MemtoReg_EX, MemWrite_EX, MemRead_EX, ALUResult_EX, ALUSource1, rs2_EX, infunct3_EX[2:0], rd_EX, PCnext_EX, 
        RegWrite_MEM, MemtoReg_MEM, MemWrite_MEM, MemRead_MEM, ALUResult_MEM, readData2_MEM, rs2_MEM, Funct3_MEM, rd_MEM, PCnext_MEM);
    MEM_WB_Reg MEM_WB(clk, RegWrite_MEM, MemtoReg_MEM, PCnext_MEM, readData_MEM, ALUResult_MEM, rd_MEM, MemRead_MEM, RegWrite_WB, MemtoReg_WB, PCnext_WB, readData_WB, ALUResult_WB, rd_WB, MemRead_WB);

    ForwardingUnit FU(inst_ID[19:15], inst_ID[24:20], rs1_EX, rs2_EX, rs2_MEM, rd_MEM, rd_WB, RegWrite_MEM, RegWrite_WB, MemRead_WB, MemWrite_MEM, Branch_ID, ForwardA, ForwardB, Forward1, Forward2, MemSrc);
    // HazardDetection HD(inst_ID[19:15], inst_ID[24:20], rd_EX, rd_MEM, MemWrite_ID, MemRead_EX, MemRead_MEM, RegWrite_EX, Branch_ID, LUSrc, PCWrite, IF_IDWrite);
    HazardDetection HD(inst_ID[19:15], inst_ID[24:20], rd_EX, rd_MEM, MemWrite_ID_o, MemRead_EX, MemRead_MEM, RegWrite_EX, Branch_ID_o, LUSrc, PCWrite, IF_IDWrite);
    or(IF_Flush, (Branch_ID && Equal_ID), (Jump_ID == 2'b01), (Jump_ID == 2'b10), (Jump_EX == 2'b10));

endmodule

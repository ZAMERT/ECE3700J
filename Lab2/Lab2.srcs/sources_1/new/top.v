`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/26 19:42:31
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

    reg[31:0] pc;
    wire [31:0] inst, pcplus4, writeData, readData1, readData2, imm, ALUinput, ALUresult, immShift, pcplusImm, pc_next, readData;
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, zero, pcSel;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;

    initial begin
        pc = 32'b0;
    end

    InstructionMemory insMem(pc, inst);
    Adder add1(pc, 32'h0000_0004, pcplus4);
    Control con(inst[6:0], Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
    Register Reg(inst[19:15], inst[24:20], inst[11:7], writeData, RegWrite, clk, readData1, readData2);
    ImmGen immGen(inst, imm);
    Mux mux1(readData2, imm, ALUSrc, ALUinput);
    ALUControl ALUcon(ALUOp, {inst[30], inst[14:12]}, ALUControl);
    ALU alu(readData1, ALUinput, ALUControl, zero, ALUresult);
    ShiftLeft shift(imm, immShift);
    Adder add2(pc, immShift, pcplusImm);

    // assign pcSel = Branch & zero;

    Mux mux2(pcplus4, pcplusImm, (Branch & zero), pc_next);
    DataMemory dataMem(ALUresult, readData2, MemRead, MemWrite, clk, readData);
    Mux mux3(ALUresult, readData, MemtoReg, writeData);

    always @(posedge clk) begin
        pc <= pc_next;
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/15 01:14:08
// Design Name: 
// Module Name: IF_ID_Reg
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


module IF_ID_Reg(
    input wire[31:0] Instruction,
    input wire[31:0] PC,
    input wire[31:0] PCnext,
    input wire clk,
    output reg[31:0] Inst_out,
    output reg[31:0] PC_out,
    output reg[31:0] PCnext_out
    );

    initial begin
        Inst_out = 32'b0;
        PC_out = 32'b0;
        PCnext_out = 32'b0;
    end

    always @(posedge clk ) begin
        PC_out <= PC;
        Inst_out <= Instruction;
        PCnext_out <= PCnext;
    end

endmodule

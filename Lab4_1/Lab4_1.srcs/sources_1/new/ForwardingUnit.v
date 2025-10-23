`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 12:04:33
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit(
    input wire [4:0] rs1_ID,
    input wire [4:0] rs2_ID,
    input wire [4:0] rs1_EX, 
    input wire [4:0] rs2_EX,
    input wire [4:0] rs2_MEM,
    input wire [4:0] rd_MEM,
    input wire [4:0] rd_WB,
    input wire RegWrite_MEM,
    input wire RegWrite_WB,
    input wire MemRead_WB,
    input wire MemWrite_MEM,
    input wire Branch_ID,
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB,
    output reg Forward1,
    output reg Forward2,
    output reg MemSrc
    );

    initial begin
        ForwardA = 2'b0;
        ForwardB = 2'b0;
        Forward1 = 1'b0;
        Forward2 = 1'b0;
        MemSrc = 1'b0;
    end

    always @(*) begin
        if (RegWrite_MEM && (rd_MEM != 5'b0) && (rd_MEM == rs1_EX)) // EX Hazard.
            ForwardA = 2'b10;
        else if(RegWrite_WB && (rd_WB != 5'b0) && (rd_WB == rs1_EX)) // MEM Hazard.
            ForwardA = 2'b01;
        else
            ForwardA = 2'b00;


        if (RegWrite_MEM && (rd_MEM != 5'b0) && (rd_MEM == rs2_EX)) // EX Hazard.
            ForwardB = 2'b10;
        else if(RegWrite_WB && (rd_WB != 5'b0) && (rd_WB == rs2_EX)) // MEM Hazard. 
            ForwardB = 2'b01;
        else
            ForwardB = 2'b00;

        // Load-Store Hazard
        if ((rd_WB == rs2_MEM) && (rd_WB != 5'b0) && MemRead_WB && MemWrite_MEM) begin
            MemSrc = 1'b1;
        end
        else
            MemSrc = 1'b0;

        // Branch Data Hazard
        if (RegWrite_MEM && (rd_MEM != 5'b0) && (rd_MEM == rs1_ID) && Branch_ID)
            Forward1 = 1'b1;
        else
            Forward1 = 1'b0;

        if (RegWrite_MEM && (rd_MEM != 5'b0) && (rd_MEM == rs2_ID) && Branch_ID)
            Forward2 = 1'b1;
        else
            Forward2 = 1'b0;
    end




endmodule

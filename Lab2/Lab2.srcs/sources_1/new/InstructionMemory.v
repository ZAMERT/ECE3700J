`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 03:18:51
// Design Name: 
// Module Name: InstructionMemory
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


module InstructionMemory(
    input wire [31:0] PC,
    // input wire clk,
    output reg [31:0] instruction
    );

    reg [7:0] rom[127:0];
    integer i;

    initial begin
        
        for (i = 0; i < 128; i = i + 1) begin
            rom[i] = 8'b0;
        end
        {rom[3],rom[2],rom[1],rom[0]} = 32'hff60_0293;
        {rom[7],rom[6],rom[5],rom[4]} = 32'h0052_8333;
        {rom[11],rom[10],rom[9],rom[8]} = 32'h4062_83b3;
        {rom[15],rom[14],rom[13],rom[12]} = 32'h0003_7e33;
        {rom[19],rom[18],rom[17],rom[16]} = 32'h0053_6eb3;
        {rom[23],rom[22],rom[21],rom[20]} = 32'h01d0_2023;
        {rom[27],rom[26],rom[25],rom[24]} = 32'h0050_2223;
        {rom[31],rom[30],rom[29],rom[28]} = 32'h0002_8463;
        {rom[35],rom[34],rom[33],rom[32]} = 32'h0003_0eb3;
        {rom[39],rom[38],rom[37],rom[36]} = 32'h01d3_1463;
        {rom[43],rom[42],rom[41],rom[40]} = 32'h01c3_1463;
        {rom[47],rom[46],rom[45],rom[44]} = 32'h0000_03b3;
        {rom[51],rom[50],rom[49],rom[48]} = 32'h0000_2403;
        {rom[55],rom[54],rom[53],rom[52]} = 32'h0040_2483;
        {rom[59],rom[58],rom[57],rom[56]} = 32'h0084_8493;
        {rom[63],rom[62],rom[61],rom[60]} = 32'h0094_0463;
        {rom[67],rom[66],rom[65],rom[64]} = 32'h0000_03b3;
        {rom[71],rom[70],rom[69],rom[68]} = 32'h0073_83b3;
    end

    always @(*) begin
        instruction = {rom[PC + 3], rom[PC + 2],rom[PC + 1], rom[PC]};
    end

endmodule

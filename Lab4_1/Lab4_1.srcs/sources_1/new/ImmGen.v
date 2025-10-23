`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 12:07:10
// Design Name: 
// Module Name: ImmGen
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


module ImmGen(
    input wire [31:0] instruction,
    output reg[31:0] immediate
    );

    integer  i;

    always @(instruction) begin
        if (instruction[6:0] == 7'b0110011) // R type, no imm num.
        begin
            immediate = 32'b0;
        end
        else if (instruction[6:0] == 7'b0000011 || instruction[6:0] == 7'b0010011 || instruction[6:0] == 7'b1100111) // I type, [31:20] is the imm num. 
        begin
            immediate = 32'b0;
            immediate[11:0] = instruction[31:20];
            for (i = 12; i < 32; i=i+1)
            begin
                immediate[i] = immediate[11];
            end
            
        end
        else if (instruction[6:0] == 7'b0100011) // S type, [31:25]&[11:7]
        begin
            immediate = 32'b0;
            immediate[11:5] = instruction[31:25];
            immediate[4:0] = instruction[11:7];
            for (i = 12; i < 32; i=i+1)
            begin
                immediate[i] = immediate[11];
            end
        end
        else if (instruction[6:0] == 7'b1100011) // B type
        begin
            immediate = 32'b0;
            immediate[11] = instruction[31];
            immediate[10] = instruction[7];
            immediate[9:4] = instruction[30:25];
            immediate[3:0] = instruction[11:8];
            for (i = 12; i < 32; i=i+1)
            begin
                immediate[i] = immediate[11];
            end
        end
        else if (instruction[6:0] == 7'b1101111) // J type. [31:12] is imm.
        begin
            immediate = 32'b0;
            immediate[19] = instruction[31];
            immediate[18:11] = instruction[19:12];
            immediate[10] = instruction[20];
            immediate[9:0] = instruction[30:21];
            for (i = 20; i < 32; i = i + 1)
            begin
                immediate[i] = immediate[19];
            end
        end
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/14 20:11:44
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire [31:0] writeData,
    input wire RegWrite,
    output reg [31:0] readData1,
    output reg [31:0] readData2
    );

    integer i;
    reg [31:0] Registers [0:31];

    initial begin // Initialization
        for (i = 0; i < 32; i = i + 1)begin
            Registers[i] = 32'b0;
        end
    end

    always @(*) begin // Read data
        readData1 = Registers[rs1];
        readData2 = Registers[rs2];
    end

    always @(*) begin // Write data // Now don't need clock. 
        if (RegWrite && rd != 5'b0) begin // RegWrite = 1 && rd != x0;
            Registers[rd] = writeData;
        end
    end


endmodule

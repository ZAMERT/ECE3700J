`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 00:20:51
// Design Name: 
// Module Name: ALU
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


module ALU(
    input wire [31:0] data1,
    input wire [31:0] data2,
    input wire [3:0] Control,
    output reg zero,
    output reg [31:0] ALUresult
    );
    always @(data1, data2, Control) begin
        case (Control)
            4'b0000: begin // AND
                ALUresult = data1 & data2; 
                zero = 1'b0; // Doesn't matter. 
            end
            4'b0001: begin // OR
                ALUresult = data1 | data2;
                zero = 1'b0; // Doesn't matter. 
            end
            4'b0010: begin // add
                ALUresult = data1 + data2;
                zero = 1'b0; // Doesn't matter. 
            end
            4'b0110: begin // sub or beq
                ALUresult = data1 - data2;
                if (ALUresult == 0) zero = 1'b1;
                else zero = 1'b0;
            end
            4'b1100: begin // Customer defined bne. 
                ALUresult = data1 - data2;
                if (ALUresult != 0) zero = 1'b1;
                else zero = 1'b0;
            end
            default: begin
                ALUresult = 32'b0;
                zero = 1'b0;
            end
        endcase
    end
endmodule

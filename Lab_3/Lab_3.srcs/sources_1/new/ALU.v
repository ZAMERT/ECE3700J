`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/14 19:07:47
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
    always @(*) begin
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
            4'b0011: begin // sll
                ALUresult = data1 << data2;
            end
            4'b0100: begin // srl
                ALUresult = data1 >> data2;
            end
            4'b0101: begin // sra
                ALUresult = $signed(data1) >>> data2;
            end
            4'b0110: begin // sub or beq
                ALUresult = data1 - data2;
                if (ALUresult == 0) zero = 1'b1;
                else zero = 1'b0;
            end
            4'b1000: begin // bge
                ALUresult = data1 - data2;
                if ($signed(data1) >= $signed(data2)) zero = 1'b1;
                else zero = 1'b0;
            end
            4'b1001: begin // blt
                ALUresult = data1 - data2;
                if ($signed(data1) < $signed(data2)) zero = 1'b1;
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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 12:11:06
// Design Name: 
// Module Name: Mux8to1
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


module Mux8to1(
    input wire [31:0] in1,
    input wire [31:0] in2,
    input wire [31:0] in3,
    input wire [31:0] in4,
    input wire [31:0] in5,
    input wire [31:0] in6,
    input wire [31:0] in7,
    input wire [31:0] in8,
    input wire [2:0] sel,
    output reg [31:0] out
    );

    always @(*) begin
        case (sel)
            3'b000: out = in1;
            3'b001: out = in2;
            3'b010: out = in3;
            3'b011: out = in4;
            3'b100: out = in5;
            3'b101: out = in6;
            3'b110: out = in7;
            3'b111: out = in8;
            default: out = 32'b0;
        endcase
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/15 00:03:09
// Design Name: 
// Module Name: Mux4to1
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


module Mux4to1(
    input wire [31:0] in1,
    input wire [31:0] in2,
    input wire [31:0] in3,
    input wire [31:0] in4,
    input wire [1:0] sel,
    output reg [31:0] out
    );

    always @(*) begin
        case (sel)
            2'b00: out = in1;
            2'b01: out = in2;
            2'b10: out = in3;
            2'b11: out = in4;
            default: out = 32'b0;
        endcase
    end
endmodule

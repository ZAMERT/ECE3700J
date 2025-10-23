`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 12:13:06
// Design Name: 
// Module Name: ShiftLeft
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


module ShiftLeft(
    input wire [31:0] in,
    output reg [31:0] out
    );
    always @(in) begin
        out[31:1] = in[30:0];
        out[0] = 1'b0;
    end
endmodule

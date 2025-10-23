`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 12:09:48
// Design Name: 
// Module Name: Mux
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


module Mux(
    input wire [31:0] in1,
    input wire [31:0] in2,
    input wire sel,
    output reg [31:0] out
    );

    always @(in1, in2, sel) begin
        case(sel)
            1'b0: out = in1;
            1'b1: out = in2;
            default: out = 32'b0;
        endcase        
    end
endmodule

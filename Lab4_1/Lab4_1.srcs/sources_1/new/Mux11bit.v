`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 12:11:51
// Design Name: 
// Module Name: Mux11bit
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


module Mux11bit(
    input wire [10:0] in1,
    input wire [10:0] in2,
    input wire sel,
    output reg [10:0] out
    );

    always @(in1, in2, sel) begin
        case(sel)
            1'b0: out = in1;
            1'b1: out = in2;
            default: out = 11'b0;
        endcase        
    end
endmodule

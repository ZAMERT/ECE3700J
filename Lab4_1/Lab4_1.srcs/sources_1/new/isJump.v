`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 12:08:18
// Design Name: 
// Module Name: isJump
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


module isJump(
    input wire [1:0] Jump_ID,
    input wire [1:0] Jump_EX,
    output reg [1:0] JumpSrc
    );

    always @(*) begin
        if(Jump_ID == 2'b01) begin
            JumpSrc = 2'b01;
        end
        else if(Jump_EX == 2'b10) begin
            JumpSrc = 2'b10;
        end
        else begin
            JumpSrc = 2'b00;
        end
    end
endmodule

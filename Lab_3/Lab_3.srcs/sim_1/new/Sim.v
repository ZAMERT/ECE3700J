`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/15 04:45:45
// Design Name: 
// Module Name: Sim
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


module Sim();
    parameter half_period = 3;
    reg clk;
    top TOP(clk);

    initial begin
        #3 clk = 0;
        forever begin
            #half_period clk = ~clk;
        end
    end
        
    initial begin
        forever #6 begin
            $display("time:",$time);
            $display("PC:%h",TOP.pc);
            $display("Inst:%h",TOP.inst_IF);
            $display("ra:%h",TOP.RF.Registers[1]);
            $display("x5(t0):%h",TOP.RF.Registers[5]);
            $display("x6(t1):%h",TOP.RF.Registers[6]);
            $display("x7(t2):%h",TOP.RF.Registers[7]);
            $display("x28(t3):%h",TOP.RF.Registers[28]);
            $display("x29(t4):%h",TOP.RF.Registers[29]);
        end
    end

    initial #600 $stop;
endmodule

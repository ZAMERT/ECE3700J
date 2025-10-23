`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 04:00:47
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
            $display("Inst:%h",TOP.inst);
            $display("x5(t0):%h",TOP.Reg.Registers[5]);
            $display("x6(t1):%h",TOP.Reg.Registers[6]);
            $display("x7(t2):%h",TOP.Reg.Registers[7]);
            $display("x28(t3):%h",TOP.Reg.Registers[28]);
            $display("x29(t4):%h",TOP.Reg.Registers[29]);
            $display("x8(s0):%h",TOP.Reg.Registers[8]);
            $display("x9(s1):%h",TOP.Reg.Registers[9]);
            $display("Mem[0]:%h",{TOP.dataMem.memory[3],TOP.dataMem.memory[2],TOP.dataMem.memory[1],TOP.dataMem.memory[0]});
            $display("Mem[4]:%h",{TOP.dataMem.memory[7],TOP.dataMem.memory[6],TOP.dataMem.memory[5],TOP.dataMem.memory[4]});
            // $display(TOP.dataMem.readData);
        end
    end

    initial #110 $stop;
endmodule

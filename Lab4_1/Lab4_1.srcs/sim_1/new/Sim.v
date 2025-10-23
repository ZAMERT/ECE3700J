`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/20 12:15:01
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
            // $display("Mem[0]:%h",{TOP.DataMem.memory[3],TOP.DataMem.memory[2],TOP.DataMem.memory[1],TOP.DataMem.memory[0]});
            // $display("Mem[4]:%h",{TOP.DataMem.memory[7],TOP.DataMem.memory[6],TOP.DataMem.memory[5],TOP.DataMem.memory[4]});
        end
    end

    initial #200 $stop;
endmodule

// module Sim();
//     reg clk;
// 	top test (clk);

//     initial begin
//         #1 clk = 0;
//     end

//     initial begin
//         while ($time < 60) @(posedge clk)begin
//             $display("===============================================");
//             $display("Clock cycle %d, PC = %H", $time/2, test.inst_IF);
//             $display("ra = %H, t0 = %H, t1 = %H", test.RF.Registers[1], test.RF.Registers[5], test.RF.Registers[6]);
//             $display("t2 = %H, t3 = %H, t4 = %H", test.RF.Registers[7], test.RF.Registers[28], test.RF.Registers[29]);
//             $display("===============================================");
//         end
//         $finish();
//     end
//     always #1 clk = ~clk;
// endmodule

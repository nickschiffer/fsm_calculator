`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2018 10:42:42 PM
// Design Name: 
// Module Name: Full_Calculator_FPGA
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


module Full_Calculator_FPGA(
    input go, clk100MHz, rst, man_clk,
    input [3:0] X, Y,
    input [1:0] F,
    output [7:0] LEDSEL, LEDOUT,
    output done,
    output [3:0] H, L
    );
    
    supply1 [7:0] vcc;
    wire DONT_USE, clk_5KHz;
    wire
endmodule

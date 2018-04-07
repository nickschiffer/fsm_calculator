`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2018 04:15:24 PM
// Design Name: 
// Module Name: DP_tb
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


module DP_tb;

//TB reg's
reg [2:0] in1_tb, in2_tb, out_tb;
reg [1:0] s1_tb, wa_tb, raa_tb, rab_tb, c_tb;
reg we_tb, rea_tb, reb_tb, s2_tb, clk_tb;

//DUT
DP DUT(
.in1(in1_tb),
.in2(in2_tb),
.s1(s1_tb),
.wa(wa_tb),
.raa(raa_tb),
.rab(rab_tb),
.c(c_tb),
.we(we_tb),
.rea(rea_tb),
.reb(reb_tb),
.s2(s2_tb),
.clk(clk_tb),
.out(out_tb));  
endmodule

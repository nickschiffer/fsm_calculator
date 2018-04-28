`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2018 03:24:12 PM
// Design Name: 
// Module Name: DP
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


module Calc_DP(
input [2:0] in1, in2,
input [1:0] s1, wa, raa, rab, c,
input we, rea, reb, s2, clk,
output [2:0] out
);

wire [2:0] mux1out;
wire [2:0] douta;
wire [2:0] doutb;
wire [2:0] aluout;
// Instantiate Buidling Blocks
Calc_MUX1 M1 (.in1(in1), .in2(in2), .in3(3'b000), .in4(aluout), .s1(s1), .m1out(mux1out));

Calc_RF  RF1 (.clk(clk), .rea(rea), .reb(reb), .raa(raa), .rab(rab), .we(we), .wa(wa), .din(mux1out), .douta(douta), .doutb(doutb));

Calc_ALU ALU1 (.in1(douta), .in2(doutb), .c(c), .aluout(aluout));

Calc_MUX2 M2 (.in1(aluout), .in2(3'b000), .s2(s2), .m2out(out));
endmodule

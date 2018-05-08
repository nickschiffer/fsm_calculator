`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2018 02:51:45 PM
// Design Name: 
// Module Name: Calculator_Top
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


module Calculator_Top #(parameter Data_width = 4)(
    input go,
    input [1:0] op,
    input clk, rst,
    input [Data_width - 1:0] in1, in2,
    output [3:0] cs,
    output [Data_width - 1:0] out,
    output done
);

wire [14:0] cw;
wire [1:0] s1, wa, raa, rab, c;
wire we, rea, reb, s2;
//s1[14:13], wa[12:11], we[10], raa[9:8], rea[7], rab[6:5], reb[4], c[3:2], s2[1], done[0]
assign {s1, wa, we, raa, rea, rab, reb, c, s2, done} = cw;

Calc_CU CU (
    .go(go),
    .clk(clk),
    .op(op),
    .cs(cs),
    .cw(cw),
    .rst(rst)
);
    
Calc_DP #(Data_width) DP (
    .in1(in1),
    .in2(in2),
    .s1(s1),
    .wa(wa),
    .raa(raa),
    .rab(rab),
    .c(c),
    .we(we),
    .rea(rea),
    .reb(reb),
    .s2(s2),
    .clk(clk),
    .out(out)
);
endmodule

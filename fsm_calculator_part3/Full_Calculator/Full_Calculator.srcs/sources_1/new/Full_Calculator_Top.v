`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2018 10:17:04 PM
// Design Name: 
// Module Name: Full_Calculator_Top
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


module Full_Calculator_Top(
    input [3:0] X, Y,
    input [1:0] F,
    input clk, Go, rst,
    output [3:0] Out_H, Out_L,
    output done
);

wire Done_Calc, Done_Div;
wire En_X, En_Y, En_F;
wire Go_Calc, Go_Div;
wire [1:0] Op_Calc;
wire Sel_H;
wire [1:0] Sel_L;
wire En_Out_H, En_Out_L;
wire RST_OUT_H, RST_OUT_L;
wire F_Out;


    Full_Calculator_DP DP (
        .clk(clk), .rst(rst),
        .X(X), .Y(Y), .F(F),
        .En_X(), .En_Y(), .En_F(),
        .Go_Calc(Go_Calc), .Go_Div(Go_Div),
        .Op_Calc(Op_Calc),
        .Sel_H(Sel_H), .Sel_L(Sel_L),
        .En_Out_H(En_Out_H), .En_Out_L(En_Out_L),
        .RST_OUT_H(RST_OUT_H), .RST_OUT_L(RST_OUT_L),
        .Done_Calc(Done_Calc), .Done_Div(Done_Div),
        .Out_H(Out_H), .Out_L(Out_L),
        .F_Out(F_Out)
    );
    
    Full_Calculator_CU CU (
        .Go(Go), .clk(clk), .rst(rst),
        .F(F_Out),
        .done(done),
        
        .Done_Calc(Done_Calc), .Done_Div(Done_Div),
        .En_X(En_X), .En_Y(En_Y), .En_F(En_F),
        .Go_Calc(Go_Calc), .Go_Div(Go_Div),
        .Op_Calc(Op_Calc),
        .Sel_H(Sel_H), .Sel_L(Sel_L),
        .En_Out_H(En_Out_H), .En_Out_L(En_Out_L),
        .RST_OUT_H(RST_OUT_H), .RST_OUT_L(RST_OUT_L)
    );



endmodule

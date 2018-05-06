`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2018 07:36:30 PM
// Design Name: 
// Module Name: Full_Calculator_DP
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


module Full_Calculator_DP(
    input clk, rst,
    input [3:0] X, Y,
    input [2:0] F,
    input En_F, En_X, En_Y,
    input Go_Calc, Go_Div,
    input [1:0] Op_Calc,
    input Sel_H, 
    input [1:0] Sel_L,
    input Calc_Mux_Sel, Mul_Mux_Sel,
    input En_Out_H, En_Out_L,
    input RST_OUT_H, RST_OUT_L,
    output Done_Calc, Done_Div,
    output [3:0] Out_H, Out_L,
    output [2:0] F_Out
);

wire [3:0] X_Out, Y_Out, Mux_H_Out, Mux_L_Out;
wire [3:0] PH, PL, Q, R;
wire [1:0] Div_done_err;
assign Done_Div = Div_done_err[1];
wire [3:0] Calc_Out;

//Additional Operator Muxes
wire [3:0] Calc_Mux_Out;
wire [3:0] Mul_Mux_Out;

D_FF #(4) X_Reg      (.clk(clk), .rst(1'b0), .en(En_X), .D(X), .Q(X_Out));
D_FF #(4) Y_Reg      (.clk(clk), .rst(1'b0), .en(En_Y), .D(Y), .Q(Y_Out));
D_FF #(3) F_Reg      (.clk(clk), .rst(1'b0), .en(En_F), .D(F), .Q(F_Out));
D_FF #(4) OUT_H_Reg  (.clk(clk), .rst(RST_OUT_H), .en(En_Out_H), .D(Mux_H_Out), .Q(Out_H));
D_FF #(4) OUT_L_Reg  (.clk(clk), .rst(RST_OUT_L), .en(En_Out_L), .D(Mux_L_Out), .Q(Out_L));

combinational_unsigned_integer_multiplier MULT (
    .A(X_Out),
    .B(Mul_Mux_Out),
    .P({PH, PL})
);

Calculator_Top #(4) CALC (
    .go(Go_Calc),
    .op(Op_Calc),
    .clk(clk),
    .in1(X_Out), .in2(Calc_Mux_Out),
    .out(Calc_Out),
    .done(Done_Calc)
);

Integer_Divider_Top DIV(
    .go(Go_Div),
    .clk(clk),
    .rst(rst),
    .dividend(X_Out),
    .divisor(Y_Out),
    .quotient(Q),
    .remainder(R),
    .err_done(Div_done_err)
);


MUX2 #(4) MUX_H (.d1(PH), .d0(R), .sel(Sel_H), .out(Mux_H_Out));
MUX4 #(4) MUX_L (.d3(4'b0), .d2(Calc_Out), .d1(PL), .d0(Q), .sel(Sel_L), .out(Mux_L_Out));

// Additional Operator Muxes
MUX2 #(4) Calc_Mux (.d1(4'b1), .d0(Y_Out), .out(Calc_Mux_Out), .sel(Calc_Mux_Sel));
MUX2 #(4) Mult_Mux (.d1(X_Out), .d0(Y_Out), .out(Mul_Mux_Out), .sel(Mul_Mux_Sel));





endmodule

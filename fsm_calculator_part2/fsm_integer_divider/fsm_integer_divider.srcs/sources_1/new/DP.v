`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2018 03:33:54 PM
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


module DP(
input [3:0] dividend, divisor,
input clk, rst,
input [2:0] mux_cw,
input [6:0] UD_counter_cw,
input [3:0] SRX_cw,
input [1:0] SRY_cw,
input [3:0] SRR_cw,
output [7:0] sw,
output [3:0] quotient, remainder

    );

//Status Word sw = {R_lt_y, cnt_out, divisor}
wire R_lt_Y;
wire [2:0] cnt_out;
assign sw = {R_lt_Y, cnt_out, divisor};

// Interconnects
wire [3:0] RIN_mux_out, R_mux_out, Q_mux_out;
wire [3:0] sub_out;
wire [3:0] Y_out, X_out;
wire [4:0] R_out;

//Outputs
assign quotient = Q_mux_out;
assign remainder = R_mux_out;

// Control Signals
    // Muxes
        // RIN
            wire RIN_mux_sel;
        // R
            wire R_mux_sel;
        // Q
            wire Q_mux_sel;
    // UD Counter
        wire [2:0] UD_D;
        wire UD_ld;
        wire UD_ud;
        wire UD_ce;
        wire UD_rst;
    // Shift Registers
        // X
           wire SRX_rst;
           wire SRX_sl;
           wire SRX_ld;
           wire SRX_rightIn;
        // Y
           wire SRY_rst;
           wire SRY_ld;
        // R
           wire SRR_rst;
           wire SRR_sl;
           wire SRR_sr;
           wire SRR_ld;
           wire SRR_rightIn;
           assign SRR_rightIn = X_out[3];
// Update Control Signals
assign {RIN_mux_sel, R_mux_sel, Q_mux_sel}            = mux_cw;
assign {UD_D, UD_ld, UD_ud, UD_ce, UD_rst}            = UD_counter_cw;
assign {SRX_rst, SRX_sl, SRX_ld, SRX_rightIn}         = SRX_cw;
assign {SRY_rst, SRY_ld}                              = SRY_cw;
assign {SRR_rst, SRR_sl, SRR_sr, SRR_ld}              = SRR_cw;

// Initiate Modules    
UD_counter           #(3) COUNT  (.D(UD_D), .Q(cnt_out), .ld(UD_ld), .ud(UD_ud), .ce(UD_ce),.clk(clk), .rst(UD_rst));
mux_2_to_1           #(4) RINMUX (.d1(sub_out), .d0(4'b0), .sel(RIN_mux_sel), .y(RIN_mux_out));
mux_2_to_1           #(4) RMUX   (.d1(R_out[3:0]), .d0(4'b0), .sel(R_mux_sel), .y(R_mux_out));
mux_2_to_1           #(4) QMUX   (.d1(X_out), .d0(4'b0), .sel(Q_mux_sel), .y(Q_mux_out));
shift_register       #(4) X      (.D(dividend), .Q(X_out), .sl(SRX_sl), .sr(1'b0), .ld(SRX_ld), .leftIn(1'b0), .rightIn(SRX_rightIn), .rst(SRX_rst), .clk(clk));
shift_register       #(4) Y      (.D(divisor),  .Q(Y_out), .sl(1'b0), .sr(1'b0), .ld(SRY_ld), .leftIn(1'b0), .rightIn(1'b0), .rst(SRY_rst), .clk(clk));
shift_register       #(5) R      (.D({R_out[4],RIN_mux_out}), .Q({R_out}), .sl(SRR_sl), .sr(SRR_sr), .ld(SRR_ld), .leftIn(1'b0), .rightIn(SRR_rightIn), .rst(SRR_rst), .clk(clk));
subractor            #(4) SUB    (.A(R_out[3:0]), .B(Y_out), .C(sub_out));
magnitude_comparator #(4) COMP   (.A(R_out[3:0]), .B(Y_out), .less_than(R_lt_Y));




endmodule

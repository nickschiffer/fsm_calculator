`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2018 04:55:55 PM
// Design Name: 
// Module Name: Integer_Divider_Top
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


module Integer_Divider_Top(
    input go,
    input clk,
    input rst,
    input [3:0] dividend,
    input [3:0] divisor,
    output [3:0] cs,
    output [3:0] quotient,
    output [3:0] remainder,
    output [1:0] err_done
);

wire [7:0] sw_from_DP;
wire [2:0] mux_cw_from_CU;
wire [6:0] UD_counter_cw_from_CU;
wire [3:0] SRX_cw_from_CU;
wire [1:0] SRY_cw_from_CU;
wire [3:0] SRR_cw_from_CU;
wire [1:0] done_err_from_CU;
wire [3:0] cs_from_CU;
wire [3:0] quotient_from_DP;
wire [3:0] remainder_from_DP;
wire R_lt_Y_inf;

assign cs = cs_from_CU;
assign err_done = done_err_from_CU;
assign quotient = quotient_from_DP;
assign remainder = remainder_from_DP;

Div_CU CU (
    .go(go),
    .clk(clk),
    .rst(rst),
    .sw(sw_from_DP),
    .mux_cw(mux_cw_from_CU),
    .UD_counter_cw(UD_counter_cw_from_CU),
    .SRX_cw(SRX_cw_from_CU),
    .SRY_cw(SRY_cw_from_CU),
    .SRR_cw(SRR_cw_from_CU),
    .done_err(done_err_from_CU),
    .cs(cs_from_CU),
    .R_lt_Y_inf(R_lt_Y_inf)
);


Div_DP DP (
    .dividend(dividend),
    .divisor(divisor),
    .clk(clk),
    .rst(rst),
    .mux_cw(mux_cw_from_CU),
    .UD_counter_cw(UD_counter_cw_from_CU),
    .SRX_cw(SRX_cw_from_CU),
    .SRY_cw(SRY_cw_from_CU),
    .SRR_cw(SRR_cw_from_CU),
    .sw(sw_from_DP),
    .quotient(quotient_from_DP),
    .remainder(remainder_from_DP),
    .R_lt_Y_inf(R_lt_Y_inf)
);


endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2018 04:22:39 PM
// Design Name: 
// Module Name: Integer_Divider_FPGA
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


module Integer_Divider_FPGA(
    input go, clk100MHz, rst, man_clk,
    input [3:0] dividend, divisor,
    output [7:0] LEDSEL, LEDOUT,
    output done, error,
    output [3:0] dividend_out, divisor_out
    );

    supply1 [7:0] vcc;
    wire DONT_USE, clk_5KHz;
    wire debounced_clk;
    wire [7:0] LED0, LED1, LED2, LED3, LED7;
    wire [3:0] Q_BCD_ones, Q_BCD_tens, R_BCD_ones, R_BCD_tens, CS_BCD;
    wire [3:0] cs;
    wire [3:0] quotient, remainder;
    wire [1:0] err_done;

    Integer_Divider_Top DIV (
        .go(go),
        .clk(debounced_clk),
        .rst(rst),
        .dividend(dividend),
        .divisor(divisor),
        .cs(cs),
        .quotient(quotient),
        .remainder(remainder),
        .err_done(err_done)
    );

    button_debouncer DBNC (
        .clk(clk_5KHz), 
        .button(man_clk), 
        .debounced_button(debounced_clk)
    );

    BIN_to_BCD Q (
        .binary(quotient),
        .ones(Q_BCD_ones),
        .tens(Q_BCD_tens)
    );

    BIN_to_BCD R (
        .binary(remainder),
        .ones(R_BCD_ones),
        .tens(R_BCD_tens)
    );

    BIN_to_BCD CS (
        .binary(cs),
        .ones(CS_BCD)
    );

    bcd_to_7seg Q7seg0 (
        .BCD(Q_BCD_ones),
        .s(LED2)
    );

    bcd_to_7seg Q7seg1 (
        .BCD(Q_BCD_tens),
        .s(LED3)
    );

    bcd_to_7seg R7seg0 (
        .BCD(R_BCD_ones),
        .s(LED0)
    );

    bcd_to_7seg R7seg1 (
        .BCD(R_BCD_tens),
        .s(LED1)
    );

    bcd_to_7seg CSLED (
        .BCD(CS_BCD),
        .s(LED7)
    );

    led_mux LED (
        .clk(clk_5KHz),
        .rst(rst),
        .LED7(LED7), .LED6(vcc), .LED5(vcc), .LED4(vcc), .LED3(LED3), .LED2(LED2), .LED1(LED1), .LED0(LED0),
        .LEDSEL(LEDSEL), .LEDOUT(LEDOUT)
    );

    clk_gen CLK (clk100MHz, rst, DONT_USE, clk_5KHz);

    assign done = err_done[1];
    assign error = err_done[0];
    assign dividend_out = dividend;
    assign divisor_out = divisor;

endmodule

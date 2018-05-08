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
    input [2:0] F,
    output [7:0] LEDSEL, LEDOUT,
    output done
    );
    
    supply1 [7:0] vcc;
    wire DONT_USE, clk_5KHz;
    wire debounced_clk;
    wire [7:0] LED0, LED1, LED2, LED3, LED7;
    wire [3:0] Out_H, Out_L;
    wire [3:0] cs;
    
    Full_Calculator_Top CALC(
        .X(X), .Y(Y), .F(F),
        .clk(debounced_clk), .go(go), .rst(rst),
        .Out_H(Out_H), .Out_L(Out_L),
        .cs(cs),
        .done(done) 
    );
    
    
    button_debouncer DBNC (
        .clk(clk_5KHz), 
        .button(man_clk), 
        .debounced_button(debounced_clk)
    );
    
    led_mux LED (
        .clk(clk_5KHz),
        .rst(rst),
        .LED7(LED7), .LED6(vcc), .LED5(vcc), .LED4(vcc), .LED3(LED3), .LED2(LED2), .LED1(LED1), .LED0(LED0),
        .LEDSEL(LEDSEL), .LEDOUT(LEDOUT)
    );

    clk_gen CLK (clk100MHz, rst, DONT_USE, clk_5KHz);
    
    
    
    
    
endmodule

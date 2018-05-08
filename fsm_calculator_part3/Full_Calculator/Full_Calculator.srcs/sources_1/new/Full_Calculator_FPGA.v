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
    output done,
    output [3:0] X_out, Y_out,
    output [2:0] F_out
    );
    
    supply1 [7:0] vcc;
    wire DONT_USE, clk_5KHz;
    wire debounced_clk;
    reg  [7:0] LED0, LED1, LED2, LED3;
    wire [7:0] LED7, LED6;
    wire [3:0] Out_H, Out_L;
    wire [3:0] cs;
    wire [3:0] cs_BCD_ones, cs_BCD_tens;
    
    wire [3:0] Calc_tens, Calc_ones;
    wire [3:0] Mult_hundreds, Mult_tens, Mult_ones;
    wire [3:0] Div_Q_tens, Div_Q_ones;
    wire [3:0] Div_R_tens, Div_R_ones;
    
    
    wire [7:0] Calc_LED0, Calc_LED1;
    wire [7:0] Mult_LED0, Mult_LED1, Mult_LED2;
    wire [7:0] Div_LED0, Div_LED1, Div_LED2, Div_LED3;
    
    Full_Calculator_Top CALC(
        .X(X), .Y(Y), .F(F),
        .clk(debounced_clk), .Go(go), .rst(rst),
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
        .LED7(LED7), .LED6(LED6), .LED5(vcc), .LED4(vcc), .LED3(LED3), .LED2(LED2), .LED1(LED1), .LED0(LED0),
        .LEDSEL(LEDSEL), .LEDOUT(LEDOUT)
    );

    clk_gen CLK (clk100MHz, rst, DONT_USE, clk_5KHz);
    
    
    BIN_to_BCD CS_BCD_ones (
        .binary(cs),
        .ones(cs_BCD_ones),
        .tens(cs_BCD_tens)
    );

    
    BIN_to_BCD CALC_BCD (
        .binary(Out_L),
        .tens(Calc_tens),
        .ones(Calc_ones)
    );
    
    P_2_BCD MULT_BCD (
        .P({Out_H, Out_L}),
        .hundreds(Mult_hundreds),
        .tens(Mult_tens),
        .ones(Mult_ones)
    );
    
    BIN_to_BCD DIV_Q_BCD (
        .binary(Out_H),
        .tens(Div_Q_tens),
        .ones(Div_Q_ones)
    );
    
    BIN_to_BCD DIV_R_BCD (
        .binary(Out_L),
        .tens(Div_R_tens),
        .ones(Div_R_ones)
    );
    
    bcd_to_7seg CS_LED7 (
        .BCD(cs_BCD_tens),
        .s(LED7)
    );
    
    bcd_to_7seg CS_LED6 (
        .BCD(cs_BCD_ones),
        .s(LED6)
    );

    
    bcd_to_7seg CALC_LED0 (
        .BCD(Calc_ones),
        .s(Calc_LED0)
    );
    
    bcd_to_7seg CALC_LED1 (
        .BCD(Calc_tens),
        .s(Calc_LED1)
    );   
    
    bcd_to_7seg MULT_LED0 (
        .BCD(Mult_ones),
        .s(Mult_LED0)
    );
    
    bcd_to_7seg MULT_LED1 (
        .BCD(Mult_tens),
        .s(Mult_LED1)
    );
    
    bcd_to_7seg MULT_LED2 (
         .BCD(Mult_hundreds),
         .s(Mult_LED2)
    );

    bcd_to_7seg DIV_LED0 (
         .BCD(Div_R_ones),
         .s(Div_LED0)
    );
    
    bcd_to_7seg DIV_LED1 (
         .BCD(Div_R_tens),
         .s(Div_LED1)
    );    

    bcd_to_7seg DIV_LED2 (
         .BCD(Div_Q_ones),
         .s(Div_LED2)
    );    

    bcd_to_7seg DIV_LED3 (
         .BCD(Div_Q_ones),
         .s(Div_LED3)
    );    

    

    always @ (*)
    begin
        casez(F)
            3'b?0?: // Calc
                    begin
                        LED0 <= Calc_LED0;
                        LED1 <= Calc_LED1;
                        LED2 <= 8'b10001000;
                        LED3 <= 8'b10001000;
                    end
            3'b?10: // Mult
                    begin
                        LED0 <= Mult_LED0;
                        LED1 <= Mult_LED1;
                        LED2 <= Mult_LED2;
                        LED3 <= 8'b10001000;
                    end
            3'b?11: // Div
                    begin
                        LED0 <= Div_LED0;
                        LED1 <= Div_LED1;
                        LED2 <= Div_LED2;
                        LED3 <= Div_LED3;
                    end
        endcase
    end
    
    assign X_out = X;
    assign Y_out = Y;
    assign F_out = F;
            
    
    
    
    
    
endmodule

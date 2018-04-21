`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2018 03:46:25 PM
// Design Name: 
// Module Name: Calculator_FPGA
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


module Calculator_FPGA(
input go, clk100MHz, rst, man_clk,
input [1:0] op,
input [2:0] in1, in2,
output [2:0] in1_out, in2_out,
output [7:0] LEDSEL, LEDOUT,
output done
);

assign in1_out = in1;
assign in2_out = in2;

supply1 [7:0] vcc;
wire DONT_USE, clk_5KHz;
wire debounced_go;
wire debounced_man_clk;

wire [3:0] cs, out;
wire [7:0] Result_LED, CS_LED;
button_debouncer DBNC1 (
    .clk(clk_5KHz),
    .button(go),
    .debounced_button(debounced_go)
);

button_debouncer DBNC2 (
    .clk(clk_5KHz),
    .button(man_clk),
    .debounced_button(debounced_man_clk)
);

Calculator_Top CALC (
    .go(debounced_go),
    .op(op),
    .clk(debounced_man_clk),
    .in1(in1),
    .in2(in2),
    .cs(cs),
    .out(out),
    .done(done)

);

bcd_to_7seg BCD1 (out, Result_LED);
bcd_to_7seg BCD2 (cs, CS_LED);


led_mux LED (clk_5KHz, rst, vcc, vcc, vcc, CS_LED, vcc, vcc, vcc, Result_LED, LEDSEL, LEDOUT);
clk_gen CLK (clk100MHz, rst, DONT_USE, clk_5KHz);
endmodule

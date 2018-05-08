`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2018 03:59:44 PM
// Design Name: 
// Module Name: MUX2
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


module Calc_MUX2 #(parameter Data_width = 4)(
    input [Data_width - 1:0] in1, in2,
    input s2,
    output reg [Data_width - 1:0] m2out
);

always @ (in1, in2, s2)
begin
    if(s2)
        m2out = in1;
    else
        m2out = in2;
end
endmodule

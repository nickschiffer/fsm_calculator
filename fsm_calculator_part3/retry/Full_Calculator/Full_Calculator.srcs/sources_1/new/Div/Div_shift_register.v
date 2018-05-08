`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2018 02:28:39 PM
// Design Name: 
// Module Name: shift_register
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


module Div_shift_register #(parameter dataIN_width=4)(
    input clk, rst, sl, sr, ld, leftIn, rightIn,
    input [dataIN_width - 1 : 0] D,
    output reg [dataIN_width - 1 : 0] Q
    );

always @ (posedge clk)
begin
    if (rst)
        Q = 0;
    else if (ld)
        Q = D;
    else if (sl) // Shift Left
        begin
            Q[dataIN_width - 1 : 1] = Q[dataIN_width - 2 : 0];
            Q[0] = rightIn;
        end
    else if (sr) // Shift Right
        begin
            Q[dataIN_width - 2 : 0] = Q[dataIN_width - 1 : 1];
            Q[dataIN_width - 1] = leftIn; 
        end
    else
        Q[dataIN_width - 1 : 0] = Q[dataIN_width - 1 : 0];
end
endmodule

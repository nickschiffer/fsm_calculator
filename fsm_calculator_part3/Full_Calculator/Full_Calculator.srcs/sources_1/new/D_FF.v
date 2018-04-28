`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2018 09:06:25 PM
// Design Name: 
// Module Name: D_FF
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


module D_FF #(parameter Data_width = 4)(
    input clk, rst, en,
    input [Data_width - 1:0] D,
    output reg [Data_width - 1:0] Q
    );
    
    always@ (posedge clk)
    begin
        if (rst)
            Q <= 0;
        else if (en)
            Q <= D;
        else
            Q <= Q;
    end
endmodule

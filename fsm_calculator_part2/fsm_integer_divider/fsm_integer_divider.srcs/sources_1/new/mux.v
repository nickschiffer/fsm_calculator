`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2018 02:19:41 PM
// Design Name: 
// Module Name: mux
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


module mux_2_to_1 #(parameter dataIN_width = 4)(
    input [dataIN_width - 1 : 0] d1, d0,
    input sel,
    output reg [dataIN_width - 1 : 0] y
    );

always @ (d1, d0, sel)
begin
    if (sel)
        y <= d1;
    else
        y <= d0; 
end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2018 09:40:44 PM
// Design Name: 
// Module Name: mux2
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


module MUX2 #(parameter Data_width = 4)(
input [Data_width - 1:0] d0, d1,
input sel,
output reg [Data_width - 1:0] out 
);

always @ (d0, d1, sel)
begin
        if (sel)
            out <= d1;
        else
            out <= d0;
end
endmodule
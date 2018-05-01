`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2018 09:45:23 PM
// Design Name: 
// Module Name: mux4
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


module MUX4 #(parameter Data_width = 4)(
input [Data_width - 1:0] d0, d1, d2, d3,
input [1:0] sel,
output reg [Data_width - 1:0] out 
);

always @ (d0, d1, d2, d3, sel)
begin
       case (sel)
            2'b00: out <= d0;
            2'b01: out <= d1;
            2'b10: out <= d2;
            2'b11: out <= d3;
        endcase
end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2018 03:16:16 PM
// Design Name: 
// Module Name: UD_counter
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


module Div_UD_counter #(parameter bus_width = 4)(
    input clk,                            // Synchronous Clock
    input rst,                            // Synchronous Reset
    input [bus_width - 1 : 0] D,          // Input Data
    input ld,                             // Control Signal - load
    input ud,                             // Control Signal - up/down
    input ce,                             // Control Signal - clock enable
    output reg [bus_width - 1 : 0] Q      // Output Data
    );
    
always @ (posedge clk, negedge rst)
begin
    if (!rst)
        Q = 0;
    else if (ce)
        begin
            if (ld)
                Q = D;
            else if (ud)
                Q = Q + 1'b1;
            else
                Q = Q - 1'b1;
        end
    else
        Q = Q;
end
endmodule

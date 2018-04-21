`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2018 02:05:33 PM
// Design Name: 
// Module Name: magnitude_comparator
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


module magnitude_comparator #(parameter dataIN_width = 4) (
    input [dataIN_width - 1 : 0] A, B,
    output reg equal_to, greater_than, less_than
    );
    
 always @ (A, B)
 begin
    equal_to         <= 1'b0;
    greater_than     <= 1'b0;
    less_than        <= 1'b0;
    if (A > B)
        greater_than <= 1'b1;
    else if (A < B)
        less_than    <= 1'b1;
    else
        equal_to     <= 1'b1;
 end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2018 02:16:02 PM
// Design Name: 
// Module Name: subractor
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


module subractor #(parameter dataIN_width = 4)(
    input [dataIN_width - 1 : 0]     A, B,
    output reg [dataIN_width -1 : 0] C
    );
    
always @ (A, B)
    C <= A - B;


endmodule

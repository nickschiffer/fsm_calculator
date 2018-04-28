`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2018 03:48:44 PM
// Design Name: 
// Module Name: RF
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


module Calc_RF(
input clk, rea, reb, we,
input [1:0] raa, rab, wa,
input [2:0] din,
output reg [2:0] douta, doutb
);

reg [2:0] RegFile [3:0];

always @ (rea, reb, raa, rab)
begin
        if (rea)
            douta = RegFile[raa];
        else douta = 3'b000;
        if (reb)
            doutb = RegFile[rab];
        else doutb = 3'b000;
end

always @ (posedge clk)
begin
        if(we)
            RegFile[wa] <= din;
        else
            RegFile[wa] <= RegFile[wa];
end
endmodule

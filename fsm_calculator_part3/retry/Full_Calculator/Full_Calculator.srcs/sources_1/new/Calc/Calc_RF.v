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


module Calc_RF #(parameter Data_width = 4)(
input clk, rea, reb, we,
input [1:0] raa, rab, wa,
input [Data_width - 1:0] din,
output reg [Data_width - 1:0] douta, doutb
);

reg [Data_width - 1:0] RegFile [3:0];

always @ (rea, reb, raa, rab)
begin
        if (rea)
            douta = RegFile[raa];
        else douta = 0;
        if (reb)
            doutb = RegFile[rab];
        else doutb = 0;
end

always @ (posedge clk)
begin
        if(we)
            RegFile[wa] <= din;
        else
            RegFile[wa] <= RegFile[wa];
end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2018 04:35:56 PM
// Design Name: 
// Module Name: BIN_to_BCD
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


module BIN_to_BCD(
    input [3:0] binary,
    output reg [3:0] tens, ones
);

integer i;

always @(binary)
begin
  tens = 4'b0;
  ones = 4'b0;

  for (i = 3; i >= 0; i = i - 1)
    begin
        if (tens >= 5)
            tens = tens + 3;
        if (ones >= 5)
            ones = ones + 3;

        tens = tens << 1;
        tens[0] = ones[3];
        ones = ones << 1;
        ones[0] = binary[i];
    end
end
endmodule

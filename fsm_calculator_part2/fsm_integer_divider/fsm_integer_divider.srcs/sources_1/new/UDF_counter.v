`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2018 02:59:38 PM
// Design Name: 
// Module Name: UDF_counter
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


module UDF_counter #(parameter bus_width = 2, up = 0, down = 1)(
    input clk,                            // Synchronous Clock
    input rst,                            // Asynchronous Reset
    input [bus_width - 1 : 0] Din,        // Input Data
    input [bus_width - 1 : 0] count_to,   // Input Data
    input ld,                             // Control Signal - load
    input ud,                             // Control Signal - up/down
    input ce,                             // Control Signal - clock enable
    output reg [bus_width - 1 : 0] count, // Output Data
    output reg flag                       // Output data - flag
    );
    
always @ (posedge clk)
begin
    if (rst)
        begin
            count = 0;
            flag = 0;
        end
    else if (ce)
        begin
            if (ld)
                count = Din;
            else // Count up or down
                begin
                    case(ud)
                        down:   count = count - 1;
                        up:     count = count + 1;
                    endcase
                        if (count == count_to)
                            flag = 1'b1;
                        else
                            flag = 1'b1;
            end
        end
    else
        count = count;
end
endmodule

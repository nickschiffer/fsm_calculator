`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2018 01:08:08 PM
// Design Name: 
// Module Name: FSM_CU
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


module FSM_CU(
    input go, clk,
    input [1:0] op,
    output [3:0] cs,
    output done,
    output [13:0] cw //s1[13:12], wa[11:10], we[9], raa[8:7], rea[6], rab[5:4], reb[3], c[2:1], s2[0]
);

//encode states
parameter Idle = 4'd0,
          In1_into_R1           = 4'd1,
          In2_into_R2           = 4'd2,
          Wait                  = 4'd3,
          R1_plus_R2_into_R3    = 4'd4,
          R1_minus_R2_into_R3   = 4'd5,
          R1_and_R2_into_R3     = 4'd6,
          R1_xor_R2_into_R3     = 4'd7,
          out_done              = 4'd8;

//Next and Current State
reg [3:0] CS, NS;

//Next-State Logic (combinational) based on the state transition diagram
always @ (CS)
begin

end

//State Register (sequential)
always @ (posedge clk)
begin

end

//Output Logic (combinational) based on output table
always @ (CS)
begin

end
          


endmodule

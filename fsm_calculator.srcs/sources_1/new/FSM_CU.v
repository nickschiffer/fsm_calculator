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
    output reg [14:0] cw //s1[14:13], wa[12:11], we[10], raa[9:8], rea[7], rab[6:5], reb[4], c[3:2], s2[1], done[0]
);

//encode states
parameter Idle                  = 4'd0,
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
always @ (CS, go)
begin
    case(CS)
        Idle:                   NS = (go) ? In1_into_R1 : Idle;
        In1_into_R1:            NS = In2_into_R2;
        In2_into_R2:            NS = Wait;
        Wait:
            begin
                  case(op)
                     2'b11:     NS = R1_plus_R2_into_R3;
                     2'b10:     NS = R1_minus_R2_into_R3;
                     2'b01:     NS = R1_and_R2_into_R3;
                     2'b00:     NS = R1_xor_R2_into_R3;
                  endcase
            end
        R1_plus_R2_into_R3:     NS = out_done;
        R1_minus_R2_into_R3:    NS = out_done;
        R1_and_R2_into_R3:      NS = out_done;
        R1_xor_R2_into_R3:      NS = out_done;
        out_done:               NS = Idle;
        default:                NS = Idle;
     endcase
end

//State Register (sequential)
always @ (posedge clk)
    CS <= NS;

//Output Logic (combinational) based on output table
always @ (CS)
begin
    case(CS)               //cw <= {s1, wa, we, raa, rea, rab, reb, c, s2, done}
        Idle:                cw <= 15'b01_00_0_00_0_00_0_00_0_0;
        In1_into_R1:         cw <= 15'b11_01_1_00_0_00_0_00_0_0;
        In2_into_R2:         cw <= 15'b10_10_1_00_0_00_0_00_0_0;
        Wait:                cw <= 15'b01_00_0_00_0_00_0_00_0_0;
        R1_plus_R2_into_R3:  cw <= 15'b00_11_1_01_1_10_1_00_0_0;
        R1_minus_R2_into_R3: cw <= 15'b00_11_1_01_1_10_1_01_0_0;
        R1_and_R2_into_R3:   cw <= 15'b00_11_1_01_1_10_1_10_0_0;
        R1_xor_R2_into_R3:   cw <= 15'b00_11_1_01_1_10_1_11_0_0;
        out_done:            cw <= 15'b01_00_0_11_1_11_1_10_1_1;    
    endcase

end
          


endmodule

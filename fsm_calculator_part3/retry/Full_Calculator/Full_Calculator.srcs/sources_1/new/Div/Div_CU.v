`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2018 05:11:15 PM
// Design Name: 
// Module Name: CU
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


module Div_CU(
    input go, clk, rst, R_lt_Y_inf,
    input [7:0] sw,
    output reg [2:0] mux_cw,
    output reg [6:0] UD_counter_cw,
    output reg [3:0] SRX_cw,
    output reg [1:0] SRY_cw,
    output reg [3:0] SRR_cw,
    output reg [1:0] done_err,
    output [3:0] cs
);
    wire error;
    wire R_lt_Y;
    wire [2:0] cnt_out;
    wire [3:0] divisor;
    assign {R_lt_Y, cnt_out, divisor} = sw;
    assign error = (divisor == 0) ? 1 : 0;
    
    //encode states
    parameter S0 = 4'd0,
              S1 = 4'd1,
              S2 = 4'd2,
              S3 = 4'd3,
              S4 = 4'd4,
              S5 = 4'd5,
              S6 = 4'd6,
              S7 = 4'd7;
    
    //Next and Current State
    reg [3:0] CS, NS;
    
    //Next-State Logic (combinational) based on the state transition diagram
    always @ (CS, go)
    begin
        case(CS)
            S0:     
                begin
                    NS <= (go) ? S1 : S0;
                    if (error)
                        NS <= S7;
                end                     
            S1:      NS <= S2;
            S2:      NS <= S3;
            S3:      NS <= (R_lt_Y_inf) ? S5 : S4;    
            S4:      NS <= (cnt_out == 0) ? S6 : S3;
            S5:      NS <= (cnt_out == 0) ? S6 : S3;
            S6:      NS <= S7;
            S7:      NS <= S7;
            default: NS <= S0;
         endcase
    end
    
    //State Register (sequential)
    always @ (posedge clk, posedge rst)
        if (rst)
            CS <= S0;
        else
            CS <= NS;
    
    //Output Logic (combinational) based on output table
    always @ (CS)
    begin
        case(CS)               
            S0:
                begin
                    // UD_D, UD_ld, UD_ud, UD_ce, UD_rst
                    UD_counter_cw <= 7'b000_0_0_0_0;
                    // {SRX_rst, SRX_sl, SRX_ld, SRX_rightIn}
                    SRX_cw <= 4'b0_0_0_0;
                    // {SRY_rst, SRY_ld}
                    SRY_cw <= 2'b0_0;
                    // {SRR_rst, SRR_sl, SRR_sr, SRR_ld}
                    SRR_cw <= 4'b0_0_0_0;
                    mux_cw <= 3'b1_0_0;
                    done_err <= 2'b0_0;
                end
            S1:
                begin
                    // {SRR_rst, SRR_sl, SRR_sr, SRR_ld}
                    SRR_cw <= 4'b1_0_0_0;
                    // {SRX_rst, SRX_sl, SRX_ld, SRX_rightIn}
                    SRX_cw <= 4'b0_0_1_0;
                    // {SRY_rst, SRY_ld}
                    SRY_cw <= 2'b0_1;
                    
                     // UD_D, UD_ld, UD_ud, UD_ce, UD_rst
                    UD_counter_cw <= 7'b100_1_0_1_1;
                    
                    mux_cw <= 3'b1_0_0;
                    done_err <= 2'b0_0; 
                end         
            S2:
                begin
                    // UD_D, UD_ld, UD_ud, UD_ce, UD_rst
                    UD_counter_cw <= 7'b000_0_0_0_1;
                    
                    // {SRY_rst, SRY_ld}
                    SRY_cw <= 2'b0_0;
                    // {SRR_rst, SRR_sl, SRR_sr, SRR_ld}
                    SRR_cw <= 4'b0_1_0_0;
                    // {SRX_rst, SRX_sl, SRX_ld, SRX_rightIn}
                    SRX_cw <= 4'b0_1_0_0;
                    
                    mux_cw <= 3'b1_0_0;
                    done_err <= 2'b0_0;
                end         
            S3:
                begin
                    // {SRR_rst, SRR_sl, SRR_sr, SRR_ld}
                    if (!R_lt_Y_inf)
                         SRR_cw <= 4'b0_0_0_1;
                    else
                        SRR_cw <= 4'b0_0_0_0;
                    // {SRX_rst, SRX_sl, SRX_ld, SRX_rightIn}
                    SRX_cw <= 4'b0_0_0_0;
                    // UD_D, UD_ld, UD_ud, UD_ce, UD_rst
                    UD_counter_cw <= 7'b000_0_0_1_1;
                    
                    mux_cw <= 3'b1_0_0;
                    done_err <= 2'b0_0;
                                                
                end         
            S4:
                begin
                    // {SRR_rst, SRR_sl, SRR_sr, SRR_ld}
                    SRR_cw <= 4'b0_1_0_0;
                    // {SRX_rst, SRX_sl, SRX_ld, SRX_rightIn}
                    SRX_cw <= 4'b0_1_0_1;
                    // UD_D, UD_ld, UD_ud, UD_ce, UD_rst
                    UD_counter_cw <= 7'b000_0_0_0_1;
                    
                    mux_cw <= 3'b1_0_0;
                    done_err <= 2'b0_0;            
                end         
            S5:
                begin
                    // {SRR_rst, SRR_sl, SRR_sr, SRR_ld}
                    SRR_cw <= 4'b0_1_0_0;
                    // {SRX_rst, SRX_sl, SRX_ld, SRX_rightIn}
                    SRX_cw <= 4'b0_1_0_0;
                    // UD_D, UD_ld, UD_ud, UD_ce, UD_rst
                    UD_counter_cw <= 7'b000_0_0_0_1;
                    
                    mux_cw <= 3'b1_0_0;
                    done_err <= 2'b0_0;
                end         
            S6:
                begin
                    // {SRR_rst, SRR_sl, SRR_sr, SRR_ld}
                    SRR_cw <= 4'b0_0_1_0;
                    // {SRX_rst, SRX_sl, SRX_ld, SRX_rightIn}
                    SRX_cw <= 4'b0_0_0_0;
                    
                    
                    mux_cw <= 3'b1_0_0;
                    done_err <= 2'b0_0;
                end         
            S7:
                begin
                    if (error)
                        begin
                            // {SRR_rst, SRR_sl, SRR_sr, SRR_ld}
                            SRR_cw <= 4'b0_0_0_0;
                            // {SRX_rst, SRX_sl, SRX_ld, SRX_rightIn}
                            SRX_cw <= 4'b0_0_0_0;

                            mux_cw <= 3'b1_0_0;
                            done_err <= 2'b01;
                        end
                    else
                        begin
                            // {SRR_rst, SRR_sl, SRR_sr, SRR_ld}
                            SRR_cw <= 4'b0_0_0_0;
                            // {SRX_rst, SRX_sl, SRX_ld, SRX_rightIn}
                            SRX_cw <= 4'b0_0_0_0;

                            mux_cw <= 3'b1_1_1;
                            done_err <= 2'b10;
                        end
                end         
        endcase
    
    end
    
    assign cs = CS;
    
              
    
    
    
endmodule

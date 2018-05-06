`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2018 07:36:30 PM
// Design Name: 
// Module Name: Full_Calculator_DP
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


module Full_Calculator_CU(
    input Go, clk, rst,
    input [2:0] F,
    output done,
    
    input Done_Calc, Done_Div,
    output En_F, En_X, En_Y,
    output Go_Calc, Go_Div,
    output [1:0] Op_Calc,
    output Sel_H,
    output [1:0] Sel_L,
    output Calc_Mux_Sel, Mul_Mux_Sel,
    output En_Out_H, En_Out_L,
    output RST_OUT_H, RST_OUT_L
    );
    
    // Encode States
    parameter S0 = 4'd0,
              S1 = 4'd1,
              S2 = 4'd2,
              S3 = 4'd3,
              S4 = 4'd4,
              S4p = 4'd5,
              S5 = 4'd6,
              S6 = 4'd7,
              S7 = 4'd8,
              S8 = 4'd9,
              S9 = 4'd10;
              
    // Next and Current State
    reg [3:0] CS, NS;
    
    // Control Word
        // cw = {En_F, En_X, En_Y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
    reg [14:0] cw;

    reg Calc_Mux_Sel_internal, Mul_Mux_Sel_internal;
    
    // Next-State Logic (combinational) based on the state transition diagram
    always @ (CS, Go)
    begin
        case (CS)
            S0: NS <= (Go) ? S1 : S0;
            S1: NS <= S2;
            S2:
                begin
                if (F[2])
                    begin
                        Calc_Mux_Sel_internal <= 1'b1;
                        Mul_Mux_Sel_internal <= 1'b1;   
                    end
                else
                    begin
                        Calc_Mux_Sel_internal <= 1'b0;
                        Mul_Mux_Sel_internal <= 1'b0;
                    end
                
                if (F[2] && F[0])
                    NS <= S0;
                else
                    begin
                        if (F[1])
                            begin
                                if (F[0])
                                    NS <= S5;
                                else
                                    NS <= S4;
                            end
                        else
                            NS <= S3;
                    end
                end
            S3: NS <= S6;
            S4: NS <= S4p;
            S5: NS <= S7;
            S6: NS <= (Done_Calc) ? S9 : S6;
            S7: NS <= (Done_Div) ? S9 : S7;
            S8: NS <= S9;
            S9: NS <= S0;
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
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____0________0_______00________0_____00_______0_________0________1__________1________0;
                
                    end
               S1:
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__1_____1_____1_____0________0_______00________0_____00_______0_________0________0__________0________0;
                    
                    end
               S2:
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____0________0_______00________0_____00_______0_________0________0__________0________0;
                    end
               S3:
                    begin
                    if (F[0])
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____1________0_______11________0_____00_______0_________0________0___________0________0;
                    end
                    else
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____1________0_______10________0_____00_______0_________0________0___________0________0;                    
                    end                         
                    end
               S4:
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____0________0_______00________0_____00_______0_________0________0___________0________0;                    
                    end
               S4p:
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____0________0_______00________0_____00_______0_________0________0___________0________0;                    
                    end
               S5:
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____0________1_______00________0_____00_______0_________0________0___________0________0;                    
                    end
               S6:
                    begin
                    if (Done_Calc)
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____0________0_______00________0_____10_______1_________1________0__________0_________0;                    
                    end
                    else
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____0________0_______00________0_____00_______0_________0________0__________0_________0;                    
                    end                    
                    end
               S7:
                    begin
                     if (Done_Div)
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____0________0_______00________0_____00_______1_________1________0__________0_________0;                    
                    end
                    else
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____0________0_______00________0_____00_______0_________0________0__________0_________0;                    
                    end                                       
                    end
               S8:
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____0________0_______00________1_____01_______1_________1________0__________0_________0;                    
                    end
               S9:
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____0________0_______00________0_____00_______0_________0_______0___________0_________1;                    
                    end
            endcase
        end
        
        assign {En_F, En_X, En_Y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done} = cw;
        assign Calc_Mux_Sel = Calc_Mux_Sel_internal;
        assign Mul_Mux_Sel = Mul_Mux_Sel_internal;
                

                

endmodule

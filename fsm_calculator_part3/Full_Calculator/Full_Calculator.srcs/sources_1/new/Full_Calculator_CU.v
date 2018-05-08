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
    output RST_OUT_H, RST_OUT_L,
    output [3:0] cs,
    output Module_Reset
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
              S6p = 4'd8,
              S7 = 4'd9,
              S7p = 4'd10,
              S8 = 4'd11,
              S9 = 4'd12,
              S10 = 4'd13;
              
    // Next and Current State
    reg [3:0] CS, NS;
    
    // Control Word
        // cw = {En_F, En_X, En_Y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
    reg [14:0] cw;

    reg Calc_Mux_Sel_internal, Mul_Mux_Sel_internal;
    reg Sel_H_internal;
    reg [1:0] Sel_L_internal;
    reg [1:0] Calc_Op_internal;
    wire dummy1;
    wire [1:0] dummy2, dummy3;
    reg Module_Reset_Internal;
    
    reg calc;
    
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
                
                if (F[2] && F[1] && F[0])
                    begin
                    NS <= S0;
                    end
                else
                    begin
                        if (F[1])
                            begin
                                if (F[0])
                                    begin
                                        NS <= S5; //Div
                                        Sel_L_internal <= 2'b00;
                                        Sel_H_internal <= 1'b0;
                                    end
                                else
                                    begin
                                        NS <= S4; //Mult
                                        Sel_L_internal <= 2'b01;
                                        Sel_H_internal <= 1'b1;
                                    end
                            end
                        else
                            begin //Calc
                            if (F[0])
                                Calc_Op_internal <= 2'b01;
                            else
                                Calc_Op_internal <= 2'b00;
                            NS <= S3;
                            Sel_L_internal <= 2'b10;
                            Sel_H_internal <= 1'b0;
                            end
                    end
                end
            S3: NS <= S6;
            S4: NS <= S4p;
            S4p: NS <= S8; 
            S5: NS <= S7;
            S6: NS <= (Done_Calc) ? S9 : S6p;
            S6p: NS <= (Done_Calc) ? S9 : S6;
            S7: NS <= (Done_Div) ? S9 : S7p;
            S7p: NS <= (Done_Div) ? S9 : S7;
            S8: NS <= S9;
            S9: NS <= S10;
            S10: NS <= S0;
            
            default: NS <= S0;
        endcase
    end
    
    //State Register (sequential)
    always @ (posedge clk, posedge rst)
        
        if (rst)
            begin
            CS = S0;
           // Module_Reset_Internal = 1'b1;
            end
//        else if ((CS == S6) && (Done_Calc))
//            begin
//            //CS = S9;
//            cw = 15'b__0_____0_____0_____0________0_______00________0_____10_______1_________1________0__________0_________0;
//            calc = 1'b1;
//            CS = S9;
//            end
        else
            CS = NS;
            
     //Output Logic (combinational) based on output table
       always @ (CS)
       begin
           case(CS)               
               S0:
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__1_____0_____0_____0________0_______00________0_____00_______0_________0________1__________1________0;
                    calc <= 1'b0;
                    Module_Reset_Internal <= 1'b1; 
                    end
               S1:
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__1_____1_____1_____0________0_______00________0_____00_______0_________0________0__________0________0;
                    Module_Reset_Internal <= 1'b1; 
                    
                    end
               S2:
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__1_____0_____0_____0________0_______00________0_____00_______0_________0________0__________0________0;
                    Module_Reset_Internal <= 1'b0; 
                    end
               S3:
                    begin
                    if (F[0])
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____1________0_______01________0_____00_______0_________0________0___________0________0;
                    end
                    else
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____1________0_______00________0_____00_______0_________0________0___________0________0;                    
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
                    if (NS == S9)
                    begin
                        if (F[0])
                        begin
                            // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                            cw <= 15'b__0_____0_____0_____0________0_______01________0_____10_______0_________0________0__________0_________0;
                        end
                        else
                        begin
                            // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                            cw <= 15'b__0_____0_____0_____0________0_______00________0_____10_______0_________0________0__________0_________0;
                        end                    
                    end
                    else
                    begin
                        if (F[0])
                        begin
                            // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                            cw <= 15'b__0_____0_____0_____0________0_______01________0_____10_______0_________0________0__________0_________0;                    
                        end
                        else
                        begin
                            // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                            cw <= 15'b__0_____0_____0_____0________0_______00________0_____10_______0_________0________0__________0_________0;
                        end
                    end                    
                    end
               S6p: begin
                    if (NS == S9)
                       begin
                           if (F[0])
                           begin
                               // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                               cw <= 15'b__0_____0_____0_____0________0_______01________0_____10_______0_________0________0__________0_________0;
                           end
                           else
                           begin
                               // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                               cw <= 15'b__0_____0_____0_____0________0_______00________0_____10_______0_________0________0__________0_________0;
                           end                    
                       end
                       else
                       begin
                           if (F[0])
                           begin
                               // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                               cw <= 15'b__0_____0_____0_____0________0_______01________0_____10_______0_________0________0__________0_________0;                    
                           end
                           else
                           begin
                               // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                               cw <= 15'b__0_____0_____0_____0________0_______00________0_____10_______0_________0________0__________0_________0;
                           end
                       end                    
                       end
               S7:
                    begin
                     if (Done_Div)
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____0________0_______00________0_____00_______0_________0________0__________0_________0;                    
                    end
                    else
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____0________0_______00________0_____00_______0_________0________0__________0_________0;                    
                    end                                       
                    end
                S7p:
                   begin
                    if (Done_Div)
                   begin
                   // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                   cw <= 15'b__0_____0_____0_____0________0_______00________0_____00_______0_________0________0__________0_________0;                    
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
                    cw <= 15'b__0_____0_____0_____0________0_______00________1_____01_______0_________0________0__________0_________0;                    
                    end
               S9:
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____0________0_______00________0_____00_______1_________1_______0___________0_________0;                    
                    end
              S10:
                    begin
                    // cw <= {En_F, En_X, En_y, Go_Calc, Go_Div, Op_Calc, Sel_H, Sel_L, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done}
                    cw <= 15'b__0_____0_____0_____0________0_______00________0_____00_______1_________1_______0___________0_________1;
                    Module_Reset_Internal <= 1'b1;                    
                    end
            endcase
        end
        
        assign {En_F, En_X, En_Y, Go_Calc, Go_Div, dummy3, dummy1, dummy2, En_Out_H, En_Out_L, RST_OUT_H, RST_OUT_L, done} = cw;
        assign Calc_Mux_Sel = Calc_Mux_Sel_internal;
        assign Mul_Mux_Sel = Mul_Mux_Sel_internal;
        assign Sel_H = Sel_H_internal;
        assign Sel_L = Sel_L_internal;
        assign Op_Calc = Calc_Op_internal;
        assign Module_Reset = Module_Reset_Internal;
        assign cs = CS;
                

                

endmodule

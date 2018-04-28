`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2018 02:20:15 PM
// Design Name: 
// Module Name: DP_tb
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


module DP_tb;

// Input Reg's
reg [3:0] dividend_tb, divisor_tb;
// Output Reg's
wire [3:0] quotient_tb, remainder_tb;
wire [7:0] sw_tb;

// Control Signals
reg clk_tb, rst_tb;
reg [2:0] mux_cw_tb;
reg [6:0] UD_counter_cw_tb;
reg [3:0] SRX_cw_tb;
reg [1:0] SRY_cw_tb;
reg [3:0] SRR_cw_tb;

integer i = 0;
integer j = 0;
integer inferred_quotient =  0;
integer inferred_remainder = 0;


// Initialize DUT
DP DUT (
    .dividend(dividend_tb), .divisor(divisor_tb),
    .clk(clk_tb), .rst(rst_tb),
    .mux_cw(mux_cw_tb),
    .UD_counter_cw(UD_counter_cw_tb),
    .SRX_cw(SRX_cw_tb), .SRY_cw(SRY_cw_tb), .SRR_cw(SRR_cw_tb),
    .sw(sw_tb),
    .quotient(quotient_tb), .remainder(remainder_tb)
);

task tick;
    //input clk_tb;
    begin
        clk_tb <= 1;
        #5;
        clk_tb <= 0;
        #5;
    end
endtask

task automatic step_1;
    begin
       /*Step 1: Load Initial Values into Registers
        R[4:0] <- 0
        X[3:0] <- dividend
        Y[3:0] <- divisor
       */
        // {RIN_mux_sel, R_mux_sel, Q_mux_sel}
        mux_cw_tb = 3'b1_0_0;
        // {SRR_rst, SRR_sl, SRR_sr, SRR_ld}
        SRR_cw_tb = 4'b1_0_0_0;        
        // {SRX_rst, SRX_sl, SRX_ld, SRX_rightIn}
        SRX_cw_tb = 4'b0_0_1_0;
        // {SRY_rst, SRY_ld}
        SRY_cw_tb = 2'b0_1;
        tick;
        //disable ld for all 3 SR's
        SRR_cw_tb = 4'b0_0_0_0;
        SRX_cw_tb = 4'b0_0_0_0;
        SRY_cw_tb = 2'b0_0;
        tick;
    
    end
endtask

task automatic step_2;
    begin
        /* Step 2: Serial Shift the Concatenated {remainder, dividend} 1 bit to the Left
        R[4:0] <- {R[3:0], X[3]},  X[3:0] <- {X[2:0], 0}
        */
        SRR_cw_tb = 4'b0_1_0_0;
        SRX_cw_tb = 4'b0_1_0_0;
        tick;
        SRR_cw_tb = 4'b0_0_0_0;
        SRX_cw_tb = 4'b0_0_0_0;
        tick;
    end
endtask

task automatic step_3;
    begin
        /* //Step 3: loop -  repeat 4 times  
    for (i  = 3; i >= 0; i = i -  1)          
        begin
            if (R[3:0] < Y[3:0])
                begin
                    R[4:0] ? {R[3:0], X[3]},  X[3:0] ? {X[2:0], 0}; 
                end
            else
                begin
                    R[3:0] ? R[3:0] - Y[3:0];  
                    R[4:0] ? {R[3:0], X[3]},  X[3:0] ? {X[2:0], 1};       
                end
         end
    */
        for (i = 3; i >= 0; i = i - 1)
            begin
            $display("Loop iteration #%0d at %0dns",i, $time);
                if (sw_tb[6]) // R_lt_Y signal true
                    begin
                        $display("Hit R < Y at Loop iteration #%0d at %0dns",i, $time);
                        // {SRR_rst, SRR_sl, SRR_sr, SRR_ld}
                        // {SRX_rst, SRX_sl, SRX_ld, SRX_rightIn}
                        SRR_cw_tb = 4'b0_1_0_0;
                        SRX_cw_tb = 4'b0_1_0_0;
                        tick;
                        SRR_cw_tb = 4'b0_0_0_0;
                        SRX_cw_tb = 4'b0_0_0_0;
                        tick;
                    end
                else
                    begin
                        $display("Hit R >= Y at Loop iteration #%0d at %0dns",i, $time);
                        // {SRR_rst, SRR_sl, SRR_sr, SRR_ld}
                        // {SRX_rst, SRX_sl, SRX_ld, SRX_rightIn}
                        SRR_cw_tb = 4'b0_0_0_1;
                        tick;
                        SRR_cw_tb = 4'b0_1_0_0;
                        tick;
                        SRR_cw_tb = 4'b0_0_0_0;
                        SRX_cw_tb = 4'b0_1_0_1;
                        tick;
                        SRR_cw_tb = 4'b0_0_0_0;
                        SRX_cw_tb = 4'b0_0_0_0;
                        tick;
                    end
            end
    
    end
endtask

task automatic step_3_ud;
    begin
        // Initialize UD Counter
            // UD_D, UD_ld, UD_ud, UD_ce, UD_rst
            UD_counter_cw_tb = 7'b100_1_0_1_1;
            tick;
            UD_counter_cw_tb = 7'b000_0_0_0_1;
            while (sw_tb[6:4] != 0)
                begin
                $display("Counter = %0d",sw_tb[6:4]);
                    if (sw_tb[7]) // R_lt_Y signal true
                        begin
                            $display("Hit R < Y at Loop iteration #%0d at %0dns",i, $time);
                            i = i + 1;
                            // {SRR_rst, SRR_sl, SRR_sr, SRR_ld}
                            // {SRX_rst, SRX_sl, SRX_ld, SRX_rightIn}
                            SRR_cw_tb = 4'b0_1_0_0;
                            SRX_cw_tb = 4'b0_1_0_0;
                            tick;
                            SRR_cw_tb = 4'b0_0_0_0;
                            SRX_cw_tb = 4'b0_0_0_0;
                            tick;
                        end
                    else
                        begin
                            $display("Hit R >= Y at Loop iteration #%0d at %0dns",i, $time);
                            i = i + 1;
                            // {SRR_rst, SRR_sl, SRR_sr, SRR_ld}
                            // {SRX_rst, SRX_sl, SRX_ld, SRX_rightIn}
                            SRR_cw_tb = 4'b0_0_0_1;
                            tick;
                            SRR_cw_tb = 4'b0_1_0_0;
                            tick;
                            SRR_cw_tb = 4'b0_0_0_0;
                            SRX_cw_tb = 4'b0_1_0_1;
                            tick;
                            SRR_cw_tb = 4'b0_0_0_0;
                            SRX_cw_tb = 4'b0_0_0_0;
                            tick;
                        end

                // UD_D, UD_ld, UD_ud, UD_ce, UD_rst
                UD_counter_cw_tb = 7'b000_0_0_1_1;
                tick;
                UD_counter_cw_tb = 7'b000_0_0_0_1;
                end
               // UD_D, UD_ld, UD_ud, UD_ce, UD_rst
                UD_counter_cw_tb = 7'b000_0_0_0_0;
                tick;
                
    end
endtask

task automatic step_4;
    begin
        /* Step 4: Right Shift the Remainder by 1 bit
        R[4:0] ? {0, R[4:1]}
        */
     // {SRR_rst, SRR_sl, SRR_sr, SRR_ld}
        SRR_cw_tb = 4'b0_0_1_0;
        tick;
        SRR_cw_tb = 4'b0_0_0_0;

    end
endtask

task automatic show_results;
    begin
         mux_cw_tb = 3'b1_1_1;
         tick;
    end
endtask

task automatic check_results;
    begin
        inferred_quotient = dividend_tb / divisor_tb;
        inferred_remainder = dividend_tb % divisor_tb;
        if ((quotient_tb != inferred_quotient) || (remainder_tb != inferred_remainder))
        begin
            $display("Incorrect Result for %0d / %0d. Expected %0d remainder %0d, got %0d remainder %0d.", dividend_tb, divisor_tb, inferred_quotient, inferred_remainder, quotient_tb, remainder_tb);  
            $stop;
        end
    end
endtask


initial
begin
$display("DP Test Start");
//for (j = 0; j < 100; j = j + 1)
//begin
//initialize control signals
    clk_tb = 0;
    rst_tb = 0;
    //dividend_tb = {$random};
    //divisor_tb  = {$random};
    dividend_tb = 4'd10;
    divisor_tb  = 4'd3;
    mux_cw_tb = 0;
    UD_counter_cw_tb = 0;
    SRX_cw_tb = 0;
    SRY_cw_tb = 0;
    SRR_cw_tb = 0;
    #10;

/*Step 1: Load Initial Values into Registers
        R[4:0] ? 0
        X[3:0] ? dividend
        Y[3:0] ? divisor
 */
    step_1;
    
    
/* Step 2: Serial Shift the Concatenated {remainder, dividend} 1 bit to the Left
    R[4:0] ? {R[3:0], X[3]},  X[3:0] ? {X[2:0], 0}
*/
    step_2;
    
    
/* //Step 3: loop -  repeat 4 times  
for (i  = 3; i >= 0; i = i -  1)          
    begin
        if (R[3:0] < Y[3:0])
            begin
                R[4:0] ? {R[3:0], X[3]},  X[3:0] ? {X[2:0], 0}; 
            end
        else
            begin
                R[3:0] ? R[3:0] - Y[3:0];  
                R[4:0] ? {R[3:0], X[3]},  X[3:0] ? {X[2:0], 1};       
            end
     end
*/
    step_3_ud;
        
/* Step 4: Right Shift the Remainder by 1 bit
    R[4:0] ? {0, R[4:1]}
*/
    step_4;
    
// Select Quotient and Remainder with output muxes
    show_results;

// Check Result
    check_results;
    
 
$display("The Result of %0d / %0d is %0d Remainder %0d",dividend_tb,divisor_tb,quotient_tb, remainder_tb);
//end
$display("Test Successful. Time=%0dns", $time);
$finish;
end

endmodule

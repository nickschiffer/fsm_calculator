`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2018 05:10:49 PM
// Design Name: 
// Module Name: Integer_Divider_Top_tb
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


module Integer_Divider_Top_tb;
    reg go_tb, clk_tb, rst_tb;
    reg [3:0] divisor_tb, dividend_tb;
    wire [3:0] quotient_tb, remainder_tb;
    wire [3:0] cs_tb;
    wire [1:0] err_done_tb;
    reg [3:0] quotient_inferred_tb, remainder_inferred_tb;
    
    Integer_Divider_Top DUT (
        .go(go_tb),
        .clk(clk_tb),
        .rst(rst_tb),
        .dividend(dividend_tb),
        .divisor(divisor_tb),
        .cs(cs_tb),
        .quotient(quotient_tb),
        .remainder(remainder_tb),
        .err_done(err_done_tb)
    );
task automatic tick;
    begin
        clk_tb = 1'b0;
        #5;
        clk_tb = 1'b1;
        #5;
    end
endtask


initial
begin
go_tb = 0;
clk_tb = 0;
rst_tb = 0;
dividend_tb = 4'd10;
divisor_tb = 4'd3;
$display("Begin Integer_Divider_Top Test");
tick;
go_tb = 1;
tick;
$display("Error TB initial = %0d", err_done_tb);
while (err_done_tb == 2'b0)
begin
    tick;
    $display("Current State = %0d", cs_tb);
    $display("Quotient = %0d, Remainder = %0d", quotient_tb, remainder_tb);
    $display("Error/Done = %0d", err_done_tb);
    
end

quotient_inferred_tb = dividend_tb / divisor_tb;
remainder_inferred_tb = dividend_tb % divisor_tb;

if ((quotient_tb != quotient_inferred_tb) || (remainder_tb != remainder_inferred_tb))
begin
    $display("Error, %0d / %0d", dividend_tb, divisor_tb);
    $display("Expected: %0d remainder %0d, Actual: %0d remainder %0d",quotient_inferred_tb, remainder_inferred_tb, quotient_tb, remainder_tb);
    $stop;
end






$display("Test Successful");
$finish;
end    
endmodule

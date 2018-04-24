`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2018 07:03:34 PM
// Design Name: 
// Module Name: CU_tb
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


module CU_tb;

reg clk_tb, rst_tb, go_tb;
wire [2:0] mux_cw_tb;
wire [6:0] UD_counter_cw_tb;
wire [3:0] SRX_cw_tb;
wire [1:0] SRY_cw_tb;
wire [3:0] SRR_cw_tb;
wire [7:0] sw_tb;
wire [1:0] done_err_tb;
wire [3:0] cs_tb;

reg R_lt_Y_tb; 
reg [2:0] cnt_out_tb; 
reg [3:0] divisor_tb;

assign sw_tb = {R_lt_Y_tb, cnt_out_tb, divisor_tb};

CU DUT (
    .go(go_tb), .clk(clk_tb),
    .sw(sw_tb),
    .mux_cw(mux_cw_tb),
    .UD_counter_cw(UD_counter_cw_tb),
    .SRX_cw(SRX_cw_tb),
    .SRY_cw(SRY_cw_tb),
    .SRR_cw(SRR_cw_tb),
    .done_err(done_err_tb),
    .cs(cs_tb)
);

task automatic display;
    begin
        $display("\nMux CW = %b", mux_cw_tb);
        $display("UD Counter CW= %b",UD_counter_cw_tb);
        $display("Count out=%0d", cnt_out_tb);
        $display("SRX CW= %b",SRX_cw_tb);
        $display("SRY CW= %b",SRY_cw_tb);
        $display("SRR CW= %b",SRR_cw_tb);
        $display("Status W= %b",sw_tb);
        $display("Done/Error= %b",done_err_tb);
        $display("CS= %0d\n",cs_tb);
    end
endtask
task tick;
    begin
        clk_tb <= 1;
        #5;
        clk_tb <= 0;
        #5;
    end
endtask

initial
begin
$display("CU Test Start");
go_tb = 1'b1;
rst_tb = 1'b0;
cnt_out_tb = 4'd4;
R_lt_Y_tb = 1'b1;
divisor_tb = 4'd4;
tick;
display;

while (done_err_tb == 0)
    begin
        if (UD_counter_cw_tb[1] == 1)
            cnt_out_tb = cnt_out_tb - 1'b1;
        tick;
        display;
        case(cs_tb)
            0:
                begin
                    if((mux_cw_tb != 3'b1_0_0) || (done_err_tb != 2'b00))
                        begin
                        $display("Error State %0d",cs_tb);
                        $stop;
                        end
                end
            1:
                begin
                    begin
                        if((SRR_cw_tb != 4'b1_0_0_0) || (SRX_cw_tb != 4'b0_0_1_0) || (SRY_cw_tb != 2'b0_1) )
                            begin
                            $display("Error State %0d",cs_tb);
                            $stop;
                            end
                    end
                end
            2:
                begin
                    if((UD_counter_cw_tb != 7'b000_0_0_0_1) || (SRY_cw_tb != 2'b0_0) || (SRR_cw_tb != 4'b0_1_0_0) || (SRX_cw_tb != 4'b0_1_0_0))
                    begin
                        $display("Error State %0d",cs_tb);
                        $stop;
                    end
                end
            3:
                begin
                    if((SRR_cw_tb != 4'b0_0_0_0) || (SRX_cw_tb != 4'b0_0_0_0) || (UD_counter_cw_tb != 7'b000_0_0_1_1))
                    begin
                        $display("Error State %0d",cs_tb);
                        $stop;
                    end
                end
            4:
                begin
                    if((SRR_cw_tb != 4'b0_1_0_0) || (SRX_cw_tb != 4'b0_1_0_1) || (UD_counter_cw_tb != 7'b000_0_0_0_1))
                    begin
                        $display("Error State %0d",cs_tb);
                        $stop;
                    end
                end
            5:
                begin
                    if((SRR_cw_tb != 4'b0_1_0_0) || (SRX_cw_tb != 4'b0_1_0_1) || (UD_counter_cw_tb != 7'b000_0_0_0_1))
                    begin
                        $display("Error State %0d",cs_tb);
                        $stop;
                    end
                end
            6:
                begin
                    if((SRR_cw_tb != 4'b0_0_1_0) || (SRX_cw_tb != 4'b0_0_0_0))
                    begin
                        $display("Error State %0d",cs_tb);
                        $stop;
                    end
                end
            7:
                begin
                    if(((mux_cw_tb != 3'b1_0_0) && (done_err_tb == 2'b01)) || ((mux_cw_tb != 3'b1_1_1) && (done_err_tb == 2'b10)))
                    begin
                        $display("Error State %0d",cs_tb);
                        $stop;
                    end
                end
       endcase
    end


$display("Test Complete");
$finish;
end
endmodule

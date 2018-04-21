`timescale 1ns / 1ps
module Calculator_Top_tb;

    reg go_tb, clk_tb;
    reg [1:0] op_tb;
    reg [2:0] In1_tb, In2_tb;
    
    wire [3:0] cs_tb_1, cs_tb_2;
    wire [2:0] out_tb_1, out_tb_2;
    wire done_tb_1, done_tb_2;
    
    wire [14:0] cw;
    wire [1:0] s1, wa, raa, rab, c;
    wire we, rea, reb, s2;
    //s1[14:13], wa[12:11], we[10], raa[9:8], rea[7], rab[6:5], reb[4], c[3:2], s2[1], done[0]
    assign {s1, wa, we, raa, rea, rab, reb, c, s2, done_tb_2} = cw;
    
    Calculator_Top DUT (
        .go(go_tb),
        .op(op_tb),
        .clk(clk_tb),
        .in1(In1_tb),
        .in2(In2_tb),
        .cs(cs_tb_1),
        .out(out_tb_1),
        .done(done_tb_1)
        );
    FSM_CU CU(
            .go(go_tb),
            .clk(clk_tb),
            .op(op_tb),
            .cs(cs_tb_2),
            .cw(cw)
            );
                                
    DP DP(
            .in1(In1_tb),
            .in2(In2_tb),
            .s1(s1),
            .wa(wa),
            .raa(raa),
            .rab(rab),
            .c(c),
            .we(we),
            .rea(rea),
            .reb(reb),
            .s2(s2),
            .clk(clk_tb),
            .out(out_tb_2)
            );
    always
    begin
        #1 clk_tb = ~clk_tb;
    end
    
    integer i = 0;
    integer j = 0;
    integer k = 0;
    integer l = 0;
    
    initial
    begin
        $display("Begin Test.\n");
        clk_tb=1'b0;
        #10 go_tb=0;
        for (i=0; i<8; i=i+1)
        begin
            In1_tb = i;
            for (j = 0; j<8; j=j+1)
            begin
                In2_tb = j;
                for (k=0; k<4; k=k+1)
                begin
                    op_tb = {k};
                    go_tb = 1;
                    
                    for (l=0; l<6; l=l+1)
                    begin
                        #5 if(cs_tb_1 !== cs_tb_2)
                        begin
                            $display("ERROR at time %d: Expected cs_tb_1 = %d, found %d instead.\n", $time, cs_tb_1, cs_tb_2);
                            $stop;
                        end
                        else if (out_tb_1 !== out_tb_2)
                        begin
                            $display("ERROR at time %d: Expected out_tb_1 = %d, found %d instead.\n", $time, out_tb_1, out_tb_2);
                            $stop;
                        end
                        else if (done_tb_1 !== done_tb_2)
                        begin
                            $display("ERROR at time %d: Expected done_tb_1 = %d, found %d instead.\n", $time, done_tb_1, done_tb_2);
                            $stop;
                        end
                    end
                end
            end
        end
    $display("Test Sucessfull.\n");
    $finish;
    end    
endmodule

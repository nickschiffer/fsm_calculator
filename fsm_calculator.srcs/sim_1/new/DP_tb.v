`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2018 04:15:24 PM
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

//TB reg's
reg [2:0] in1_tb, in2_tb;
wire [2:0] out_tb;
reg [1:0] s1_tb, wa_tb, raa_tb, rab_tb, c_tb;
reg we_tb, rea_tb, reb_tb, s2_tb, clk_tb;

//DUT
DP DUT(
.in1(in1_tb),
.in2(in2_tb),
.s1(s1_tb),
.wa(wa_tb),
.raa(raa_tb),
.rab(rab_tb),
.c(c_tb),
.we(we_tb),
.rea(rea_tb),
.reb(reb_tb),
.s2(s2_tb),
.clk(clk_tb),
.out(out_tb));

//task tick;
//    input clk_tb;
//    begin
//        clk_tb <= 1;
//        #1;
//        clk_tb <= 0;
//    end
//endtask

always 
begin
        #1 clk_tb = ~clk_tb;
end

task automatic store_value_into_register;
    input reg [2:0] register;
    input reg [2:0] in;
    
    begin
    
        case(in)
            1: begin
                    s1_tb  = 2'b11;
                    wa_tb  = register;
                    we_tb  = 1'b1; #10;
                    we_tb  = 1'b0;
                end
            2: begin
                    s1_tb  = 2'b10;
                    wa_tb  = register;
                    we_tb  = 1'b1; #10;
                    we_tb  = 1'b0;
                end
            3: begin
                    s1_tb  = 2'b01;
                    wa_tb  = register;
                    we_tb  = 1'b1; #10;
                    we_tb  = 1'b0;
                end
            4: begin
                    s1_tb  = 2'b00;
                    wa_tb  = register;
                    we_tb  = 1'b1; #10;
                    we_tb  = 1'b0;
                end
        endcase
    end
endtask

task automatic set_RF_outputs;
    input reg [3:0]  outa, outb;
    begin
    raa_tb = outa;
    rab_tb = outb;
    end
endtask

task automatic mux2_select;
    input reg in;
    begin
    s2_tb = in;#10;
    end
endtask

task automatic set_operator;
    input reg [1:0] op;
    begin
    c_tb = op;#10;
    end
endtask
    

integer result = 0;
integer i = 0;

initial
begin
$display("DP Test Start");
    //Start clk
    clk_tb = 1'b0;
    //set mux1 out to 0
    s1_tb  = 2'b01;
    //set mux2 out to 0
    s2_tb  = 1'b0;
    //deactivate ALU
    c_tb   = 1'b0;
    //Register File
    we_tb  = 1'b0;
    wa_tb  = 2'b0;
    rea_tb = 1'b0;
    reb_tb = 1'b0;
    raa_tb = 2'b0;
    rab_tb = 2'b0;
    //Two random operands
for (i = 0; i < 100; i = i + 1)
begin
    in1_tb = $random;
    in2_tb = $random;
    #10;
    
    //Read in1 into RF
        //Select in1 with mux1
        store_value_into_register(.register(2'b00), .in(1));
//        s1_tb = 2'b11;
           
//        //Read into address 0
//        wa_tb = 2'b00;
//        we_tb = 1'b1; #10;
//        we_tb = 1'b0;
        
    //Read in2 into RF
       store_value_into_register(.register(2'b01), .in(2));
        //Select in2 with mux1
//        s1_tb = 2'b10;
                   
        //Read into address 1
//        wa_tb = 2'b01;
//        we_tb = 1'b1; #10;
//        we_tb = 1'b0; #10;
        
    //Set RF to output the two numbers
        set_RF_outputs(.outa(2'b00), .outb(2'b01));
//        raa_tb = 2'b00;
//        rab_tb = 2'b01;
        rea_tb = 1'b1;
        reb_tb = 1'b1; #10;
        
    //Select result with MUX2
        mux2_select(1'b1);
//        s2_tb = 1'b1; #10;
        
    //Perform Calculation with ALU (ADD)
        set_operator(2'b00);
//        c_tb = 2'b00;
        if (out_tb != (in1_tb + in2_tb)%8)
        begin
            $display("Error: ADD at time %dns\nExpected: %d, Actual: %d, in1 = %d, in2 = %d", $time,(in1_tb + in2_tb), out_tb, in1_tb, in2_tb);
            $stop;
        end
    //Perform Calculation with ALU (Subtract)
        set_operator(2'b01);
//        c_tb = 2'b01; #10;
        if (out_tb != (in1_tb - in2_tb))
        begin
            $display("Error: Subtract at time %dns\nExpected: %d, Actual: %d, in1 = %d, in2 = %d", $time,(in1_tb - in2_tb),out_tb, in1_tb, in2_tb);
            $stop;
        end
    //Perform Calculation with ALU (&)
        set_operator(2'b10);
//        c_tb = 2'b10; #10;
         if (out_tb != (in1_tb & in2_tb))
         begin
             $display("Error: AND at time %dns\nExpected: %d, Actual: %d, in1 = %d, in2 = %d", $time,(in1_tb & in2_tb), out_tb, in1_tb, in2_tb);
             $stop;
         end
         
    //Perform Calculation with ALU (^)
        set_operator(2'b11);
//         c_tb = 2'b11; #10;
          if (out_tb != (in1_tb ^ in2_tb))
          begin
              $display("Error: XOR at time %dns\nExpected: %d, Actual: %d, in1 = %d, in2 = %d", $time,(in1_tb ^ in2_tb), out_tb, in1_tb, in2_tb);
              $stop;
          end
          
    //Add a number to the result
        //Store Result in RF address 2
        result = out_tb;
        store_value_into_register(.register(2'b10), .in(4));
//        s1_tb  = 2'b00;
//        wa_tb  = 2'b10;
//        we_tb  = 1'b1; #10;
//        we_tb  = 1'b0;
        
        //Store another number in RF address 3
        in1_tb = $random;
        store_value_into_register(.register(2'b11), .in(1));
//        s1_tb  = 2'b11;
//        wa_tb  = 2'b11;
//        we_tb  = 1'b1; #10;
//        we_tb  = 1'b0;
        
        // Select those two values to be read
        set_RF_outputs(.outa(2'b10), .outb(2'b11));
//        raa_tb = 2'b10;
//        rab_tb = 2'b11; #10;
        
        //Add with ALU
        set_operator(2'b00);
//        c_tb = 2'b00;#10;
         if (out_tb != (in1_tb + result)%8)
               begin
                   $display("Error: ADD at time %dns\nExpected: %d, Actual: %d, in1 = %d, previous result = %d", $time,(in1_tb + result), out_tb, in1_tb, result);
                   $stop;
               end
          
        
        
        #20;
end
        
    
    



$display("Test Successful. Time=%dns", $time);
$finish;
end
endmodule

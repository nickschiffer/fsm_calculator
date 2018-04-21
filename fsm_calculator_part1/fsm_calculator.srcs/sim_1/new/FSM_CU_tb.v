`timescale 1ns / 1ps

module FSM_CU_tb;

	parameter op_width = 2;
	parameter state_width = 4;
	parameter com_width = 15;
	
	//State Parameters
	parameter Idle                  = 4'd0,
              In1_into_R1           = 4'd1,
              In2_into_R2           = 4'd2,
              Wait                  = 4'd3,
              R1_plus_R2_into_R3    = 4'd4,
              R1_minus_R2_into_R3   = 4'd5,
              R1_and_R2_into_R3     = 4'd6,
              R1_xor_R2_into_R3     = 4'd7,
              out_done              = 4'd8;
              defparam DUT.Idle                    = Idle;
	          defparam DUT.In1_into_R1             = In1_into_R1;
	          defparam DUT.In2_into_R2             = In2_into_R2;
	          defparam DUT.Wait                    = Wait;
	          defparam DUT.R1_plus_R2_into_R3      = R1_plus_R2_into_R3;
	          defparam DUT.R1_minus_R2_into_R3     = R1_minus_R2_into_R3;
	          defparam DUT.R1_and_R2_into_R3       = R1_and_R2_into_R3;
	          defparam DUT.R1_xor_R2_into_R3       = R1_xor_R2_into_R3;
	          defparam DUT.out_done                = out_done;
	      //cw parameters:  15'b s1_wa_we_raa_rea_rab_reb_c_s2_done
    parameter Idle_cw               = 15'b01_00_0_00_0_00_0_00_0_0,
              I1_i_R1_cw            = 15'b11_01_1_00_0_00_0_00_0_0,
              I2_i_R2_cw            = 15'b10_10_1_00_0_00_0_00_0_0,
              Wait_cw               = 15'b01_00_0_00_0_00_0_00_0_0,
              R1_p_R2_cw            = 15'b00_11_1_01_1_10_1_00_0_0,
              R1_m_R2_cw            = 15'b00_11_1_01_1_10_1_01_0_0,
              R1_a_R2_cw            = 15'b00_11_1_01_1_10_1_10_0_0,
              R1_x_R2_cw            = 15'b00_11_1_01_1_10_1_11_0_0,
              done_cw               = 15'b01_00_0_11_1_11_1_10_1_1;

	//Inputs
	reg go_tb;
	reg clk_tb;
	reg [op_width - 1:0] op_tb;

	//outputs
	wire [state_width - 1:0] cs_tb;
	wire [com_width - 1:0] cw_tb;

	//instantiate DUT
	FSM_CU DUT (
                .go(go_tb),
                .clk(clk_tb),
                .op(op_tb),
                .cs(cs_tb),
                .cw(cw_tb));
	
	//initialize clock
	always
	begin
		#5 clk_tb = ~clk_tb;
	end

	//create test variables
	integer i = 0;
	integer j = 0;

	//Begin testbench
	initial
	begin
		$display("Begin Test.\n");
		clk_tb = 1'b0;
		#10 go_tb = 0;
		for(i=0; i<state_width; i=i+1)
		begin
		    op_tb = {i};
	    	go_tb = 1;
	    	for(j=0; j<6; j=j+1)
	    	begin
	    	    #10
			    case (cs_tb)
				    Idle:                   if(cw_tb !== Idle_cw)
                                            begin
                                                $display("ERROR at time %d: expected cw_tb = %b, found %b instead.\n", $time, Idle_cw, cw_tb);
                                                $stop;
                                            end
				    In1_into_R1:            if(cw_tb !== I1_i_R1_cw)
				                            begin
                                                $display("ERROR at time %d: expected cw_tb = %b, found %b instead.\n", $time, I1_i_R1_cw, cw_tb);
                                                $stop;
                                            end
				    In2_into_R2:            if(cw_tb !== I2_i_R2_cw)
                                            begin
                                                $display("ERROR at time %d: expected cw_tb = %b, found %b instead.\n", $time, I2_i_R2_cw, cw_tb);
                                                $stop;
                                            end
				    Wait:                   if(cw_tb !== Wait_cw)
                                            begin
                                                $display("ERROR at time %d: expected cw_tb = %b, found %b instead.\n", $time, Wait_cw, cw_tb);
                                                $stop;
                                            end
			     	R1_plus_R2_into_R3:     if(op_tb !== 2'b11)
                                            begin
                                                $display("ERROR at time %d: expected op = 11, found $b instead.\n", $time, op_tb);
                                                $stop;
                                            end
                                            else if(cw_tb !== R1_p_R2_cw)
                                            begin
                                                $display("ERROR at time $d: expected cw_tb = %b, found %b instead.\n", $time,  R1_p_R2_cw, cw_tb);
                                                $stop;
                                            end
    				R1_minus_R2_into_R3:	if(op_tb !== 2'b10)
                                            begin
                                                $display("ERROR at time %d: expected op = 10, found %b instead.\n", $time, op_tb);
                                                $stop;
                                            end
                                            else if(cw_tb !== R1_m_R2_cw)
                                            begin
                                                $display("ERROR at time %d: expected cw_tb = %b, found %b instead.\n", $time, R1_m_R2_cw, cw_tb);
                                                $stop;
                                            end
    				R1_and_R2_into_R3:      if(op_tb !== 2'b01)
                                            begin
                                                $display("ERROR at time %d: expected op = 01, found %b instead.\n", $time, op_tb);
                                                $stop;
                                            end
                                            else if(cw_tb !== R1_a_R2_cw)
                                            begin
                                                $display("ERROR at time %d: expected cw_tb = %b, found %b instead.\n", $time, R1_a_R2_cw, cw_tb);
                                                $stop;
                                            end
    				R1_xor_R2_into_R3:      if(op_tb !== 2'b00)
	   			                            begin
                                                $display("ERROR at time %d; expected op = 00, found %b instead.\n", $time, op_tb);
                                                $stop;
                                            end
                                            else if(cw_tb !== R1_x_R2_cw)
                                            begin
                                                $display("ERROR at time %d: expected cw_tb = %b, found %b instead.\n", $time,  R1_x_R2_cw, cw_tb);
                                                $stop;
                                            end
    				out_done:               if(cw_tb !== done_cw)
                                            begin
                                                $display("ERROR at time %d: expected cw_tb = %b, found %b instead.\n", $time, done_cw, cw_tb);
                                                $stop;
                                            end
			    endcase
			end
		end
    $display("Test Successful.\n");
    $finish;
	end
endmodule

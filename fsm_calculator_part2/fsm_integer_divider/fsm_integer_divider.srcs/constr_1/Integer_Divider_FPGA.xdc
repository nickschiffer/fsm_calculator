#Clock
    set_property -dict {PACKAGE_PIN E3  IOSTANDARD LVCMOS33} [get_ports {clk100MHz}]; 
    create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk100MHz}];
#switches
    #dividend
        set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports {dividend[0]}];
        set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports {dividend[1]}];
        set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {dividend[2]}];
        set_property -dict {PACKAGE_PIN R13 IOSTANDARD LVCMOS33} [get_ports {dividend[3]}];

    #divisor
        set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {divisor[0]}];
        set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports {divisor[1]}];
        set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports {divisor[2]}];
        set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports {divisor[3]}];

    #Buttons
        set_property -dict {PACKAGE_PIN P18  IOSTANDARD LVCMOS33} [get_ports {go}];
        set_property -dict {PACKAGE_PIN M18  IOSTANDARD LVCMOS33} [get_ports {man_clk}];
        set_property -dict {PACKAGE_PIN N17  IOSTANDARD LVCMOS33} [get_ports {rst}];


#LEDs
    #Result
        set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports {LEDOUT[0]}];
        set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {LEDOUT[1]}];
        set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports {LEDOUT[2]}]; 
        set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports {LEDOUT[3]}]; 
        set_property -dict {PACKAGE_PIN R10 IOSTANDARD LVCMOS33} [get_ports {LEDOUT[4]}]; 
        set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports {LEDOUT[5]}];
        set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {LEDOUT[6]}];
        set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports {LEDOUT[7]}]; 
        
        set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports {LEDSEL[0]}];
        set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {LEDSEL[1]}];
        set_property -dict {PACKAGE_PIN T9  IOSTANDARD LVCMOS33} [get_ports {LEDSEL[2]}];
        set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports {LEDSEL[3]}];
        set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {LEDSEL[4]}];
        set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports {LEDSEL[5]}];
        set_property -dict {PACKAGE_PIN K2  IOSTANDARD LVCMOS33} [get_ports {LEDSEL[6]}];
        set_property -dict {PACKAGE_PIN U13 IOSTANDARD LVCMOS33} [get_ports {LEDSEL[7]}];
    #Inputs out
        #dividend
            set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {dividend_out[0]}]; 
            set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports {dividend_out[1]}];
            set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports {dividend_out[2]}];
            set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports {dividend_out[3]}];
        #divisor
            set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {divisor_out[0]}];
            set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports {divisor_out[1]}];
            set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports {divisor_out[2]}];
            set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports {divisor_out[3]}];
        #Done
            set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS33} [get_ports {done}];
        #Error
            set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {error}];

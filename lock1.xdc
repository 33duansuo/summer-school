#CLK
create_clock -period 20.000 -name clk50mhz [get_ports clk50mhz]
#IO
set_property PACKAGE_PIN Y18 [get_ports clk]
set_property PACKAGE_PIN AB18 [get_ports {tubes[0]}]//tubes
set_property PACKAGE_PIN U17 [get_ports {tubes[1]}]
set_property PACKAGE_PIN U18 [get_ports {tubes[2]}]
set_property PACKAGE_PIN P14 [get_ports {tubes[3]}]
set_property PACKAGE_PIN R14 [get_ports {tubes[4]}]
set_property PACKAGE_PIN R18 [get_ports {tubes[5]}]
set_property PACKAGE_PIN T18 [get_ports {tubes[6]}]
set_property PACKAGE_PIN Y19 [get_ports {sel[7]}]//select,left one
set_property PACKAGE_PIN V18 [get_ports {sel[6]}]
set_property PACKAGE_PIN V19 [get_ports {sel[5]}]
set_property PACKAGE_PIN AA19 [get_ports {sel[4]}]
set_property PACKAGE_PIN AB20 [get_ports {sel[3]}]
set_property PACKAGE_PIN V17 [get_ports {sel[2]}]
set_property PACKAGE_PIN W17 [get_ports {sel[1]}]
set_property PACKAGE_PIN AA18 [get_ports {sel[0]}]//select,right one
set_property PACKAGE_PIN N14 [get_ports {one_digit[0]}]//sw1
set_property PACKAGE_PIN P16 [get_ports {one_digit[1]}]//sw2
set_property PACKAGE_PIN R17 [get_ports {one_digit[2]}]//sw3
set_property PACKAGE_PIN N15 [get_ports {one_digit[3]}]//sw4
set_property PACKAGE_PIN E3 [get_ports {load}]//key1(load)
set_property PACKAGE_PIN G4 [get_ports {admin_button}]//key2(identity)
set_property PACKAGE_PIN P19 [get_ports {ok_button}]//key3(press (=0) it when you finish entering)
set_property PACKAGE_PIN R19 [get_ports {key_buttion}]//key4(to buttion)
set_property IOSTANDARD LVCMOS33 [get_ports {load}]
set_property IOSTANDARD LVCMOS33 [get_ports {admin_button}]
set_property IOSTANDARD LVCMOS33 [get_ports {ok_button}]
set_property IOSTANDARD LVCMOS33 [get_ports {key_buttion}]
set_property IOSTANDARD LVCMOS33 [get_ports {one_digit[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {one_digit[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {one_digit[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {one_digit[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {tubes[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {tubes[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {tubes[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {tubes[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {tubes[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {tubes[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {tubes[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {tubes[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sel[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sel[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sel[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sel[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sel[3]}]   
set_property IOSTANDARD LVCMOS33 [get_ports {sel[2]}]   
set_property IOSTANDARD LVCMOS33 [get_ports {sel[1]}]   
set_property IOSTANDARD LVCMOS33 [get_ports {sel[0]}]   
set_property IOSTANDARD LVCMOS33 [get_ports {clk50mhz}]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

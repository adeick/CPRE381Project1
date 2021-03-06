#########################################################################
## John Brose
## Student Iowa State University
#########################################################################
## tb_MyFirstMIPSDatapath.do
#########################################################################
## DESCRIPTION: This file contains a do file for the testbench for the 
##              mux2t1 unit. It adds some useful signals for testing
##              functionality and debugging the system. It also formats
##              the waveform and runs the simulation.
##              
## 02/17/2021 by JB::Design created.
#########################################################################

# Setup the wave form with useful signals

# Add the standard, non-data clock and reset input signals.

# Add data inputs that are specific to this design. These are the ones set during our test cases.
# Note that I've set the radix to unsigned, meaning that the values in the waveform will be displayed
# as unsigned decimal values. This may be more convenient for your debugging. However, you should be
# careful to look at the radix specifier (e.g., the decimal value 32'd10 is the same as the hexidecimal
# value 32'hA.
add wave -noupdate -divider {MyFirstMIPSDatapath}
add wave -noupdate -divider {input_std_logic}
add wave -noupdate -label i_RST /tb_MyFirstMIPSDatapath/s_RST
add wave -noupdate -label nAdd_Sub /tb_MyFirstMIPSDatapath/nAdd_Sub
add wave -noupdate -label ALUSrc /tb_MyFirstMIPSDatapath/ALUSrc

add wave -noupdate -divider {input_opcode}
add wave -noupdate -label i_CLK /tb_MyFirstMIPSDatapath/s_CLK
add wave -noupdate -label i_rd -radix unsigned /tb_MyFirstMIPSDatapath/s_rd
add wave -noupdate -label i_rs -radix unsigned /tb_MyFirstMIPSDatapath/s_rs
add wave -noupdate -label i_rt -radix unsigned /tb_MyFirstMIPSDatapath/s_rt
add wave -noupdate -label i_immediate -radix signed /tb_MyFirstMIPSDatapath/s_immediate

add wave -noupdate -divider {output}
add wave -noupdate -label i_CLK /tb_MyFirstMIPSDatapath/s_CLK
add wave -noupdate -label o_ALU -radix signed /tb_MyFirstMIPSDatapath/s_ALU
add wave -noupdate -label i_rsData -radix signed /tb_MyFirstMIPSDatapath/s_rsData
add wave -noupdate -label i_rtData -radix signed /tb_MyFirstMIPSDatapath/s_rtData


# The following command will add all of the signals within the DUT0 module's scope (but not internal
# signals to submodules).
####add wave -noupdate /tb_mux2t1_N/DUT0/*



# Run for 100 timesteps (default is 1ns per timestep, but this can be modified so be aware).
run 3200
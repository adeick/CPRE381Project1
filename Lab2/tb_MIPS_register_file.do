#########################################################################
## John Brose
## Student Iowa State University
#########################################################################
## tb_MIPS_register_file.do
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
add wave -noupdate -divider {MIPS_register_file}
add wave -noupdate -divider {input}
add wave -noupdate -label i_CLK /tb_MIPS_register_file/s_CLK
add wave -noupdate -label i_RST /tb_MIPS_register_file/s_RST
add wave -noupdate -label i_rd -radix unsigned /tb_MIPS_register_file/s_rd
add wave -noupdate -label i_rdData /tb_MIPS_register_file/s_rdData

add wave -noupdate -divider {mux_rs_out}
add wave -noupdate -label i_rs -radix unsigned /tb_MIPS_register_file/s_rs
add wave -noupdate -label i_rsData /tb_MIPS_register_file/s_rsData

add wave -noupdate -divider {mux_rt_out}
add wave -noupdate -label i_rt -radix unsigned /tb_MIPS_register_file/s_rt
add wave -noupdate -label i_rtData /tb_MIPS_register_file/s_rtData

# The following command will add all of the signals within the DUT0 module's scope (but not internal
# signals to submodules).
####add wave -noupdate /tb_mux2t1_N/DUT0/*



# Run for 100 timesteps (default is 1ns per timestep, but this can be modified so be aware).
run 1000
#########################################################################
## John Brose
## Student Iowa State University
#########################################################################
## tb_dffg_N.do
#########################################################################
## DESCRIPTION: This file contains a do file for the testbench for the 
##              mux2t1 unit. It adds some useful signals for testing
##              functionality and debugging the system. It also formats
##              the waveform and runs the simulation.
##              
## 02/08/2021 by JB::Design created.
#########################################################################

# Setup the wave form with useful signals

# Add the standard, non-data clock and reset input signals.

# Add data inputs that are specific to this design. These are the ones set during our test cases.
# Note that I've set the radix to unsigned, meaning that the values in the waveform will be displayed
# as unsigned decimal values. This may be more convenient for your debugging. However, you should be
# careful to look at the radix specifier (e.g., the decimal value 32'd10 is the same as the hexidecimal
# value 32'hA.
add wave -noupdate -divider {dmem}
add wave -noupdate -divider {input}
add wave -noupdate -label i_CLK /tb_dmem/s_CLK
add wave -noupdate -label we /tb_dmem/s_we
add wave -noupdate -label addr /tb_dmem/s_addr


add wave -noupdate -divider {output}
add wave -noupdate -label data -radix signed /tb_dmem/s_data
add wave -noupdate -label q -radix signed /tb_dmem/s_q

# The following command will add all of the signals within the DUT0 module's scope (but not internal
# signals to submodules).
####add wave -noupdate /tb_mux2t1_N/DUT0/*



# Run for 100 timesteps (default is 1ns per timestep, but this can be modified so be aware).
run 2100
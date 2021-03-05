#########################################################################
## Henry Duwe
## Department of Electrical and Computer Engineering
## Iowa State University
#########################################################################
## tb_TPU_MV_Element.do
#########################################################################
## DESCRIPTION: This file contains a do file for the testbench for the 
##              TPU MAC unit. It adds some useful signals for testing
##              functionality and debugging the system. It also formats
##              the waveform and runs the simulation.
##              
## 01/04/2020 by H3::Design created.
#########################################################################

# Setup the wave form with useful signals

# Add the standard, non-data clock and reset input signals.
# First, add a helpful header label.
add wave -noupdate -divider {Standard Inputs}
add wave -noupdate -label s_clk /tb_regfile/s_clk
add wave -noupdate -label s_reset /tb_regfile/s_reset

# Add data inputs that are specific to this design. These are the ones set during our test cases.
# Note that I've set the radix to unsigned, meaning that the values in the waveform will be displayed
# as unsigned decimal values. This may be more convenient for your debugging. However, you should be
# careful to look at the radix specifier (e.g., the decimal value 32'd10 is the same as the hexidecimal
# value 32'hA.
add wave -noupdate -divider {Data Inputs}
add wave -noupdate -radix hexadecimal /tb_regfile/s_wA
add wave -noupdate -radix hexadecimal /tb_regfile/s_wD
add wave -noupdate -radix hexadecimal /tb_regfile/s_wC
add wave -noupdate -radix hexadecimal /tb_regfile/s_r1
add wave -noupdate -radix hexadecimal /tb_regfile/s_r2

# Add data outputs that are specific to this design. These are the ones that we'll check for correctness.
add wave -noupdate -divider {Data Outputs}
add wave -noupdate -radix hexadecimal /tb_regfile/s_d1
add wave -noupdate -radix hexadecimal /tb_regfile/s_d2

# Add the standard, non-data clock and reset input signals again.
# As you develop more complicated designs with many more signals, you will probably find it helpful to
# add these signals at multiple points within your waveform so you can easily see cycle behavior, etc.
add wave -noupdate -divider {Standard Inputs}
add wave -noupdate /tb_regfile/s_clk
add wave -noupdate /tb_regfile/s_reset

# Add some internal signals. As you debug you will likely want to trace the origin of signals
# back through your design hierarchy which will require you to add signals from within sub-components.
# These are provided just to illustrate how to do this. Note that any signals that are not added to
# the wave prior to the run command may not have their values stored during simulation. Therefore, if
# you decided to add them after simulation they will appear as blank.
# Note that I've left the radix of these signals set to the default, which, for me, is hexidecimal.
add wave -noupdate -divider {Internal Signals}
add wave -noupdate -radix hexadecimal /tb_regfile/DUT/s1
add wave -noupdate -radix hexadecimal /tb_regfile/DUT/s2
add wave -noupdate -radix hexadecimal /tb_regfile/DUT/s3


add wave -noupdate -divider {Internal Read}
add wave -noupdate /tb_regfile/DUT/Read1/i_I
add wave -noupdate /tb_regfile/DUT/Read1/o_O
add wave -noupdate /tb_regfile/DUT/Read2/i_I
add wave -noupdate /tb_regfile/DUT/Read2/o_O

add wave -noupdate -divider {Internal Read}
add wave -noupdate /tb_regfile/DUT/RegisterList(1)/REGI/i_WE
add wave -noupdate /tb_regfile/DUT/RegisterList(1)/REGI/i_D
add wave -noupdate /tb_regfile/DUT/RegisterList(1)/REGI/o_Q

# The following command will add all of the signals within the DUT0 module's scope (but not internal
# signals to submodules).

# TODO: Add your own signals as needed!



# Run for 100 timesteps (default is 1ns per timestep, but this can be modified so be aware).
run 600 
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Datapath I/O}
add wave -noupdate /tb_datapathv2/s_clk
add wave -noupdate /tb_datapathv2/s_reset
add wave -noupdate /tb_datapathv2/s_addsub
add wave -noupdate /tb_datapathv2/s_alu
add wave -noupdate /tb_datapathv2/s_memW
add wave -noupdate /tb_datapathv2/s_ldData
add wave -noupdate /tb_datapathv2/s_regW
add wave -noupdate /tb_datapathv2/s_imm
add wave -noupdate /tb_datapathv2/s_d1
add wave -noupdate /tb_datapathv2/s_d2
add wave -noupdate /tb_datapathv2/s_A
add wave -noupdate /tb_datapathv2/s_B
add wave -noupdate /tb_datapathv2/s_C

add wave -noupdate -divider {Register Data}
add wave -noupdate /tb_datapathv2/DUT/registers/s2


add wave -noupdate -divider {Memory Data}
add wave -noupdate /tb_datapathv2/DUT/dmem/ram

add wave -noupdate -divider {Internal DP Signals}
add wave -noupdate /tb_datapathv2/DUT/s1
add wave -noupdate /tb_datapathv2/DUT/s2
add wave -noupdate /tb_datapathv2/DUT/s3
add wave -noupdate /tb_datapathv2/DUT/s4
add wave -noupdate /tb_datapathv2/DUT/s5
add wave -noupdate /tb_datapathv2/DUT/s6
add wave -noupdate /tb_datapathv2/DUT/s7
add wave -noupdate /tb_datapathv2/DUT/s8
add wave -noupdate /tb_datapathv2/DUT/s9


run 800

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {162 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 196
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {845 ns}

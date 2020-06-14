onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/SI_Reset_N
add wave -noupdate /testbench/SI_ClkIn
add wave -noupdate /testbench/HADDR
add wave -noupdate /testbench/HRDATA
add wave -noupdate /testbench/HWDATA
add wave -noupdate /testbench/HWRITE
add wave -noupdate -radix dec /testbench/IO_LED
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {207813 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 170
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {3144750 ps}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /main/DUT/q_o
add wave -noupdate /main/DUT/enable_i
add wave -noupdate /main/DUT2/enable_i
add wave -noupdate /main/DUT2/q_o
add wave -noupdate /main/DUT/r
add wave -noupdate /main/DUT/r
add wave -noupdate /main/DUT2/r
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {210 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ns} {658 ns}

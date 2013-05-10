onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /main/DUT/g_goal
add wave -noupdate /main/DUT/g_acc_shift
add wave -noupdate /main/DUT/clk_i
add wave -noupdate /main/DUT/rst_n_i
add wave -noupdate /main/DUT/d_valid_i
add wave -noupdate /main/DUT/d_i
add wave -noupdate /main/DUT/q_valid_o
add wave -noupdate /main/DUT/q_o
add wave -noupdate /main/DUT/ki_i
add wave -noupdate /main/DUT/kp_i
add wave -noupdate /main/DUT/acc
add wave -noupdate /main/DUT/err
add wave -noupdate /main/DUT/d0
add wave -noupdate /main/DUT/d1
add wave -noupdate /main/DUT/stage
add wave -noupdate /main/DUT/ds
add wave -noupdate /main/DUT/acc0
add wave -noupdate /main/DUT/term_p
add wave -noupdate /main/DUT/term_i
add wave -noupdate /main/DUT/sum
add wave -noupdate /main/DUT/clk_i
add wave -noupdate /main/DUT/rst_n_i
add wave -noupdate /main/DUT/d_valid_i
add wave -noupdate /main/DUT/d_i
add wave -noupdate /main/DUT/q_valid_o
add wave -noupdate /main/DUT/q_o
add wave -noupdate /main/DUT/ki_i
add wave -noupdate /main/DUT/kp_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {38 ns} 0}
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
WaveRestoreZoom {0 ns} {132 ns}

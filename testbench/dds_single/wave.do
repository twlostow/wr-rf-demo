onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /main/DUT/g_acc_frac_bits
add wave -noupdate /main/DUT/g_dither_init_value
add wave -noupdate /main/DUT/g_output_bits
add wave -noupdate /main/DUT/g_lut_sample_bits
add wave -noupdate /main/DUT/g_lut_slope_bits
add wave -noupdate /main/DUT/g_interp_shift
add wave -noupdate /main/DUT/g_lut_size_log2
add wave -noupdate /main/DUT/c_acc_bits
add wave -noupdate /main/DUT/c_output_shift
add wave -noupdate /main/DUT/clk_i
add wave -noupdate /main/DUT/rst_n_i
add wave -noupdate /main/DUT/acc_load_i
add wave -noupdate /main/DUT/tune_load_i
add wave -noupdate /main/DUT/acc_i
add wave -noupdate /main/DUT/tune_i
add wave -noupdate /main/DUT/dreq_i
add wave -noupdate -format Analog-Step -height 100 -max 2048.0 -min -2048.0 /main/DUT/y_o
add wave -noupdate -format Analog-Step -height 50 -max 1000.0 -min -1000.0 -radix decimal /main/DUT/interp
add wave -noupdate /main/DUT/lut_addr_o
add wave -noupdate /main/DUT/lut_data_i
add wave -noupdate /main/DUT/acc0
add wave -noupdate /main/DUT/acc1
add wave -noupdate /main/DUT/tune
add wave -noupdate /main/DUT/phase
add wave -noupdate /main/DUT/frac
add wave -noupdate /main/DUT/half
add wave -noupdate /main/DUT/addr0
add wave -noupdate /main/DUT/addr1
add wave -noupdate /main/DUT/tmp
add wave -noupdate /main/DUT/tmp2
add wave -noupdate /main/DUT/sign
add wave -noupdate /main/DUT/lut_in
add wave -noupdate /main/DUT/lut_slope
add wave -noupdate -radix decimal /main/DUT/lut_sample
add wave -noupdate -radix decimal /main/DUT/qv
add wave -noupdate /main/DUT/interp_mul
add wave -noupdate /main/DUT/clk_i
add wave -noupdate /main/DUT/rst_n_i
add wave -noupdate /main/DUT/acc_load_i
add wave -noupdate /main/DUT/tune_load_i
add wave -noupdate /main/DUT/acc_i
add wave -noupdate /main/DUT/tune_i
add wave -noupdate /main/DUT/dreq_i
add wave -noupdate -format Analog-Step -height 100 -max 2048.0 -min -2048.0 /main/DUT/y_o
add wave -noupdate /main/DUT/dither_in
add wave -noupdate /main/DUT/lfsr
add wave -noupdate /main/DUT/lut_addr_o
add wave -noupdate /main/DUT/lut_data_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19833 ps} 0}
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
WaveRestoreZoom {6845 ps} {33095 ps}

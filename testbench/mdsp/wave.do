onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /main/x_req
add wave -noupdate /main/count
add wave -noupdate /main/x_valid
add wave -noupdate /main/in_index
add wave -noupdate -radix hexadecimal /main/DUT/g_data_bits
add wave -noupdate -radix hexadecimal /main/DUT/g_coef_bits
add wave -noupdate -radix hexadecimal /main/DUT/g_acc_shift
add wave -noupdate -radix hexadecimal /main/DUT/g_state_bits
add wave -noupdate -radix hexadecimal /main/DUT/g_microcode_size
add wave -noupdate -radix hexadecimal /main/DUT/c_acc_width
add wave -noupdate -radix hexadecimal /main/DUT/c_microcode_addr_bits
add wave -noupdate -radix hexadecimal /main/DUT/clk_i
add wave -noupdate -radix hexadecimal /main/DUT/rst_n_i
add wave -noupdate -radix hexadecimal /main/DUT/x_req_o
add wave -noupdate -radix hexadecimal /main/DUT/x_valid_i
add wave -noupdate -radix hexadecimal /main/DUT/x_i
add wave -noupdate -radix hexadecimal /main/DUT/y_valid_o
add wave -noupdate -radix hexadecimal /main/DUT/y_req_i
add wave -noupdate -radix hexadecimal /main/DUT/y_o
add wave -noupdate -radix hexadecimal /main/DUT/stall
add wave -noupdate /main/DUT/pd_use_in
add wave -noupdate -radix hexadecimal /main/DUT/f_use_in
add wave -noupdate /main/DUT/d_use_in
add wave -noupdate -radix hexadecimal /main/DUT/pc
add wave -noupdate /main/DUT/pc_d0
add wave -noupdate -radix hexadecimal /main/DUT/f_didx
add wave -noupdate -radix hexadecimal /main/DUT/f_sidx
add wave -noupdate -radix hexadecimal /main/DUT/f_coef
add wave -noupdate -radix hexadecimal /main/DUT/f_mul_only
add wave -noupdate -radix hexadecimal /main/DUT/f_write_dest
add wave -noupdate -radix hexadecimal /main/DUT/f_write_out
add wave -noupdate -radix hexadecimal /main/DUT/f_store_acc
add wave -noupdate -radix hexadecimal /main/DUT/f_oidx
add wave -noupdate /main/DUT/pd_didx
add wave -noupdate /main/DUT/pd_sidx
add wave -noupdate /main/DUT/pd_coef
add wave -noupdate /main/DUT/pd_mul_only
add wave -noupdate /main/DUT/pd_write_dest
add wave -noupdate /main/DUT/pd_write_out
add wave -noupdate /main/DUT/pd_store_acc
add wave -noupdate /main/DUT/pd_finish
add wave -noupdate /main/DUT/pd_oidx
add wave -noupdate /main/DUT/pd_state
add wave -noupdate -radix hexadecimal /main/DUT/d_didx
add wave -noupdate -radix hexadecimal /main/DUT/d_coef
add wave -noupdate -radix hexadecimal /main/DUT/d_mul_only
add wave -noupdate -radix hexadecimal /main/DUT/d_write_dest
add wave -noupdate -radix hexadecimal /main/DUT/d_write_out
add wave -noupdate -radix hexadecimal /main/DUT/d_store_acc
add wave -noupdate -radix hexadecimal /main/DUT/d_oidx
add wave -noupdate -radix hexadecimal /main/DUT/d_state
add wave -noupdate /main/DUT/d_opcode
add wave -noupdate -radix hexadecimal /main/DUT/e1_didx
add wave -noupdate -radix hexadecimal /main/DUT/e1_write_dest
add wave -noupdate -radix hexadecimal /main/DUT/e1_write_out
add wave -noupdate -radix hexadecimal /main/DUT/e1_store_acc
add wave -noupdate -radix hexadecimal /main/DUT/e1_oidx
add wave -noupdate -radix hexadecimal /main/DUT/e1_state
add wave -noupdate -radix hexadecimal /main/DUT/e2_didx
add wave -noupdate -radix hexadecimal /main/DUT/e2_write_dest
add wave -noupdate -radix hexadecimal /main/DUT/e2_write_out
add wave -noupdate -radix hexadecimal /main/DUT/e2_store_acc
add wave -noupdate -radix hexadecimal /main/DUT/e2_oidx
add wave -noupdate -radix hexadecimal /main/DUT/e2_state
add wave -noupdate -radix hexadecimal /main/DUT/acc0
add wave -noupdate -radix hexadecimal /main/DUT/acc1
add wave -noupdate -radix hexadecimal /main/DUT/acc_trunc
add wave -noupdate -radix hexadecimal /main/DUT/state_mem
add wave -noupdate -radix hexadecimal /main/DUT/reset_wb
add wave -noupdate -radix hexadecimal /main/DUT/rst_n
add wave -noupdate -radix hexadecimal /main/DUT/clk_i
add wave -noupdate -radix hexadecimal /main/DUT/rst_n_i
add wave -noupdate -radix hexadecimal /main/DUT/x_req_o
add wave -noupdate -radix hexadecimal /main/DUT/x_valid_i
add wave -noupdate -radix hexadecimal /main/DUT/x_i
add wave -noupdate -radix hexadecimal /main/DUT/y_valid_o
add wave -noupdate -radix hexadecimal /main/DUT/y_req_i
add wave -noupdate -radix hexadecimal /main/DUT/y_o
add wave -noupdate -radix hexadecimal /main/DUT/wb_cyc_i
add wave -noupdate -radix hexadecimal /main/DUT/wb_stb_i
add wave -noupdate -radix hexadecimal /main/DUT/wb_we_i
add wave -noupdate -radix hexadecimal /main/DUT/wb_adr_i
add wave -noupdate -radix hexadecimal /main/DUT/wb_dat_i
add wave -noupdate -radix hexadecimal /main/DUT/wb_dat_o
add wave -noupdate -radix hexadecimal /main/DUT/wb_stall_o
add wave -noupdate -radix hexadecimal /main/DUT/wb_ack_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {725 ns} 0}
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
WaveRestoreZoom {365 ns} {893 ns}

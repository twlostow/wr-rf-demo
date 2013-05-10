onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/g_goal
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/g_acc_shift
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/clk_i
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/rst_n_i
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/d_valid_i
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/d_i
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/q_valid_o
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/clip_plus
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/clip_minus
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/q_o
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/ki_i
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/kp_i
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/acc
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/err
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/d0
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/d1
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/stage
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/ds
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/acc0
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/term_p
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/term_i
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/sum
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/mul_p
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/mul_i
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/clk_i
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/rst_n_i
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/d_valid_i
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/d_i
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/q_valid_o
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/q_o
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/ki_i
add wave -noupdate -expand -group PI /main/DUT/U_The_DDS_Core/pi_control_1/kp_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/clk_sys_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/clk_dds_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/clk_ref_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/rst_n_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/tm_time_valid_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/tm_tai_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/tm_cycles_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/dac_n_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/dac_p_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/dac_pwdn_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/clk_dds_locked_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pll_vcxo_cs_n_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pll_vcxo_function_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pll_vcxo_sdo_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pll_vcxo_status_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pll_sys_cs_n_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pll_sys_refmon_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pll_sys_ld_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pll_sys_reset_n_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pll_sys_status_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pll_sys_sync_n_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pll_sclk_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pll_sdio_b
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pd_ce_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pd_lockdet_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pd_clk_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pd_data_b
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pd_le_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/adc_sdo_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/adc_sck_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/adc_cnv_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/adc_sdi_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/si57x_oe_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/si57x_sda_b
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/si57x_scl_b
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/slave_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/slave_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/src_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/src_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/snk_i
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/snk_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/swrst_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/fpll_reset_o
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/dac_data_par
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/cnx_out
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/cnx_in
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/synth_tune
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/synth_tune_d0
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/synth_tune_d1
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/synth_tune_bias
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/synth_acc_in
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/synth_acc_out
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/synth_tune_load
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/synth_acc_load
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/synth_y0
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/synth_y1
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/synth_y2
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/synth_y3
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/regs_in
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/regs_out
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/swrst
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/swrst_n
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/rst_n_ref
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/rst_ref
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/cic_out
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/cic_in
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/cic_out_clamp
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/cic_ce
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/tune_empty_d0
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/adc_data
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/adc_dvalid
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/mdsp_out
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/pi_out
add wave -noupdate -radix decimal /main/DUT/U_The_DDS_Core/mdsp_in
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {247278867 ps} 0}
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
WaveRestoreZoom {194778867 ps} {299778867 ps}

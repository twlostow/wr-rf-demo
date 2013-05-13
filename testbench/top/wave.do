onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Top-A /main/DUT_A/clk_20m_vcxo_i
add wave -noupdate -expand -group Top-A /main/DUT_A/l_rst_n
add wave -noupdate -expand -group Top-A /main/DUT_A/gpio
add wave -noupdate -expand -group Top-A /main/DUT_A/p2l_rdy
add wave -noupdate -expand -group Top-A /main/DUT_A/p2l_clkn
add wave -noupdate -expand -group Top-A /main/DUT_A/p2l_clkp
add wave -noupdate -expand -group Top-A /main/DUT_A/p2l_data
add wave -noupdate -expand -group Top-A /main/DUT_A/p2l_dframe
add wave -noupdate -expand -group Top-A /main/DUT_A/p2l_valid
add wave -noupdate -expand -group Top-A /main/DUT_A/p_wr_req
add wave -noupdate -expand -group Top-A /main/DUT_A/p_wr_rdy
add wave -noupdate -expand -group Top-A /main/DUT_A/rx_error
add wave -noupdate -expand -group Top-A /main/DUT_A/l2p_data
add wave -noupdate -expand -group Top-A /main/DUT_A/l2p_dframe
add wave -noupdate -expand -group Top-A /main/DUT_A/l2p_valid
add wave -noupdate -expand -group Top-A /main/DUT_A/l2p_clkn
add wave -noupdate -expand -group Top-A /main/DUT_A/l2p_clkp
add wave -noupdate -expand -group Top-A /main/DUT_A/l2p_edb
add wave -noupdate -expand -group Top-A /main/DUT_A/l2p_rdy
add wave -noupdate -expand -group Top-A /main/DUT_A/l_wr_rdy
add wave -noupdate -expand -group Top-A /main/DUT_A/p_rd_d_rdy
add wave -noupdate -expand -group Top-A /main/DUT_A/tx_error
add wave -noupdate -expand -group Top-A /main/DUT_A/vc_rdy
add wave -noupdate -expand -group Top-A /main/DUT_A/led_red
add wave -noupdate -expand -group Top-A /main/DUT_A/led_green
add wave -noupdate -expand -group Top-A /main/DUT_A/dac_sclk_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dac_din_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dac_cs1_n_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dac_cs2_n_o
add wave -noupdate -expand -group Top-A /main/DUT_A/button1_i
add wave -noupdate -expand -group Top-A /main/DUT_A/button2_i
add wave -noupdate -expand -group Top-A /main/DUT_A/fmc_scl_b
add wave -noupdate -expand -group Top-A /main/DUT_A/fmc_sda_b
add wave -noupdate -expand -group Top-A /main/DUT_A/carrier_onewire_b
add wave -noupdate -expand -group Top-A /main/DUT_A/fmc_prsnt_m2c_l_i
add wave -noupdate -expand -group Top-A /main/DUT_A/sfp_txp_o
add wave -noupdate -expand -group Top-A /main/DUT_A/sfp_txn_o
add wave -noupdate -expand -group Top-A /main/DUT_A/sfp_rxp_i
add wave -noupdate -expand -group Top-A /main/DUT_A/sfp_rxn_i
add wave -noupdate -expand -group Top-A /main/DUT_A/sfp_mod_def0_b
add wave -noupdate -expand -group Top-A /main/DUT_A/sfp_mod_def1_b
add wave -noupdate -expand -group Top-A /main/DUT_A/sfp_mod_def2_b
add wave -noupdate -expand -group Top-A /main/DUT_A/sfp_rate_select_b
add wave -noupdate -expand -group Top-A /main/DUT_A/sfp_tx_fault_i
add wave -noupdate -expand -group Top-A /main/DUT_A/sfp_tx_disable_o
add wave -noupdate -expand -group Top-A /main/DUT_A/sfp_los_i
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_dac_n_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_dac_p_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_dac_pwdn_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_pll_vcxo_cs_n_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_pll_vcxo_function_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_pll_vcxo_sdo_i
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_pll_vcxo_status_i
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_pll_sys_cs_n_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_pll_sys_refmon_i
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_pll_sys_ld_i
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_pll_sys_reset_n_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_pll_sys_status_i
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_pll_sys_sync_n_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_pll_sclk_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_pll_sdio_b
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_wr_ref_clk_p_i
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_wr_ref_clk_n_i
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_wr_dac_sclk_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_wr_dac_din_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_wr_dac_sync_n_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_pd_ce_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_pd_lockdet_i
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_pd_clk_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_pd_data_b
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_pd_le_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_adc_sdo_i
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_adc_sck_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_adc_cnv_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_adc_sdi_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_si57x_oe_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_si57x_sda_b
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_si57x_scl_b
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_onewire_b
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_trig_term_en_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_trig_dir_o
add wave -noupdate -expand -group Top-A /main/DUT_A/dds_trig_act_o
add wave -noupdate -expand -group Top-A /main/DUT_A/uart_rxd_i
add wave -noupdate -expand -group Top-A /main/DUT_A/uart_txd_o
add wave -noupdate -expand -group Top-A /main/DUT_A/clk_125m_pllref
add wave -noupdate -expand -group Top-A /main/DUT_A/clk_dmtd
add wave -noupdate -expand -group Top-A /main/DUT_A/clk_dds
add wave -noupdate -expand -group Top-A /main/DUT_A/clk_ref
add wave -noupdate -expand -group Top-A /main/DUT_A/clk_sys
add wave -noupdate -expand -group Top-A /main/DUT_A/pllout_clk_dmtd
add wave -noupdate -expand -group Top-A /main/DUT_A/pllout_clk_dds
add wave -noupdate -expand -group Top-A /main/DUT_A/pllout_clk_ref
add wave -noupdate -expand -group Top-A /main/DUT_A/pllout_clk_sys
add wave -noupdate -expand -group Top-A /main/DUT_A/clk_20m_vcxo_buf
add wave -noupdate -expand -group Top-A /main/DUT_A/gn_wb_adr
add wave -noupdate -expand -group Top-A /main/DUT_A/local_reset_n
add wave -noupdate -expand -group Top-A /main/DUT_A/fpll_locked
add wave -noupdate -expand -group Top-A /main/DUT_A/pllout_clk_fb_pllref
add wave -noupdate -expand -group Top-A /main/DUT_A/swrst
add wave -noupdate -expand -group Top-A /main/DUT_A/swrst_n
add wave -noupdate -expand -group Top-A /main/DUT_A/fpll_reset
add wave -noupdate -expand -group Top-A /main/DUT_A/cnx_master_out
add wave -noupdate -expand -group Top-A /main/DUT_A/cnx_master_in
add wave -noupdate -expand -group Top-A /main/DUT_A/cnx_slave_out
add wave -noupdate -expand -group Top-A /main/DUT_A/cnx_slave_in
add wave -noupdate -expand -group Top-A /main/DUT_A/pllout_clk_fb_dmtd
add wave -noupdate -expand -group Top-A /main/DUT_A/dac_cs1_n
add wave -noupdate -expand -group Top-A /main/DUT_A/dac_sclk
add wave -noupdate -expand -group Top-A /main/DUT_A/dac_din
add wave -noupdate -expand -group Top-A /main/DUT_A/dac_hpll_load_p1
add wave -noupdate -expand -group Top-A /main/DUT_A/dac_dpll_load_p1
add wave -noupdate -expand -group Top-A /main/DUT_A/dac_hpll_data
add wave -noupdate -expand -group Top-A /main/DUT_A/dac_dpll_data
add wave -noupdate -expand -group Top-A /main/DUT_A/phy_tx_data
add wave -noupdate -expand -group Top-A /main/DUT_A/phy_tx_k
add wave -noupdate -expand -group Top-A /main/DUT_A/phy_tx_disparity
add wave -noupdate -expand -group Top-A /main/DUT_A/phy_tx_enc_err
add wave -noupdate -expand -group Top-A /main/DUT_A/phy_rx_data
add wave -noupdate -expand -group Top-A /main/DUT_A/phy_rx_rbclk
add wave -noupdate -expand -group Top-A /main/DUT_A/phy_rx_k
add wave -noupdate -expand -group Top-A /main/DUT_A/phy_rx_enc_err
add wave -noupdate -expand -group Top-A /main/DUT_A/phy_rx_bitslide
add wave -noupdate -expand -group Top-A /main/DUT_A/phy_rst
add wave -noupdate -expand -group Top-A /main/DUT_A/phy_loopen
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_scl_out
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_scl_in
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_sda_out
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_sda_in
add wave -noupdate -expand -group Top-A /main/DUT_A/fd_scl_out
add wave -noupdate -expand -group Top-A /main/DUT_A/fd_scl_in
add wave -noupdate -expand -group Top-A /main/DUT_A/fd_sda_out
add wave -noupdate -expand -group Top-A /main/DUT_A/fd_sda_in
add wave -noupdate -expand -group Top-A /main/DUT_A/sfp_scl_out
add wave -noupdate -expand -group Top-A /main/DUT_A/sfp_scl_in
add wave -noupdate -expand -group Top-A /main/DUT_A/sfp_sda_out
add wave -noupdate -expand -group Top-A /main/DUT_A/sfp_sda_in
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_owr_en
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_owr_in
add wave -noupdate -expand -group Top-A /main/DUT_A/fd_owr_en
add wave -noupdate -expand -group Top-A /main/DUT_A/fd_owr_in
add wave -noupdate -expand -group Top-A /main/DUT_A/pps
add wave -noupdate -expand -group Top-A /main/DUT_A/tm_link_up
add wave -noupdate -expand -group Top-A /main/DUT_A/tm_utc
add wave -noupdate -expand -group Top-A /main/DUT_A/tm_cycles
add wave -noupdate -expand -group Top-A /main/DUT_A/tm_time_valid
add wave -noupdate -expand -group Top-A /main/DUT_A/tm_clk_aux_lock_en
add wave -noupdate -expand -group Top-A /main/DUT_A/tm_clk_aux_locked
add wave -noupdate -expand -group Top-A /main/DUT_A/tm_dac_value
add wave -noupdate -expand -group Top-A /main/DUT_A/tm_dac_wr
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_snk_out
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_snk_in
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_src_out
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_src_in
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_true_snk_out
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_true_snk_in
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_true_src_out
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_true_src_in
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_snk_in_cyc
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_src_out_cyc
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_snk_in_stb
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_src_out_stb
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_snk_in_we
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_src_out_we
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_snk_in_adr
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_src_out_adr
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_snk_in_sel
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_src_out_sel
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_snk_in_dat
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_src_out_dat
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_snk_out_stall
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_src_in_stall
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_snk_out_err
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_src_in_err
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_snk_out_rty
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_src_in_rty
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_snk_out_ack
add wave -noupdate -expand -group Top-A /main/DUT_A/wrc_src_in_ack
add wave -noupdate -expand -group Top-A /main/DUT_A/pll_init_done
add wave -noupdate -expand -group Top-A /main/DUT_A/pll_init_done_sys
add wave -noupdate -expand -group Top-A /main/DUT_A/spec_reset_n
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/g_with_vlans
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/g_with_timestamper
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/g_force_gap_length
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/clk_sys_i
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/rst_n_i
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/pcs_fab_o
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/pcs_error_i
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/pcs_busy_i
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/pcs_dreq_i
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/snk_i
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/snk_o
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/fc_pause_p_i
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/fc_pause_delay_i
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/fc_pause_ack_o
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/fc_flow_enable_i
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/txtsu_port_id_o
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/txtsu_fid_o
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/txtsu_ts_value_o
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/txtsu_ts_incorrect_o
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/txtsu_stb_o
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/txtsu_ack_i
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/txts_timestamp_i
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/txts_timestamp_valid_i
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/regs_i
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/state
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/counter
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/tx_ready
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/crc_gen_reset
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/crc_gen_force_reset
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/crc_gen_enable
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/crc_gen_enable_mask
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/crc_value
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/q_bytesel
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/q_valid
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/q_data
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/q_sof
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/q_eof
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/q_abort
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/write_mask
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/odd_length
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/tx_pause_mode
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/tx_pause_delay
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/snk_valid
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/sof_p1
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/eof_p1
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/abort_p1
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/error_p1
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/snk_cyc_d0
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/decoded_status
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/stored_status
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/oob_state
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/oob
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/snk_out
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/abort_now
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/stall_int
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/stall_int_d0
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/untagging
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/got_error
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/vut_rd_vid
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/vut_wr_vid
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/vut_untag
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/vut_is_802_1q
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/vut_stored_tag
add wave -noupdate -group A-Ep /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_Tx_Framer/vut_stored_ethertype
add wave -noupdate -expand -group Master-CIC -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Cic/clk_i
add wave -noupdate -expand -group Master-CIC -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Cic/en_i
add wave -noupdate -expand -group Master-CIC -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Cic/rst_i
add wave -noupdate -expand -group Master-CIC -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Cic/x_i
add wave -noupdate -expand -group Master-CIC -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Cic/y_o
add wave -noupdate -expand -group Master-CIC -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Cic/ce_out_o
add wave -noupdate -expand -group Slave-CIC -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Cic/clk_i
add wave -noupdate -expand -group Slave-CIC -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Cic/en_i
add wave -noupdate -expand -group Slave-CIC -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Cic/rst_i
add wave -noupdate -expand -group Slave-CIC -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Cic/x_i
add wave -noupdate -expand -group Slave-CIC -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Cic/y_o
add wave -noupdate -expand -group Slave-CIC -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Cic/ce_out_o
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/g_acc_bits
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/clk_sys_i
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/clk_ref_i
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/rst_n_sys_i
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/rst_n_ref_i
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/tune_i
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/cic_ce_i
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/acc_i
add wave -noupdate -expand -group Tx-A -radix hexadecimal -childformat {{/main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_i.ack -radix hexadecimal} {/main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_i.stall -radix hexadecimal} {/main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_i.err -radix hexadecimal} {/main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_i.rty -radix hexadecimal}} -expand -subitemconfig {/main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_i.ack {-height 17 -radix hexadecimal} /main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_i.stall {-height 17 -radix hexadecimal} /main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_i.err {-height 17 -radix hexadecimal} /main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_i.rty {-height 17 -radix hexadecimal}} /main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_i
add wave -noupdate -expand -group Tx-A -radix hexadecimal -childformat {{/main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_o.adr -radix hexadecimal} {/main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_o.dat -radix hexadecimal} {/main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_o.cyc -radix hexadecimal} {/main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_o.stb -radix hexadecimal} {/main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_o.we -radix hexadecimal} {/main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_o.sel -radix hexadecimal}} -expand -subitemconfig {/main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_o.adr {-height 17 -radix hexadecimal} /main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_o.dat {-height 17 -radix hexadecimal} /main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_o.cyc {-height 17 -radix hexadecimal} /main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_o.stb {-height 17 -radix hexadecimal} /main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_o.we {-height 17 -radix hexadecimal} /main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_o.sel {-height 17 -radix hexadecimal}} /main/DUT_A/U_The_DDS_Core/U_Tx_Path/src_o
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/tm_time_valid_i
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/tm_tai_i
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/tm_cycles_i
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/regs_i
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/tx_data
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/tx_valid
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/tx_dreq
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/tx_last
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/acc_snap
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/tune_snap
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/tai_snap
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/cycles_snap
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/new_sample
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/new_sample_sys
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/tune_valid
add wave -noupdate -expand -group Tx-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/state
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/g_acc_bits
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/clk_sys_i
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/clk_ref_i
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/rst_n_sys_i
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/rst_n_ref_i
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/tune_o
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/cic_reset_o
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/acc_o
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/acc_load_o
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/snk_i
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/snk_o
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/tm_time_valid_i
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/tm_tai_i
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/tm_cycles_i
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/regs_i
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/regs_o
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/mac_target
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/rx_data
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/rx_valid
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/rx_dreq
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/rx_last
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/rx_first
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/rx_cnt
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/hit_cnt
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/miss_cnt
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/acc_sys
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/acc_ref
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/tune_sys
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/tune_ref
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/tai_sys
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/tai_ref
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/tai_adj
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/cycles_sys
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/cycles_ref
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/cycles_adj
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/tai_d0
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/cycles_d0
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/compare_enable
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/compare_done
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/new_sample_sys
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/new_sample_ref
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/new_sample_rdy
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/adjusted_rdy
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/drive_start
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/rx_state
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/drv_state
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/cic_state
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/ts_miss
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/ts_hit
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/sync_ready
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/fifo_in
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/fifo_out
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/fifo_rd
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/fifo_full
add wave -noupdate -expand -group Rx-B -radix hexadecimal /main/DUT_B/U_The_DDS_Core/U_Rx_path/fifo_empty
add wave -noupdate -radix hexadecimal /main/a2b_p
add wave -noupdate -radix hexadecimal /main/a2b_n
add wave -noupdate -radix hexadecimal /main/b2a_p
add wave -noupdate -radix hexadecimal /main/b2a_n
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/tm_link_up_o
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/g_data_width
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/g_tx_threshold
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/g_tx_max_words_per_frame
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/g_tx_timeout
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/clk_sys_i
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/rst_n_i
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/src_i
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/src_o
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/clk_ref_i
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tm_time_valid_i
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tm_tai_i
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tm_cycles_i
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_data_i
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_valid_i
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_dreq_o
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_last_i
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_flush_i
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_reset_seq_i
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/cfg_mac_local_i
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/cfg_mac_target_i
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/cfg_ethertype_i
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_threshold_hit
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_timeout_hit
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_flush_latched
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_fifo_last
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_fifo_we
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_fifo_full
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_fifo_empty
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_fifo_rd
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_fifo_q
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_fifo_d
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_fifo_valid
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/state
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/seq_no
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/count
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/ser_count
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/total_words
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/timeout_counter
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/pack_data
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/fsm_out
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/escaper
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/fab_src
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/fsm_escape
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/fsm_escape_enable
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/crc_en
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/crc_en_masked
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/crc_reset
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/crc_value
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_almost_empty
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tx_almost_full
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/buf_frame_count
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tag_cycles
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tag_valid
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/tag_valid_latched
add wave -noupdate -expand -group Streamer-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/reset_dly
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/clk_i
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/rst_n_i
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/src_i
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/src_o
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/addr_i
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/data_i
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/dvalid_i
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/sof_i
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/eof_i
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/error_i
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/bytesel_i
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/dreq_o
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/q_valid
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/full
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/we
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/rd
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/rd_d0
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/fin
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/fout
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/pre_dvalid
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/pre_eof
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/pre_data
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/pre_addr
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/post_dvalid
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/post_eof
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/post_bytesel
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/post_sof
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/err_status
add wave -noupdate -expand -group TXFab-A -radix hexadecimal /main/DUT_A/U_The_DDS_Core/U_Tx_Path/U_Streamer/U_Fab_Source/cyc_int
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/rst_n_i
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/clk_sys_i
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/pcs_fab_i
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/pcs_error_o
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/pcs_busy_o
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/pcs_dreq_o
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/mdio_mcr_pdown_i
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/mdio_wr_spec_tx_cal_i
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/an_tx_en_i
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/an_tx_val_i
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/timestamp_trigger_p_a_o
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/rmon_o
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/phy_tx_clk_i
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/phy_tx_data_o
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/phy_tx_k_o
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/phy_tx_disparity_i
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/phy_tx_enc_err_i
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/tx_is_k
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/tx_catch_disparity
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/tx_odata_reg
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/tx_state
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/tx_cntr
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/tx_cr_alternate
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/fifo_packed_in
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/fifo_packed_out
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/fifo_empty
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/fifo_almost_empty
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/fifo_almost_full
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/fifo_enough_data
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/fifo_wr
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/fifo_rd
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/fifo_ready
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/fifo_clear_n
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/fifo_fab
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/tx_rdreq_toggle
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/tx_odd_length
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/tx_busy
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/tx_error
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/reset_synced_txclk
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/mdio_mcr_pdown_synced
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/an_tx_en_synced
add wave -noupdate -radix hexadecimal /main/DUT_A/U_WR_CORE/WRPC/U_Endpoint/U_Wrapped_Endpoint/U_PCS_1000BASEX/gen_8bit/U_TX_PCS/s_one
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {27552000000 fs} 0}
configure wave -namecolwidth 194
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
WaveRestoreZoom {0 fs} {210 us}

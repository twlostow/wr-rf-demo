---------------------------------------------------------------------------------------
-- Title          : Wishbone slave core for DDS RF distribution WB Slave
---------------------------------------------------------------------------------------
-- File           : dds_wb_slave.vhd
-- Author         : auto-generated by wbgen2 from dds_wb_slave.wb
-- Created        : Thu May 16 10:47:05 2013
-- Standard       : VHDL'87
---------------------------------------------------------------------------------------
-- THIS FILE WAS GENERATED BY wbgen2 FROM SOURCE FILE dds_wb_slave.wb
-- DO NOT HAND-EDIT UNLESS IT'S ABSOLUTELY NECESSARY!
---------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wbgen2_pkg.all;

use work.dds_wbgen2_pkg.all;


entity dds_wb_slave is
  port (
    rst_n_i                                  : in     std_logic;
    clk_sys_i                                : in     std_logic;
    wb_adr_i                                 : in     std_logic_vector(4 downto 0);
    wb_dat_i                                 : in     std_logic_vector(31 downto 0);
    wb_dat_o                                 : out    std_logic_vector(31 downto 0);
    wb_cyc_i                                 : in     std_logic;
    wb_sel_i                                 : in     std_logic_vector(3 downto 0);
    wb_stb_i                                 : in     std_logic;
    wb_we_i                                  : in     std_logic;
    wb_ack_o                                 : out    std_logic;
    wb_stall_o                               : out    std_logic;
    clk_ref_i                                : in     std_logic;
    regs_i                                   : in     t_dds_in_registers;
    regs_o                                   : out    t_dds_out_registers
  );
end dds_wb_slave;

architecture syn of dds_wb_slave is

signal dds_cr_test_int                          : std_logic      ;
signal dds_cr_slave_int                         : std_logic      ;
signal dds_cr_master_int                        : std_logic      ;
signal dds_cr_adc_bb_enable_dly0                : std_logic      ;
signal dds_cr_adc_bb_enable_int                 : std_logic      ;
signal dds_cr_clk_id_int                        : std_logic_vector(15 downto 0);
signal dds_gpior_pll_sys_cs_n_int               : std_logic      ;
signal dds_gpior_pll_sys_reset_n_int            : std_logic      ;
signal dds_gpior_pll_sclk_int                   : std_logic      ;
signal dds_gpior_pll_sdio_dir_int               : std_logic      ;
signal dds_gpior_pll_vcxo_reset_n_int           : std_logic      ;
signal dds_gpior_pll_vcxo_cs_n_int              : std_logic      ;
signal dds_gpior_pll_vcxo_function_int          : std_logic      ;
signal dds_gpior_adf_ce_int                     : std_logic      ;
signal dds_gpior_adf_clk_int                    : std_logic      ;
signal dds_gpior_adf_le_int                     : std_logic      ;
signal dds_gpior_adf_data_int                   : std_logic      ;
signal dds_gpior_adc_sdi_int                    : std_logic      ;
signal dds_gpior_adc_cnv_int                    : std_logic      ;
signal dds_gpior_adc_sck_int                    : std_logic      ;
signal dds_pd_fifo_rst_n                        : std_logic      ;
signal dds_pd_fifo_in_int                       : std_logic_vector(15 downto 0);
signal dds_pd_fifo_out_int                      : std_logic_vector(15 downto 0);
signal dds_pd_fifo_rdreq_int                    : std_logic      ;
signal dds_pd_fifo_rdreq_int_d0                 : std_logic      ;
signal dds_tune_fifo_rst_n                      : std_logic      ;
signal dds_tune_fifo_in_int                     : std_logic_vector(31 downto 0);
signal dds_tune_fifo_out_int                    : std_logic_vector(31 downto 0);
signal dds_tune_fifo_wrreq_int                  : std_logic      ;
signal dds_freq_hi_int                          : std_logic_vector(31 downto 0);
signal dds_freq_hi_swb                          : std_logic      ;
signal dds_freq_hi_swb_delay                    : std_logic      ;
signal dds_freq_hi_swb_s0                       : std_logic      ;
signal dds_freq_hi_swb_s1                       : std_logic      ;
signal dds_freq_hi_swb_s2                       : std_logic      ;
signal dds_freq_lo_int                          : std_logic_vector(31 downto 0);
signal dds_freq_lo_swb                          : std_logic      ;
signal dds_freq_lo_swb_delay                    : std_logic      ;
signal dds_freq_lo_swb_s0                       : std_logic      ;
signal dds_freq_lo_swb_s1                       : std_logic      ;
signal dds_freq_lo_swb_s2                       : std_logic      ;
signal dds_gain_int                             : std_logic_vector(15 downto 0);
signal dds_gain_swb                             : std_logic      ;
signal dds_gain_swb_delay                       : std_logic      ;
signal dds_gain_swb_s0                          : std_logic      ;
signal dds_gain_swb_s1                          : std_logic      ;
signal dds_gain_swb_s2                          : std_logic      ;
signal dds_rstr_pll_rst_int                     : std_logic      ;
signal dds_rstr_sw_rst_int                      : std_logic      ;
signal dds_i2cr_scl_out_int                     : std_logic      ;
signal dds_i2cr_sda_out_int                     : std_logic      ;
signal dds_pir_kp_int                           : std_logic_vector(15 downto 0);
signal dds_pir_ki_int                           : std_logic_vector(15 downto 0);
signal dds_dlyr_delay_int                       : std_logic_vector(15 downto 0);
signal dds_phaser_phase_int                     : std_logic_vector(15 downto 0);
signal dds_macl_macl_int                        : std_logic_vector(31 downto 0);
signal dds_mach_mach_int                        : std_logic_vector(15 downto 0);
signal dds_hit_cnt_hit_cnt_int                  : std_logic_vector(23 downto 0);
signal dds_hit_cnt_hit_cnt_lwb                  : std_logic      ;
signal dds_hit_cnt_hit_cnt_lwb_delay            : std_logic      ;
signal dds_hit_cnt_hit_cnt_lwb_in_progress      : std_logic      ;
signal dds_hit_cnt_hit_cnt_lwb_s0               : std_logic      ;
signal dds_hit_cnt_hit_cnt_lwb_s1               : std_logic      ;
signal dds_hit_cnt_hit_cnt_lwb_s2               : std_logic      ;
signal dds_miss_cnt_miss_cnt_int                : std_logic_vector(23 downto 0);
signal dds_miss_cnt_miss_cnt_lwb                : std_logic      ;
signal dds_miss_cnt_miss_cnt_lwb_delay          : std_logic      ;
signal dds_miss_cnt_miss_cnt_lwb_in_progress    : std_logic      ;
signal dds_miss_cnt_miss_cnt_lwb_s0             : std_logic      ;
signal dds_miss_cnt_miss_cnt_lwb_s1             : std_logic      ;
signal dds_miss_cnt_miss_cnt_lwb_s2             : std_logic      ;
signal dds_pd_fifo_full_int                     : std_logic      ;
signal dds_pd_fifo_empty_int                    : std_logic      ;
signal dds_tune_fifo_full_int                   : std_logic      ;
signal dds_tune_fifo_empty_int                  : std_logic      ;
signal ack_sreg                                 : std_logic_vector(9 downto 0);
signal rddata_reg                               : std_logic_vector(31 downto 0);
signal wrdata_reg                               : std_logic_vector(31 downto 0);
signal bwsel_reg                                : std_logic_vector(3 downto 0);
signal rwaddr_reg                               : std_logic_vector(4 downto 0);
signal ack_in_progress                          : std_logic      ;
signal wr_int                                   : std_logic      ;
signal rd_int                                   : std_logic      ;
signal allones                                  : std_logic_vector(31 downto 0);
signal allzeros                                 : std_logic_vector(31 downto 0);

begin
-- Some internal signals assignments. For (foreseen) compatibility with other bus standards.
  wrdata_reg <= wb_dat_i;
  bwsel_reg <= wb_sel_i;
  rd_int <= wb_cyc_i and (wb_stb_i and (not wb_we_i));
  wr_int <= wb_cyc_i and (wb_stb_i and wb_we_i);
  allones <= (others => '1');
  allzeros <= (others => '0');
-- 
-- Main register bank access process.
  process (clk_sys_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      ack_sreg <= "0000000000";
      ack_in_progress <= '0';
      rddata_reg <= "00000000000000000000000000000000";
      dds_cr_test_int <= '0';
      dds_cr_slave_int <= '0';
      dds_cr_master_int <= '0';
      dds_cr_adc_bb_enable_int <= '0';
      dds_cr_clk_id_int <= "0000000000000000";
      dds_gpior_pll_sys_cs_n_int <= '0';
      dds_gpior_pll_sys_reset_n_int <= '0';
      dds_gpior_pll_sclk_int <= '0';
      regs_o.gpior_pll_sdio_load_o <= '0';
      dds_gpior_pll_sdio_dir_int <= '0';
      dds_gpior_pll_vcxo_reset_n_int <= '0';
      dds_gpior_pll_vcxo_cs_n_int <= '0';
      dds_gpior_pll_vcxo_function_int <= '0';
      dds_gpior_adf_ce_int <= '0';
      dds_gpior_adf_clk_int <= '0';
      dds_gpior_adf_le_int <= '0';
      dds_gpior_adf_data_int <= '0';
      dds_gpior_adc_sdi_int <= '0';
      dds_gpior_adc_cnv_int <= '0';
      dds_gpior_adc_sck_int <= '0';
      dds_freq_hi_int <= "00000000000000000000000000000000";
      dds_freq_hi_swb <= '0';
      dds_freq_hi_swb_delay <= '0';
      dds_freq_lo_int <= "00000000000000000000000000000000";
      dds_freq_lo_swb <= '0';
      dds_freq_lo_swb_delay <= '0';
      dds_gain_int <= "0000000000000000";
      dds_gain_swb <= '0';
      dds_gain_swb_delay <= '0';
      dds_rstr_pll_rst_int <= '0';
      dds_rstr_sw_rst_int <= '0';
      dds_i2cr_scl_out_int <= '1';
      dds_i2cr_sda_out_int <= '1';
      dds_pir_kp_int <= "0000000000000000";
      dds_pir_ki_int <= "0000000000000000";
      dds_dlyr_delay_int <= "0000000000000000";
      dds_phaser_phase_int <= "0000000000000000";
      dds_macl_macl_int <= "00000000000000000000000000000000";
      dds_mach_mach_int <= "0000000000000000";
      dds_hit_cnt_hit_cnt_lwb <= '0';
      dds_hit_cnt_hit_cnt_lwb_delay <= '0';
      dds_hit_cnt_hit_cnt_lwb_in_progress <= '0';
      dds_miss_cnt_miss_cnt_lwb <= '0';
      dds_miss_cnt_miss_cnt_lwb_delay <= '0';
      dds_miss_cnt_miss_cnt_lwb_in_progress <= '0';
      dds_pd_fifo_rdreq_int <= '0';
      dds_tune_fifo_wrreq_int <= '0';
    elsif rising_edge(clk_sys_i) then
-- advance the ACK generator shift register
      ack_sreg(8 downto 0) <= ack_sreg(9 downto 1);
      ack_sreg(9) <= '0';
      if (ack_in_progress = '1') then
        if (ack_sreg(0) = '1') then
          dds_cr_adc_bb_enable_int <= '0';
          regs_o.gpior_pll_sdio_load_o <= '0';
          dds_tune_fifo_wrreq_int <= '0';
          ack_in_progress <= '0';
        else
          regs_o.gpior_pll_sdio_load_o <= '0';
          dds_freq_hi_swb <= dds_freq_hi_swb_delay;
          dds_freq_hi_swb_delay <= '0';
          dds_freq_lo_swb <= dds_freq_lo_swb_delay;
          dds_freq_lo_swb_delay <= '0';
          dds_gain_swb <= dds_gain_swb_delay;
          dds_gain_swb_delay <= '0';
          dds_hit_cnt_hit_cnt_lwb <= dds_hit_cnt_hit_cnt_lwb_delay;
          dds_hit_cnt_hit_cnt_lwb_delay <= '0';
          if ((ack_sreg(1) = '1') and (dds_hit_cnt_hit_cnt_lwb_in_progress = '1')) then
            rddata_reg(23 downto 0) <= dds_hit_cnt_hit_cnt_int;
            dds_hit_cnt_hit_cnt_lwb_in_progress <= '0';
          end if;
          dds_miss_cnt_miss_cnt_lwb <= dds_miss_cnt_miss_cnt_lwb_delay;
          dds_miss_cnt_miss_cnt_lwb_delay <= '0';
          if ((ack_sreg(1) = '1') and (dds_miss_cnt_miss_cnt_lwb_in_progress = '1')) then
            rddata_reg(23 downto 0) <= dds_miss_cnt_miss_cnt_int;
            dds_miss_cnt_miss_cnt_lwb_in_progress <= '0';
          end if;
        end if;
      else
        if ((wb_cyc_i = '1') and (wb_stb_i = '1')) then
          case rwaddr_reg(4 downto 0) is
          when "00000" => 
            if (wb_we_i = '1') then
              dds_cr_test_int <= wrdata_reg(0);
              dds_cr_slave_int <= wrdata_reg(1);
              dds_cr_master_int <= wrdata_reg(2);
              dds_cr_adc_bb_enable_int <= wrdata_reg(3);
              dds_cr_clk_id_int <= wrdata_reg(31 downto 16);
            end if;
            rddata_reg(0) <= dds_cr_test_int;
            rddata_reg(1) <= dds_cr_slave_int;
            rddata_reg(2) <= dds_cr_master_int;
            rddata_reg(3) <= '0';
            rddata_reg(4) <= regs_i.cr_wr_link_i;
            rddata_reg(5) <= regs_i.cr_wr_time_i;
            rddata_reg(31 downto 16) <= dds_cr_clk_id_int;
            rddata_reg(6) <= 'X';
            rddata_reg(7) <= 'X';
            rddata_reg(8) <= 'X';
            rddata_reg(9) <= 'X';
            rddata_reg(10) <= 'X';
            rddata_reg(11) <= 'X';
            rddata_reg(12) <= 'X';
            rddata_reg(13) <= 'X';
            rddata_reg(14) <= 'X';
            rddata_reg(15) <= 'X';
            ack_sreg(2) <= '1';
            ack_in_progress <= '1';
          when "00001" => 
            if (wb_we_i = '1') then
              dds_gpior_pll_sys_cs_n_int <= wrdata_reg(0);
              dds_gpior_pll_sys_reset_n_int <= wrdata_reg(1);
              dds_gpior_pll_sclk_int <= wrdata_reg(2);
              regs_o.gpior_pll_sdio_load_o <= '1';
              dds_gpior_pll_sdio_dir_int <= wrdata_reg(4);
              dds_gpior_pll_vcxo_reset_n_int <= wrdata_reg(5);
              dds_gpior_pll_vcxo_cs_n_int <= wrdata_reg(6);
              dds_gpior_pll_vcxo_function_int <= wrdata_reg(7);
              dds_gpior_adf_ce_int <= wrdata_reg(9);
              dds_gpior_adf_clk_int <= wrdata_reg(10);
              dds_gpior_adf_le_int <= wrdata_reg(11);
              dds_gpior_adf_data_int <= wrdata_reg(12);
              dds_gpior_adc_sdi_int <= wrdata_reg(13);
              dds_gpior_adc_cnv_int <= wrdata_reg(14);
              dds_gpior_adc_sck_int <= wrdata_reg(15);
            end if;
            rddata_reg(0) <= dds_gpior_pll_sys_cs_n_int;
            rddata_reg(1) <= dds_gpior_pll_sys_reset_n_int;
            rddata_reg(2) <= dds_gpior_pll_sclk_int;
            rddata_reg(3) <= regs_i.gpior_pll_sdio_i;
            rddata_reg(4) <= dds_gpior_pll_sdio_dir_int;
            rddata_reg(5) <= dds_gpior_pll_vcxo_reset_n_int;
            rddata_reg(6) <= dds_gpior_pll_vcxo_cs_n_int;
            rddata_reg(7) <= dds_gpior_pll_vcxo_function_int;
            rddata_reg(8) <= regs_i.gpior_pll_vcxo_sdo_i;
            rddata_reg(9) <= dds_gpior_adf_ce_int;
            rddata_reg(10) <= dds_gpior_adf_clk_int;
            rddata_reg(11) <= dds_gpior_adf_le_int;
            rddata_reg(12) <= dds_gpior_adf_data_int;
            rddata_reg(13) <= dds_gpior_adc_sdi_int;
            rddata_reg(14) <= dds_gpior_adc_cnv_int;
            rddata_reg(15) <= dds_gpior_adc_sck_int;
            rddata_reg(16) <= regs_i.gpior_adc_sdo_i;
            rddata_reg(17) <= 'X';
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "00010" => 
            if (wb_we_i = '1') then
              dds_freq_hi_int <= wrdata_reg(31 downto 0);
              dds_freq_hi_swb <= '1';
              dds_freq_hi_swb_delay <= '1';
            end if;
            rddata_reg(31 downto 0) <= dds_freq_hi_int;
            ack_sreg(3) <= '1';
            ack_in_progress <= '1';
          when "00011" => 
            if (wb_we_i = '1') then
              dds_freq_lo_int <= wrdata_reg(31 downto 0);
              dds_freq_lo_swb <= '1';
              dds_freq_lo_swb_delay <= '1';
            end if;
            rddata_reg(31 downto 0) <= dds_freq_lo_int;
            ack_sreg(3) <= '1';
            ack_in_progress <= '1';
          when "00100" => 
            if (wb_we_i = '1') then
              dds_gain_int <= wrdata_reg(15 downto 0);
              dds_gain_swb <= '1';
              dds_gain_swb_delay <= '1';
            end if;
            rddata_reg(15 downto 0) <= dds_gain_int;
            rddata_reg(16) <= 'X';
            rddata_reg(17) <= 'X';
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(3) <= '1';
            ack_in_progress <= '1';
          when "00101" => 
            if (wb_we_i = '1') then
              dds_rstr_pll_rst_int <= wrdata_reg(0);
              dds_rstr_sw_rst_int <= wrdata_reg(1);
            end if;
            rddata_reg(0) <= dds_rstr_pll_rst_int;
            rddata_reg(1) <= dds_rstr_sw_rst_int;
            rddata_reg(2) <= 'X';
            rddata_reg(3) <= 'X';
            rddata_reg(4) <= 'X';
            rddata_reg(5) <= 'X';
            rddata_reg(6) <= 'X';
            rddata_reg(7) <= 'X';
            rddata_reg(8) <= 'X';
            rddata_reg(9) <= 'X';
            rddata_reg(10) <= 'X';
            rddata_reg(11) <= 'X';
            rddata_reg(12) <= 'X';
            rddata_reg(13) <= 'X';
            rddata_reg(14) <= 'X';
            rddata_reg(15) <= 'X';
            rddata_reg(16) <= 'X';
            rddata_reg(17) <= 'X';
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "00110" => 
            if (wb_we_i = '1') then
              dds_i2cr_scl_out_int <= wrdata_reg(0);
              dds_i2cr_sda_out_int <= wrdata_reg(1);
            end if;
            rddata_reg(0) <= dds_i2cr_scl_out_int;
            rddata_reg(1) <= dds_i2cr_sda_out_int;
            rddata_reg(2) <= regs_i.i2cr_scl_in_i;
            rddata_reg(3) <= regs_i.i2cr_sda_in_i;
            rddata_reg(4) <= 'X';
            rddata_reg(5) <= 'X';
            rddata_reg(6) <= 'X';
            rddata_reg(7) <= 'X';
            rddata_reg(8) <= 'X';
            rddata_reg(9) <= 'X';
            rddata_reg(10) <= 'X';
            rddata_reg(11) <= 'X';
            rddata_reg(12) <= 'X';
            rddata_reg(13) <= 'X';
            rddata_reg(14) <= 'X';
            rddata_reg(15) <= 'X';
            rddata_reg(16) <= 'X';
            rddata_reg(17) <= 'X';
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "00111" => 
            if (wb_we_i = '1') then
              dds_pir_kp_int <= wrdata_reg(15 downto 0);
              dds_pir_ki_int <= wrdata_reg(31 downto 16);
            end if;
            rddata_reg(15 downto 0) <= dds_pir_kp_int;
            rddata_reg(31 downto 16) <= dds_pir_ki_int;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "01000" => 
            if (wb_we_i = '1') then
              dds_dlyr_delay_int <= wrdata_reg(15 downto 0);
            end if;
            rddata_reg(15 downto 0) <= dds_dlyr_delay_int;
            rddata_reg(16) <= 'X';
            rddata_reg(17) <= 'X';
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "01001" => 
            if (wb_we_i = '1') then
              dds_phaser_phase_int <= wrdata_reg(15 downto 0);
            end if;
            rddata_reg(15 downto 0) <= dds_phaser_phase_int;
            rddata_reg(16) <= 'X';
            rddata_reg(17) <= 'X';
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "01010" => 
            if (wb_we_i = '1') then
              dds_macl_macl_int <= wrdata_reg(31 downto 0);
            end if;
            rddata_reg(31 downto 0) <= dds_macl_macl_int;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "01011" => 
            if (wb_we_i = '1') then
              dds_mach_mach_int <= wrdata_reg(15 downto 0);
            end if;
            rddata_reg(15 downto 0) <= dds_mach_mach_int;
            rddata_reg(16) <= 'X';
            rddata_reg(17) <= 'X';
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "01100" => 
            if (wb_we_i = '1') then
            end if;
            if (wb_we_i = '0') then
              dds_hit_cnt_hit_cnt_lwb <= '1';
              dds_hit_cnt_hit_cnt_lwb_delay <= '1';
              dds_hit_cnt_hit_cnt_lwb_in_progress <= '1';
            end if;
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(5) <= '1';
            ack_in_progress <= '1';
          when "01101" => 
            if (wb_we_i = '1') then
            end if;
            if (wb_we_i = '0') then
              dds_miss_cnt_miss_cnt_lwb <= '1';
              dds_miss_cnt_miss_cnt_lwb_delay <= '1';
              dds_miss_cnt_miss_cnt_lwb_in_progress <= '1';
            end if;
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(5) <= '1';
            ack_in_progress <= '1';
          when "01110" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(23 downto 0) <= regs_i.rx_cnt_rx_cnt_i;
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "01111" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(23 downto 0) <= regs_i.tx_cnt_tx_cnt_i;
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "10000" => 
            if (wb_we_i = '1') then
            end if;
            if (dds_pd_fifo_rdreq_int_d0 = '0') then
              dds_pd_fifo_rdreq_int <= not dds_pd_fifo_rdreq_int;
            else
              rddata_reg(15 downto 0) <= dds_pd_fifo_out_int(15 downto 0);
              ack_in_progress <= '1';
              ack_sreg(0) <= '1';
            end if;
            rddata_reg(16) <= 'X';
            rddata_reg(17) <= 'X';
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
          when "10001" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(16) <= dds_pd_fifo_full_int;
            rddata_reg(17) <= dds_pd_fifo_empty_int;
            rddata_reg(0) <= 'X';
            rddata_reg(1) <= 'X';
            rddata_reg(2) <= 'X';
            rddata_reg(3) <= 'X';
            rddata_reg(4) <= 'X';
            rddata_reg(5) <= 'X';
            rddata_reg(6) <= 'X';
            rddata_reg(7) <= 'X';
            rddata_reg(8) <= 'X';
            rddata_reg(9) <= 'X';
            rddata_reg(10) <= 'X';
            rddata_reg(11) <= 'X';
            rddata_reg(12) <= 'X';
            rddata_reg(13) <= 'X';
            rddata_reg(14) <= 'X';
            rddata_reg(15) <= 'X';
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "10010" => 
            if (wb_we_i = '1') then
              dds_tune_fifo_in_int(31 downto 0) <= wrdata_reg(31 downto 0);
              dds_tune_fifo_wrreq_int <= '1';
            end if;
            rddata_reg(0) <= 'X';
            rddata_reg(1) <= 'X';
            rddata_reg(2) <= 'X';
            rddata_reg(3) <= 'X';
            rddata_reg(4) <= 'X';
            rddata_reg(5) <= 'X';
            rddata_reg(6) <= 'X';
            rddata_reg(7) <= 'X';
            rddata_reg(8) <= 'X';
            rddata_reg(9) <= 'X';
            rddata_reg(10) <= 'X';
            rddata_reg(11) <= 'X';
            rddata_reg(12) <= 'X';
            rddata_reg(13) <= 'X';
            rddata_reg(14) <= 'X';
            rddata_reg(15) <= 'X';
            rddata_reg(16) <= 'X';
            rddata_reg(17) <= 'X';
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "10011" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(16) <= dds_tune_fifo_full_int;
            rddata_reg(17) <= dds_tune_fifo_empty_int;
            rddata_reg(0) <= 'X';
            rddata_reg(1) <= 'X';
            rddata_reg(2) <= 'X';
            rddata_reg(3) <= 'X';
            rddata_reg(4) <= 'X';
            rddata_reg(5) <= 'X';
            rddata_reg(6) <= 'X';
            rddata_reg(7) <= 'X';
            rddata_reg(8) <= 'X';
            rddata_reg(9) <= 'X';
            rddata_reg(10) <= 'X';
            rddata_reg(11) <= 'X';
            rddata_reg(12) <= 'X';
            rddata_reg(13) <= 'X';
            rddata_reg(14) <= 'X';
            rddata_reg(15) <= 'X';
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when others =>
-- prevent the slave from hanging the bus on invalid address
            ack_in_progress <= '1';
            ack_sreg(0) <= '1';
          end case;
        end if;
      end if;
    end if;
  end process;
  
  
-- Drive the data output bus
  wb_dat_o <= rddata_reg;
-- Enable DDS test mode
  regs_o.cr_test_o <= dds_cr_test_int;
-- Enable DDS RF slave mode
  regs_o.cr_slave_o <= dds_cr_slave_int;
-- Enable DDS RF master mode
  regs_o.cr_master_o <= dds_cr_master_int;
-- ADC Bitbanged Access Enable
  process (clk_sys_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      dds_cr_adc_bb_enable_dly0 <= '0';
      regs_o.cr_adc_bb_enable_o <= '0';
    elsif rising_edge(clk_sys_i) then
      dds_cr_adc_bb_enable_dly0 <= dds_cr_adc_bb_enable_int;
      regs_o.cr_adc_bb_enable_o <= dds_cr_adc_bb_enable_int and (not dds_cr_adc_bb_enable_dly0);
    end if;
  end process;
  
  
-- WR Link status
-- WR Time status
-- Broadcast Clock ID
  regs_o.cr_clk_id_o <= dds_cr_clk_id_int;
-- System PLL CS
  regs_o.gpior_pll_sys_cs_n_o <= dds_gpior_pll_sys_cs_n_int;
-- System Reset
  regs_o.gpior_pll_sys_reset_n_o <= dds_gpior_pll_sys_reset_n_int;
-- PLL SCLK (shared)
  regs_o.gpior_pll_sclk_o <= dds_gpior_pll_sclk_int;
-- PLL SDIO (shared)
  regs_o.gpior_pll_sdio_o <= wrdata_reg(3);
-- PLL SDIO direction (shared)
  regs_o.gpior_pll_sdio_dir_o <= dds_gpior_pll_sdio_dir_int;
-- VCXO PLL Reset
  regs_o.gpior_pll_vcxo_reset_n_o <= dds_gpior_pll_vcxo_reset_n_int;
-- VCXO PLL Chip Select
  regs_o.gpior_pll_vcxo_cs_n_o <= dds_gpior_pll_vcxo_cs_n_int;
-- VCXO PLL Function
  regs_o.gpior_pll_vcxo_function_o <= dds_gpior_pll_vcxo_function_int;
-- VCXO PLL SDO
-- ADF4002 Chip Enable
  regs_o.gpior_adf_ce_o <= dds_gpior_adf_ce_int;
-- ADF4002 Clock
  regs_o.gpior_adf_clk_o <= dds_gpior_adf_clk_int;
-- ADF4002 Latch Enable
  regs_o.gpior_adf_le_o <= dds_gpior_adf_le_int;
-- ADF4002 Data
  regs_o.gpior_adf_data_o <= dds_gpior_adf_data_int;
-- AD7980 Bitbanged Data Out
  regs_o.gpior_adc_sdi_o <= dds_gpior_adc_sdi_int;
-- AD7980 Bitbanged Convert Strobe
  regs_o.gpior_adc_cnv_o <= dds_gpior_adc_cnv_int;
-- AD7980 Bitbanged Serial Clock
  regs_o.gpior_adc_sck_o <= dds_gpior_adc_sck_int;
-- AD7980 Bitbanged Data In
-- extra code for reg/fifo/mem: PD ADC Test FIFO (test mode)
  dds_pd_fifo_in_int(15 downto 0) <= regs_i.pd_fifo_data_i;
  dds_pd_fifo_rst_n <= rst_n_i;
  dds_pd_fifo_INST : wbgen2_fifo_async
    generic map (
      g_size               => 512,
      g_width              => 16,
      g_usedw_size         => 9
    )
    port map (
      wr_req_i             => regs_i.pd_fifo_wr_req_i,
      wr_full_o            => regs_o.pd_fifo_wr_full_o,
      wr_empty_o           => regs_o.pd_fifo_wr_empty_o,
      rd_full_o            => dds_pd_fifo_full_int,
      rd_empty_o           => dds_pd_fifo_empty_int,
      rd_req_i             => dds_pd_fifo_rdreq_int,
      rst_n_i              => dds_pd_fifo_rst_n,
      wr_clk_i             => clk_ref_i,
      rd_clk_i             => clk_sys_i,
      wr_data_i            => dds_pd_fifo_in_int,
      rd_data_o            => dds_pd_fifo_out_int
    );
  
-- extra code for reg/fifo/mem: DDS Tuning FIFO (test mode)
  regs_o.tune_fifo_data_o <= dds_tune_fifo_out_int(31 downto 0);
  dds_tune_fifo_rst_n <= rst_n_i;
  dds_tune_fifo_INST : wbgen2_fifo_async
    generic map (
      g_size               => 512,
      g_width              => 32,
      g_usedw_size         => 9
    )
    port map (
      rd_req_i             => regs_i.tune_fifo_rd_req_i,
      rd_empty_o           => regs_o.tune_fifo_rd_empty_o,
      wr_full_o            => dds_tune_fifo_full_int,
      wr_empty_o           => dds_tune_fifo_empty_int,
      wr_req_i             => dds_tune_fifo_wrreq_int,
      rst_n_i              => dds_tune_fifo_rst_n,
      rd_clk_i             => clk_ref_i,
      wr_clk_i             => clk_sys_i,
      wr_data_i            => dds_tune_fifo_in_int,
      rd_data_o            => dds_tune_fifo_out_int
    );
  
-- Center freq HI
-- asynchronous std_logic_vector register : Center freq HI (type RW/RO, clk_ref_i <-> clk_sys_i)
  process (clk_ref_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      dds_freq_hi_swb_s0 <= '0';
      dds_freq_hi_swb_s1 <= '0';
      dds_freq_hi_swb_s2 <= '0';
      regs_o.freq_hi_o <= "00000000000000000000000000000000";
    elsif rising_edge(clk_ref_i) then
      dds_freq_hi_swb_s0 <= dds_freq_hi_swb;
      dds_freq_hi_swb_s1 <= dds_freq_hi_swb_s0;
      dds_freq_hi_swb_s2 <= dds_freq_hi_swb_s1;
      if ((dds_freq_hi_swb_s2 = '0') and (dds_freq_hi_swb_s1 = '1')) then
        regs_o.freq_hi_o <= dds_freq_hi_int;
      end if;
    end if;
  end process;
  
  
-- Center freq LO
-- asynchronous std_logic_vector register : Center freq LO (type RW/RO, clk_ref_i <-> clk_sys_i)
  process (clk_ref_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      dds_freq_lo_swb_s0 <= '0';
      dds_freq_lo_swb_s1 <= '0';
      dds_freq_lo_swb_s2 <= '0';
      regs_o.freq_lo_o <= "00000000000000000000000000000000";
    elsif rising_edge(clk_ref_i) then
      dds_freq_lo_swb_s0 <= dds_freq_lo_swb;
      dds_freq_lo_swb_s1 <= dds_freq_lo_swb_s0;
      dds_freq_lo_swb_s2 <= dds_freq_lo_swb_s1;
      if ((dds_freq_lo_swb_s2 = '0') and (dds_freq_lo_swb_s1 = '1')) then
        regs_o.freq_lo_o <= dds_freq_lo_int;
      end if;
    end if;
  end process;
  
  
-- DDS gain (4.12 unsigned)
-- asynchronous std_logic_vector register : DDS gain (4.12 unsigned) (type RW/RO, clk_ref_i <-> clk_sys_i)
  process (clk_ref_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      dds_gain_swb_s0 <= '0';
      dds_gain_swb_s1 <= '0';
      dds_gain_swb_s2 <= '0';
      regs_o.gain_o <= "0000000000000000";
    elsif rising_edge(clk_ref_i) then
      dds_gain_swb_s0 <= dds_gain_swb;
      dds_gain_swb_s1 <= dds_gain_swb_s0;
      dds_gain_swb_s2 <= dds_gain_swb_s1;
      if ((dds_gain_swb_s2 = '0') and (dds_gain_swb_s1 = '1')) then
        regs_o.gain_o <= dds_gain_int;
      end if;
    end if;
  end process;
  
  
-- FPGA REF/Serdes PLL Reset
  regs_o.rstr_pll_rst_o <= dds_rstr_pll_rst_int;
-- FPGA DDS Logic software reset
  regs_o.rstr_sw_rst_o <= dds_rstr_sw_rst_int;
-- SCL Line out
  regs_o.i2cr_scl_out_o <= dds_i2cr_scl_out_int;
-- SDA Line out
  regs_o.i2cr_sda_out_o <= dds_i2cr_sda_out_int;
-- SCL Line in
-- SDA Line in
-- KP
  regs_o.pir_kp_o <= dds_pir_kp_int;
-- KI
  regs_o.pir_ki_o <= dds_pir_ki_int;
-- Delay
  regs_o.dlyr_delay_o <= dds_dlyr_delay_int;
-- PHASE
  regs_o.phaser_phase_o <= dds_phaser_phase_int;
-- MACL
  regs_o.macl_macl_o <= dds_macl_macl_int;
-- MACH
  regs_o.mach_mach_o <= dds_mach_mach_int;
-- HIT_CNT
-- asynchronous std_logic_vector register : HIT_CNT (type RO/WO, clk_ref_i <-> clk_sys_i)
  process (clk_ref_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      dds_hit_cnt_hit_cnt_lwb_s0 <= '0';
      dds_hit_cnt_hit_cnt_lwb_s1 <= '0';
      dds_hit_cnt_hit_cnt_lwb_s2 <= '0';
      dds_hit_cnt_hit_cnt_int <= "000000000000000000000000";
    elsif rising_edge(clk_ref_i) then
      dds_hit_cnt_hit_cnt_lwb_s0 <= dds_hit_cnt_hit_cnt_lwb;
      dds_hit_cnt_hit_cnt_lwb_s1 <= dds_hit_cnt_hit_cnt_lwb_s0;
      dds_hit_cnt_hit_cnt_lwb_s2 <= dds_hit_cnt_hit_cnt_lwb_s1;
      if ((dds_hit_cnt_hit_cnt_lwb_s1 = '1') and (dds_hit_cnt_hit_cnt_lwb_s2 = '0')) then
        dds_hit_cnt_hit_cnt_int <= regs_i.hit_cnt_hit_cnt_i;
      end if;
    end if;
  end process;
  
  
-- MISS_CNT
-- asynchronous std_logic_vector register : MISS_CNT (type RO/WO, clk_ref_i <-> clk_sys_i)
  process (clk_ref_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      dds_miss_cnt_miss_cnt_lwb_s0 <= '0';
      dds_miss_cnt_miss_cnt_lwb_s1 <= '0';
      dds_miss_cnt_miss_cnt_lwb_s2 <= '0';
      dds_miss_cnt_miss_cnt_int <= "000000000000000000000000";
    elsif rising_edge(clk_ref_i) then
      dds_miss_cnt_miss_cnt_lwb_s0 <= dds_miss_cnt_miss_cnt_lwb;
      dds_miss_cnt_miss_cnt_lwb_s1 <= dds_miss_cnt_miss_cnt_lwb_s0;
      dds_miss_cnt_miss_cnt_lwb_s2 <= dds_miss_cnt_miss_cnt_lwb_s1;
      if ((dds_miss_cnt_miss_cnt_lwb_s1 = '1') and (dds_miss_cnt_miss_cnt_lwb_s2 = '0')) then
        dds_miss_cnt_miss_cnt_int <= regs_i.miss_cnt_miss_cnt_i;
      end if;
    end if;
  end process;
  
  
-- RX_CNT
-- TX_CNT
-- extra code for reg/fifo/mem: FIFO 'PD ADC Test FIFO (test mode)' data output register 0
  process (clk_sys_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      dds_pd_fifo_rdreq_int_d0 <= '0';
    elsif rising_edge(clk_sys_i) then
      dds_pd_fifo_rdreq_int_d0 <= dds_pd_fifo_rdreq_int;
    end if;
  end process;
  
  
-- extra code for reg/fifo/mem: FIFO 'DDS Tuning FIFO (test mode)' data input register 0
  rwaddr_reg <= wb_adr_i;
  wb_stall_o <= (not ack_sreg(0)) and (wb_stb_i and wb_cyc_i);
-- ACK signal generation. Just pass the LSB of ACK counter.
  wb_ack_o <= ack_sreg(0);
end syn;

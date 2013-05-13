library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.wr_fabric_pkg.all;
use work.wishbone_pkg.all;
use work.dds_wbgen2_pkg.all;
use work.gencores_pkg.all;
use work.genram_pkg.all;
use work.streamers_pkg.all;


entity dds_core is
  
  port (

    -- Clocks & resets
    clk_sys_i : in std_logic;
    clk_dds_i : in std_logic;
    clk_ref_i : in std_logic;
    rst_n_i   : in std_logic;

    -- Timing (WRC)
    tm_link_up_i    : in std_logic := '1';
    tm_time_valid_i : in std_logic;
    tm_tai_i        : in std_logic_vector(39 downto 0);
    tm_cycles_i     : in std_logic_vector(27 downto 0);

    -- DDS Dac I/F (Maxim)
    dac_n_o    : out std_logic_vector(13 downto 0);
    dac_p_o    : out std_logic_vector(13 downto 0);
    dac_pwdn_o : out std_logic;

    -- AD9516 (SYS) and AD9510 (VCXO cleaner) PLL control
    clk_dds_locked_i : in std_logic;

    pll_vcxo_cs_n_o     : out std_logic;
    pll_vcxo_function_o : out std_logic;
    pll_vcxo_sdo_i      : in  std_logic;
    pll_vcxo_status_i   : in  std_logic;

    pll_sys_cs_n_o    : out std_logic;
    pll_sys_refmon_i  : in  std_logic;
    pll_sys_ld_i      : in  std_logic;
    pll_sys_reset_n_o : out std_logic;
    pll_sys_status_i  : in  std_logic;
    pll_sys_sync_n_o  : out std_logic;

    pll_sclk_o : out   std_logic;
    pll_sdio_b : inout std_logic;

    -- Phase Detector & ADC
    pd_ce_o      : out   std_logic;
    pd_lockdet_i : in    std_logic;
    pd_clk_o     : out   std_logic;
    pd_data_b    : inout std_logic;
    pd_le_o      : out   std_logic;

    adc_sdo_i : in  std_logic;
    adc_sck_o : out std_logic;
    adc_cnv_o : out std_logic;
    adc_sdi_o : out std_logic;

    si57x_oe_o  : out   std_logic;
    si57x_sda_b : inout std_logic;
    si57x_scl_b : inout std_logic;

    -- WB & WRF

    slave_i : in  t_wishbone_slave_in;
    slave_o : out t_wishbone_slave_out;

    src_i : in  t_wrf_source_in;
    src_o : out t_wrf_source_out;

    snk_i : in  t_wrf_sink_in;
    snk_o : out t_wrf_sink_out;

    swrst_o      : out std_logic;
    fpll_reset_o : out std_logic
    );

end dds_core;

architecture behavioral of dds_core is

  constant c_cnx_base_addr : t_wishbone_address_array(1 downto 0) :=
    (x"00000000",                       -- WB regs
     x"00004000"                        -- MDSP core
     );

  constant c_cnx_base_mask : t_wishbone_address_array(1 downto 0) :=
    (x"00004000",
     x"00004000");

  function resize(x : std_logic_vector; new_size : integer)
    return std_logic_vector is
    variable tmp : std_logic_vector(new_size-1 downto 0);
  begin
    
    if(new_size <= x'length) then
      tmp := x(new_size-1 downto 0);
    else
      tmp := std_logic_vector(to_unsigned(0, x'length-new_size)) & x;
    end if;

    return tmp;
  end function;

  component dds_wb_slave
    port (
      rst_n_i    : in  std_logic;
      clk_sys_i  : in  std_logic;
      wb_adr_i   : in  std_logic_vector(4 downto 0);
      wb_dat_i   : in  std_logic_vector(31 downto 0);
      wb_dat_o   : out std_logic_vector(31 downto 0);
      wb_cyc_i   : in  std_logic;
      wb_sel_i   : in  std_logic_vector(3 downto 0);
      wb_stb_i   : in  std_logic;
      wb_we_i    : in  std_logic;
      wb_ack_o   : out std_logic;
      wb_stall_o : out std_logic;
      clk_ref_i  : in  std_logic;
      regs_i     : in  t_dds_in_registers;
      regs_o     : out t_dds_out_registers);
  end component;

  component ad7980_if
    port (
      clk_i     : in  std_logic;
      rst_n_i   : in  std_logic;
      trig_i    : in  std_logic;
      d_o       : out std_logic_vector(15 downto 0);
      d_valid_o : out std_logic;
      adc_sdo_i : in  std_logic;
      adc_sck_o : out std_logic;
      adc_cnv_o : out std_logic;
      adc_sdi_o : out std_logic);
  end component;

  component max5870_serializer
    generic (
      sys_w : integer := 14;
      dev_w : integer := 56);
    port (
      DATA_OUT_FROM_DEVICE : in  std_logic_vector(dev_w-1 downto 0);
      DATA_OUT_TO_PINS_P   : out std_logic_vector(sys_w-1 downto 0);
      DATA_OUT_TO_PINS_N   : out std_logic_vector(sys_w-1 downto 0);
      CLK_IN               : in  std_logic;
      CLK_DIV_IN           : in  std_logic;
      LOCKED_IN            : in  std_logic;
      LOCKED_OUT           : out std_logic;
      CLK_RESET            : in  std_logic;
      IO_RESET             : in  std_logic);
  end component;

  component dds_quad_channel
    generic(
      g_acc_frac_bits : integer := 32;
      g_lut_size_log2 : integer := 10;
      g_output_bits   : integer := 14);
    port (
      clk_i       : in  std_logic;
      rst_n_i     : in  std_logic;
      acc_i       : in  std_logic_vector(g_lut_size_log2 + g_acc_frac_bits downto 0);
      acc_o       : out std_logic_vector(g_lut_size_log2 + g_acc_frac_bits downto 0);
      dreq_i      : in  std_logic;
      tune_i      : in  std_logic_vector(g_lut_size_log2 + g_acc_frac_bits downto 0);
      tune_load_i : in  std_logic;
      acc_load_i  : in  std_logic;

      y0_o : out std_logic_vector(g_output_bits-1 downto 0);
      y1_o : out std_logic_vector(g_output_bits-1 downto 0);
      y2_o : out std_logic_vector(g_output_bits-1 downto 0);
      y3_o : out std_logic_vector(g_output_bits-1 downto 0)
      );
  end component;

  component pi_control
    port(
      clk_i     : in  std_logic;
      rst_n_i   : in  std_logic;
      d_valid_i : in  std_logic;
      d_i       : in  std_logic_vector(15 downto 0);
      q_valid_o : out std_logic;
      q_o       : out std_logic_vector(15 downto 0);

      ki_i : in std_logic_vector(15 downto 0);
      kp_i : in std_logic_vector(15 downto 0)
      );
  end component;

  component dds_tx_path
    generic (
      g_acc_bits : integer := 43);
    port (
      clk_sys_i       : in  std_logic;
      clk_ref_i       : in  std_logic;
      rst_n_sys_i     : in  std_logic;
      rst_n_ref_i     : in  std_logic;
      tune_i          : in  std_logic_vector(17 downto 0);
      cic_ce_i        : in  std_logic;
      acc_i           : in  std_logic_vector(g_acc_bits-1 downto 0);
      src_i           : in  t_wrf_source_in;
      src_o           : out t_wrf_source_out;
      tm_time_valid_i : in  std_logic;
      tm_tai_i        : in  std_logic_vector(39 downto 0);
      tm_cycles_i     : in  std_logic_vector(27 downto 0);
      regs_i          : in  t_dds_out_registers;
      regs_o          : out t_dds_in_registers);
  end component;

  component dds_rx_path
    generic (
      g_acc_bits : integer);
    port (
      clk_sys_i       : in  std_logic;
      clk_ref_i       : in  std_logic;
      rst_n_sys_i     : in  std_logic;
      rst_n_ref_i     : in  std_logic;
      tune_o          : out std_logic_vector(17 downto 0);
      cic_reset_o     : out std_logic;
      acc_o           : out std_logic_vector(g_acc_bits-1 downto 0);
      acc_load_o      : out std_logic;
      snk_i           : in  t_wrf_sink_in;
      snk_o           : out t_wrf_sink_out;
      tm_time_valid_i : in  std_logic;
      tm_tai_i        : in  std_logic_vector(39 downto 0);
      tm_cycles_i     : in  std_logic_vector(27 downto 0);
      regs_i          : in  t_dds_out_registers;
      regs_o          : out t_dds_in_registers);
  end component;

  component cic_1024x
    port (
      clk_i    : in  std_logic;
      en_i     : in  std_logic;
      rst_i    : in  std_logic;
      x_i      : in  std_logic_vector(17 downto 0);
      y_o      : out std_logic_vector(77 downto 0);
      ce_out_o : out std_logic);
  end component;

  component mdsp
    port (
      clk_i : in std_logic;

      rst_n_i : in std_logic;

      x_req_o   : out std_logic;
      x_valid_i : in  std_logic;
      x_i       : in  std_logic_vector(23 downto 0);

      y_valid_o : out std_logic;
      y_req_i   : in  std_logic;
      y_o       : out std_logic_vector(23 downto 0);

      wb_cyc_i   : in  std_logic;
      wb_stb_i   : in  std_logic;
      wb_we_i    : in  std_logic;
      wb_adr_i   : in  std_logic_vector(31 downto 0);
      wb_dat_i   : in  std_logic_vector(31 downto 0);
      wb_dat_o   : out std_logic_vector(31 downto 0);
      wb_stall_o : out std_logic;
      wb_ack_o   : out std_logic
      );
  end component;

  signal dac_data_par : std_logic_vector(14 * 4 - 1 downto 0);

  signal cnx_out : t_wishbone_master_out_array(0 to 1);
  signal cnx_in  : t_wishbone_master_in_array(0 to 1);

  signal synth_tune, synth_tune_d0, synth_tune_d1, synth_tune_bias, synth_acc_in, synth_acc_out : std_logic_vector(42 downto 0);
  signal synth_tune_load, synth_acc_load                                                        : std_logic;
  signal synth_y0, synth_y1, synth_y2, synth_y3                                                 : std_logic_vector(13 downto 0);

  signal regs_in, regs_in_tx, regs_in_local, regs_in_rx : t_dds_in_registers;
  signal regs_out                           : t_dds_out_registers;

  signal swrst, swrst_n, rst_n_ref, rst_ref : std_logic;

  signal slave_cic_rst                     : std_logic;
  signal cic_out                           : std_logic_vector(77 downto 0);
  signal slave_tune, cic_in, cic_out_clamp : std_logic_vector(17 downto 0);
  signal cic_ce                            : std_logic;

  function f_signed_multiply(a : std_logic_vector; b : std_logic_vector; shift : integer; output_length : integer)
    return std_logic_vector is
    variable mul    : signed(a'length + b'length downto 0);
    variable result : std_logic_vector(output_length-1 downto 0);
  begin
    mul    := signed(a) * signed('0' & b);
    result := std_logic_vector(resize(mul(mul'length-1 downto shift), output_length));
    return result;
  end f_signed_multiply;


  signal tune_empty_d0 : std_logic;

  signal adc_data   : std_logic_vector(15 downto 0);
  signal adc_dvalid : std_logic;

  signal mdsp_out : std_logic_vector(23 downto 0);
  signal pi_out   : std_logic_vector(15 downto 0);
  signal mdsp_in  : std_logic_vector(23 downto 0);

  function f_sign_extend(x : std_logic_vector; output_length : integer) return std_logic_vector is
    variable tmp : std_logic_vector(output_length-1 downto 0);
  begin
    tmp(x'length-1 downto 0)             := x;
    tmp(output_length-1 downto x'length) := (others => x(x'length-1));
    return tmp;
  end f_sign_extend;

  
  
  
begin  -- behavioral

  U_Ref_Reset_SC : gc_sync_ffs
    port map (
      clk_i    => clk_ref_i,
      rst_n_i  => '1',
      data_i   => swrst_n,
      synced_o => rst_n_ref);

  U_Intercon : xwb_crossbar
    generic map (
      g_num_masters => 1,
      g_num_slaves  => 2,
      g_registered  => true,
      g_address     => c_cnx_base_addr,
      g_mask        => c_cnx_base_mask)
    port map (
      clk_sys_i  => clk_sys_i,
      rst_n_i    => rst_n_i,
      slave_i(0) => slave_i,
      slave_o(0) => slave_o,
      master_i   => cnx_in,
      master_o   => cnx_out);

  U_WB_Slave : dds_wb_slave
    port map (
      rst_n_i    => rst_n_i,
      clk_sys_i  => clk_sys_i,
      wb_adr_i   => cnx_out(0).adr(6 downto 2),
      wb_dat_i   => cnx_out(0).dat,
      wb_dat_o   => cnx_in(0).dat,
      wb_cyc_i   => cnx_out(0).cyc,
      wb_sel_i   => cnx_out(0).sel,
      wb_stb_i   => cnx_out(0).stb,
      wb_we_i    => cnx_out(0).we,
      wb_ack_o   => cnx_in(0).ack,
      wb_stall_o => cnx_in(0).stall,
      clk_ref_i  => clk_ref_i,
      regs_i     => regs_in,
      regs_o     => regs_out);

  U_ADC_Interface : ad7980_if
    port map (
      clk_i     => clk_ref_i,
      rst_n_i   => rst_n_ref,
      trig_i    => cic_ce,
      d_o       => adc_data,
      d_valid_o => adc_dvalid,
      adc_sdo_i => adc_sdo_i,
      adc_sck_o => adc_sck_o,
      adc_cnv_o => adc_cnv_o,
      adc_sdi_o => adc_sdi_o);


  regs_in <= regs_in_local or regs_in_rx or regs_in_tx;

  regs_in_local.pd_fifo_data_i   <= adc_data;
  regs_in_local.pd_fifo_wr_req_i <= adc_dvalid and not regs_out.pd_fifo_wr_full_o;

  dac_pwdn_o <= '1';

  U_DAC_Serializer : max5870_serializer
    port map (
      DATA_OUT_FROM_DEVICE => dac_data_par,
      DATA_OUT_TO_PINS_P   => dac_p_o,
      DATA_OUT_TO_PINS_N   => dac_n_o,
      CLK_IN               => clk_dds_i,
      CLK_DIV_IN           => clk_ref_i,
      LOCKED_IN            => clk_dds_locked_i,
      LOCKED_OUT           => open,
      CLK_RESET            => rst_ref,
      IO_RESET             => rst_ref);


  U_DDS_Synthesizer : dds_quad_channel
    generic map (
      g_acc_frac_bits => 32,
      g_lut_size_log2 => 10,
      g_output_bits   => 14)
    port map (
      clk_i       => clk_ref_i,
      rst_n_i     => rst_n_ref,
      acc_i       => synth_acc_in,
      acc_o       => synth_acc_out,
      dreq_i      => '1',
      tune_i      => synth_tune_d1,
      tune_load_i => synth_tune_load,
      acc_load_i  => synth_acc_load,
      y0_o        => synth_y0,
      y1_o        => synth_y1,
      y2_o        => synth_y2,
      y3_o        => synth_y3);

  
  U_Cic : cic_1024x
    port map (
      clk_i    => clk_ref_i,
      en_i     => '1',
      rst_i    => slave_cic_rst,
      x_i      => cic_in,
      y_o      => cic_out,
      ce_out_o => cic_ce);


  pi_control_1 : pi_control
    port map (
      clk_i     => clk_ref_i,
      rst_n_i   => rst_n_ref,
      d_valid_i => adc_dvalid,
      d_i       => adc_data,
      q_valid_o => open,
      q_o       => pi_out,
      ki_i      => regs_out.pir_ki_o,
      kp_i      => regs_out.pir_kp_o);


  U_Tx_Path : dds_tx_path
    generic map (
      g_acc_bits => 43)
    port map (
      clk_sys_i       => clk_sys_i,
      clk_ref_i       => clk_ref_i,
      rst_n_sys_i     => rst_n_i,
      rst_n_ref_i     => rst_n_ref,
      tune_i          => cic_in,
      cic_ce_i        => cic_ce,
      acc_i           => synth_acc_out,
      src_i           => src_i,
      src_o           => src_o,
      tm_time_valid_i => tm_time_valid_i,
      tm_tai_i        => tm_tai_i,
      tm_cycles_i     => tm_cycles_i,
      regs_i          => regs_out,
      regs_o => regs_in_tx);

  U_Rx_path : dds_rx_path
    generic map (
      g_acc_bits => 43)
    port map (
      clk_sys_i       => clk_sys_i,
      clk_ref_i       => clk_ref_i,
      rst_n_sys_i     => rst_n_i,
      rst_n_ref_i     => rst_n_ref,
      tune_o          => slave_tune,
      cic_reset_o     => slave_cic_rst,
      acc_o           => synth_acc_in,
      acc_load_o      => synth_acc_load,
      snk_i           => snk_i,
      snk_o           => snk_o,
      tm_time_valid_i => tm_time_valid_i,
      tm_tai_i        => tm_tai_i,
      tm_cycles_i     => tm_cycles_i,
      regs_i          => regs_out,
      regs_o          => regs_in_rx);

  cic_out_clamp <= cic_out(cic_out'length-1 downto cic_out'length - cic_out_clamp'length);

  p_choose_tune_source : process(regs_out, pi_out, slave_tune)
  begin
    --if(regs_out.cr_test_o = '1') then
--        cic_in <= regs_out.tune_fifo_data_o(17 downto 0);
    if(regs_out.cr_master_o = '1') then
      cic_in <= pi_out(15) & pi_out(15) & pi_out;
    elsif(regs_out.cr_slave_o = '1') then
      cic_in <= slave_tune;
    else
      cic_in <= (others => '0');
    end if;
  end process;

  regs_in_local.tune_fifo_rd_req_i <= not regs_out.tune_fifo_rd_empty_o and cic_ce;

  process(clk_ref_i)
  begin
    if rising_edge(clk_ref_i) then
      if rst_n_i = '0' then
        tune_empty_d0 <= '1';
      elsif(cic_ce = '1') then
        tune_empty_d0 <= regs_out.tune_fifo_rd_empty_o;
      end if;
    end if;
  end process;

  p_gen_tune : process(clk_ref_i)
  begin
    if rising_edge(clk_ref_i) then
      if(rst_n_ref = '0') then
        synth_tune      <= (others => '0');
        synth_tune_d0   <= (others => '0');
        synth_tune_d1   <= (others => '0');
        synth_tune_bias <= (others => '0');
        synth_tune_load <= '0';
      else
        
        synth_tune_bias(31 downto 0)  <= regs_out.freq_lo_o;
        synth_tune_bias(42 downto 32) <= regs_out.freq_hi_o(10 downto 0);

        synth_tune    <= std_logic_vector(unsigned(synth_tune_bias) + unsigned(f_signed_multiply(cic_out_clamp, regs_out.gain_o, 0, synth_tune_bias'length)));
        synth_tune_d0 <= synth_tune;
        synth_tune_d1 <= synth_tune_d0;

        synth_tune_load <= '1';
--        synth_acc_load  <= '0';
        dac_data_par    <= synth_y3 & synth_y2 & synth_y1 & synth_y0;
      end if;
    end if;
  end process;



  swrst        <= regs_out.rstr_sw_rst_o or (not rst_n_i);
  swrst_o      <= swrst;
  swrst_n      <= not swrst;
  fpll_reset_o <= regs_out.rstr_pll_rst_o or (not rst_n_i);
  rst_ref      <= not rst_n_ref;


  pll_vcxo_cs_n_o     <= regs_out.gpior_pll_vcxo_cs_n_o;
  pll_vcxo_function_o <= regs_out.gpior_pll_vcxo_function_o;

  regs_in_local.gpior_pll_vcxo_sdo_i <= pll_vcxo_sdo_i;

  pll_sys_cs_n_o    <= regs_out.gpior_pll_sys_cs_n_o;
  pll_sys_reset_n_o <= regs_out.gpior_pll_sys_reset_n_o;
  pll_sys_sync_n_o  <= '1';

  pll_sclk_o <= regs_out.gpior_pll_sclk_o;

  process(clk_sys_i)
  begin
    if rising_edge(clk_sys_i) then
      if regs_out.gpior_pll_sdio_load_o = '1' then
        pll_sdio_b <= regs_out.gpior_pll_sdio_o;
      end if;
    end if;
  end process;

  regs_in_local.gpior_pll_sdio_i <= pll_vcxo_sdo_i;

  pd_ce_o   <= regs_out.gpior_adf_ce_o;
  pd_clk_o  <= regs_out.gpior_adf_clk_o;
  pd_data_b <= regs_out.gpior_adf_data_o;
  pd_le_o   <= regs_out.gpior_adf_le_o;

--  regs_in.gpior_adc_sdo_i <= adc_sdo_i;
--  adc_sck_o               <= regs_out.gpior_adc_sck_o;
--  adc_cnv_o               <= regs_out.gpior_adc_cnv_o;
--  adc_sdi_o               <= regs_out.gpior_adc_sdi_o;

  si57x_oe_o                  <= '1';
  si57x_scl_b                 <= '0' when (regs_out.i2cr_scl_out_o = '0') else 'Z';
  si57x_sda_b                 <= '0' when (regs_out.i2cr_sda_out_o = '0') else 'Z';
  regs_in_local.i2cr_scl_in_i <= si57x_scl_b;
  regs_in_local.i2cr_sda_in_i <= si57x_sda_b;

  regs_in_local.cr_wr_time_i <= tm_time_valid_i;
  regs_in_local.cr_wr_link_i <= tm_link_up_i;
  
end behavioral;

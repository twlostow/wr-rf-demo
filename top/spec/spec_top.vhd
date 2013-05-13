library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

use work.gn4124_core_pkg.all;
use work.gencores_pkg.all;
use work.wrcore_pkg.all;
use work.wr_fabric_pkg.all;
use work.wishbone_pkg.all;
use work.wrcore_pkg.all;
use work.wr_xilinx_pkg.all;

library unisim;
use unisim.vcomponents.all;

entity spec_top is
  generic
    (
      g_simulation    : integer := 0;
      g_bypass_wrcore : integer := 0
      );

  port
    (
      -------------------------------------------------------------------------
      -- Standard SPEC ports (Gennum bridge, LEDS, Etc. Do not modify
      -------------------------------------------------------------------------

      clk_20m_vcxo_i : in std_logic;    -- 20MHz VCXO clock

      --clk_125m_pllref_p_i : in std_logic;  -- 125 MHz PLL reference
      --clk_125m_pllref_n_i : in std_logic;

      --clk_125m_gtp_n_i : in std_logic;  -- 125 MHz GTP reference
      --clk_125m_gtp_p_i : in std_logic;

      l_rst_n : in std_logic;           -- reset from gn4124 (rstout18_n)

      -- general purpose interface
      gpio       : inout std_logic_vector(1 downto 0);  -- gpio[0] -> gn4124 gpio8
                                        -- gpio[1] -> gn4124 gpio9
      -- pcie to local [inbound data] - rx
      p2l_rdy    : out   std_logic;     -- rx buffer full flag
      p2l_clkn   : in    std_logic;     -- receiver source synchronous clock-
      p2l_clkp   : in    std_logic;     -- receiver source synchronous clock+
      p2l_data   : in    std_logic_vector(15 downto 0);  -- parallel receive data
      p2l_dframe : in    std_logic;     -- receive frame
      p2l_valid  : in    std_logic;     -- receive data valid

      -- inbound buffer request/status
      p_wr_req : in  std_logic_vector(1 downto 0);  -- pcie write request
      p_wr_rdy : out std_logic_vector(1 downto 0);  -- pcie write ready
      rx_error : out std_logic;                     -- receive error

      -- local to parallel [outbound data] - tx
      l2p_data   : out std_logic_vector(15 downto 0);  -- parallel transmit data
      l2p_dframe : out std_logic;       -- transmit data frame
      l2p_valid  : out std_logic;       -- transmit data valid
      l2p_clkn   : out std_logic;  -- transmitter source synchronous clock-
      l2p_clkp   : out std_logic;  -- transmitter source synchronous clock+
      l2p_edb    : out std_logic;       -- packet termination and discard

      -- outbound buffer status
      l2p_rdy    : in std_logic;        -- tx buffer full flag
      l_wr_rdy   : in std_logic_vector(1 downto 0);  -- local-to-pcie write
      p_rd_d_rdy : in std_logic_vector(1 downto 0);  -- pcie-to-local read response data ready
      tx_error   : in std_logic;        -- transmit error
      vc_rdy     : in std_logic_vector(1 downto 0);  -- channel ready


      -- font panel leds
      led_red   : out std_logic;
      led_green : out std_logic;

      dac_sclk_o  : out std_logic;
      dac_din_o   : out std_logic;
      --dac_clr_n_o : out std_logic;
      dac_cs1_n_o : out std_logic;
      dac_cs2_n_o : out std_logic;

      button1_i : in std_logic := '1';
      button2_i : in std_logic := '1';

      fmc_scl_b : inout std_logic := '1';
      fmc_sda_b : inout std_logic := '1';

      carrier_onewire_b : inout std_logic := '1';
      fmc_prsnt_m2c_l_i : in    std_logic;

      -------------------------------------------------------------------------
      -- SFP pins
      -------------------------------------------------------------------------

      sfp_txp_o : out std_logic;
      sfp_txn_o : out std_logic;

      sfp_rxp_i : in std_logic := '0';
      sfp_rxn_i : in std_logic := '1';

      sfp_mod_def0_b    : in    std_logic;  -- detect pin
      sfp_mod_def1_b    : inout std_logic;  -- scl
      sfp_mod_def2_b    : inout std_logic;  -- sda
      sfp_rate_select_b : inout std_logic := '0';
      sfp_tx_fault_i    : in    std_logic := '0';
      sfp_tx_disable_o  : out   std_logic;
      sfp_los_i         : in    std_logic := '0';

      -- DDS Dac I/F (Maxim)
      dds_dac_n_o    : out std_logic_vector(13 downto 0);
      dds_dac_p_o    : out std_logic_vector(13 downto 0);
      dds_dac_pwdn_o : out std_logic;

      -- AD9516 (SYS) and AD9510 (VCXO cleaner) PLL control

      dds_pll_vcxo_cs_n_o     : out std_logic;
      dds_pll_vcxo_function_o : out std_logic;
      dds_pll_vcxo_sdo_i      : in  std_logic;
      dds_pll_vcxo_status_i   : in  std_logic;

      dds_pll_sys_cs_n_o    : out std_logic;
      dds_pll_sys_refmon_i  : in  std_logic;
      dds_pll_sys_ld_i      : in  std_logic;
      dds_pll_sys_reset_n_o : out std_logic;
      dds_pll_sys_status_i  : in  std_logic;
      dds_pll_sys_sync_n_o  : out std_logic;

      dds_pll_sclk_o : out   std_logic;
      dds_pll_sdio_b : inout std_logic;

      -- WR refernce clock & VCO control

      dds_wr_ref_clk_p_i : in std_logic;
      dds_wr_ref_clk_n_i : in std_logic;

      dds_wr_dac_sclk_o   : out std_logic;
      dds_wr_dac_din_o    : out std_logic;
      dds_wr_dac_sync_n_o : out std_logic;

      -- Phase Detector & its ADC

      dds_pd_ce_o      : out   std_logic;
      dds_pd_lockdet_i : in    std_logic;
      dds_pd_clk_o     : out   std_logic;
      dds_pd_data_b    : inout std_logic;
      dds_pd_le_o      : out   std_logic;

      dds_adc_sdo_i : in  std_logic;
      dds_adc_sck_o : out std_logic;
      dds_adc_cnv_o : out std_logic;
      dds_adc_sdi_o : out std_logic;

      -- Silabs clock gen control

      dds_si57x_oe_o  : out   std_logic;
      dds_si57x_sda_b : inout std_logic;
      dds_si57x_scl_b : inout std_logic;

      -- GPIO, misc stuff

      dds_onewire_b      : inout std_logic;
      dds_trig_term_en_o : out   std_logic;
      dds_trig_dir_o     : out   std_logic;
      dds_trig_act_o     : out   std_logic;

-----------------------------------------
      -- UART
      -----------------------------------------

      uart_rxd_i : in  std_logic := '1';
      uart_txd_o : out std_logic
      );

end spec_top;

architecture rtl of spec_top is
  constant c_NUM_WB_MASTERS : integer := 2;
  constant c_NUM_WB_SLAVES  : integer := 2;

  constant c_MASTER_GENNUM    : integer := 0;
  constant c_MASTER_ETHERBONE : integer := 1;

  constant c_SLAVE_DDS_CORE : integer := 0;
  constant c_SLAVE_WRCORE   : integer := 1;

  constant c_WRCORE_BRIDGE_SDB : t_sdb_bridge := f_xwb_bridge_manual_sdb(x"0003ffff", x"00030000");
  constant c_DDS_BRIDGE_SDB    : t_sdb_bridge := f_xwb_bridge_manual_sdb(x"0000ffff", x"0000c000");

  constant c_INTERCONNECT_LAYOUT : t_sdb_record_array(c_NUM_WB_MASTERS-1 downto 0) :=
    (c_SLAVE_WRCORE   => f_sdb_embed_bridge(c_WRCORE_BRIDGE_SDB, x"000c0000"),
     c_SLAVE_DDS_CORE => f_sdb_embed_bridge(c_DDS_BRIDGE_SDB, x"00080000"));

  constant c_SDB_ADDRESS : t_wishbone_address := x"00000000";

  component spec_reset_gen
    port (
      clk_sys_i        : in  std_logic;
      rst_pcie_n_a_i   : in  std_logic;
      rst_button_n_a_i : in  std_logic;
      rst_n_o          : out std_logic);
  end component;

  function f_pick(cond : boolean; if_true : string; if_false : string) return string is
  begin
    if(cond) then
      return if_true;
    else
      return if_false;
    end if;
  end f_pick;

  component pll_init
    generic(
      g_simulation : integer);
    port (
      clk_i   : in  std_logic;
      rst_n_i : in  std_logic;
      done_o  : out std_logic;
      cs_n_o  : out std_logic;
      mosi_o  : out std_logic;
      sck_o   : out std_logic);
  end component;



  component spec_serial_dac_arb
    generic(
      g_invert_sclk    : boolean;
      g_num_extra_bits : integer);
    port (
      clk_i       : in  std_logic;
      rst_n_i     : in  std_logic;
      val1_i      : in  std_logic_vector(15 downto 0);
      load1_i     : in  std_logic;
      val2_i      : in  std_logic_vector(15 downto 0);
      load2_i     : in  std_logic;
      dac_cs_n_o  : out std_logic_vector(1 downto 0);
      dac_clr_n_o : out std_logic;
      dac_sclk_o  : out std_logic;
      dac_din_o   : out std_logic);
  end component;


  signal clk_125m_pllref                                                 : std_logic;
  signal clk_dmtd, clk_dds, clk_ref, clk_sys                             : std_logic;
  signal pllout_clk_dmtd, pllout_clk_dds, pllout_clk_ref, pllout_clk_sys : std_logic;
  signal clk_20m_vcxo_buf                                                : std_logic;

  signal gn_wb_adr : std_logic_vector(31 downto 0);

--  alias clk_sys is clk_dmtd;


  signal local_reset_n                     : std_logic;
  signal fpll_locked, pllout_clk_fb_pllref : std_logic;

  signal swrst, swrst_n, fpll_reset : std_logic;

  signal cnx_master_out : t_wishbone_master_out_array(c_NUM_WB_MASTERS-1 downto 0);
  signal cnx_master_in  : t_wishbone_master_in_array(c_NUM_WB_MASTERS-1 downto 0);

  signal cnx_slave_out      : t_wishbone_slave_out_array(c_NUM_WB_SLAVES-1 downto 0);
  signal cnx_slave_in       : t_wishbone_slave_in_array(c_NUM_WB_SLAVES-1 downto 0);
  signal pllout_clk_fb_dmtd : std_logic;

  signal dac_cs1_n, dac_sclk, dac_din : std_logic;

  signal dac_hpll_load_p1 : std_logic;
  signal dac_dpll_load_p1 : std_logic;
  signal dac_hpll_data    : std_logic_vector(15 downto 0);
  signal dac_dpll_data    : std_logic_vector(15 downto 0);

  signal phy_tx_data                                      : std_logic_vector(7 downto 0);
  signal phy_tx_k                                         : std_logic;
  signal phy_tx_disparity                                 : std_logic;
  signal phy_tx_enc_err                                   : std_logic;
  signal phy_rx_data                                      : std_logic_vector(7 downto 0);
  signal phy_rx_rbclk                                     : std_logic;
  signal phy_rx_k                                         : std_logic;
  signal phy_rx_enc_err                                   : std_logic;
  signal phy_rx_bitslide                                  : std_logic_vector(3 downto 0);
  signal phy_rst                                          : std_logic;
  signal phy_loopen                                       : std_logic;
  signal wrc_scl_out, wrc_scl_in, wrc_sda_out, wrc_sda_in : std_logic;
  signal fd_scl_out, fd_scl_in, fd_sda_out, fd_sda_in     : std_logic;
  signal sfp_scl_out, sfp_scl_in, sfp_sda_out, sfp_sda_in : std_logic;
  signal wrc_owr_en, wrc_owr_in                           : std_logic_vector(1 downto 0);
  signal fd_owr_en, fd_owr_in                             : std_logic;
  signal pps                                              : std_logic;

  signal tm_link_up         : std_logic;
  signal tm_utc             : std_logic_vector(39 downto 0);
  signal tm_cycles          : std_logic_vector(27 downto 0);
  signal tm_time_valid      : std_logic;
  signal tm_clk_aux_lock_en : std_logic;
  signal tm_clk_aux_locked  : std_logic;
  signal tm_dac_value       : std_logic_vector(23 downto 0);
  signal tm_dac_wr          : std_logic;


  component dds_core
    port (
      clk_sys_i           : in    std_logic;
      clk_dds_i           : in    std_logic;
      clk_ref_i           : in    std_logic;
      rst_n_i             : in    std_logic;
      tm_link_up_i        : in    std_logic;
      tm_time_valid_i     : in    std_logic;
      tm_tai_i            : in    std_logic_vector(39 downto 0);
      tm_cycles_i         : in    std_logic_vector(27 downto 0);
      dac_n_o             : out   std_logic_vector(13 downto 0);
      dac_p_o             : out   std_logic_vector(13 downto 0);
      dac_pwdn_o          : out   std_logic;
      clk_dds_locked_i    : in    std_logic;
      pll_vcxo_cs_n_o     : out   std_logic;
      pll_vcxo_function_o : out   std_logic;
      pll_vcxo_sdo_i      : in    std_logic;
      pll_vcxo_status_i   : in    std_logic;
      pll_sys_cs_n_o      : out   std_logic;
      pll_sys_refmon_i    : in    std_logic;
      pll_sys_ld_i        : in    std_logic;
      pll_sys_reset_n_o   : out   std_logic;
      pll_sys_status_i    : in    std_logic;
      pll_sys_sync_n_o    : out   std_logic;
      pll_sclk_o          : out   std_logic;
      pll_sdio_b          : inout std_logic;
      pd_ce_o             : out   std_logic;
      pd_lockdet_i        : in    std_logic;
      pd_clk_o            : out   std_logic;
      pd_data_b           : inout std_logic;
      pd_le_o             : out   std_logic;
      adc_sdo_i           : in    std_logic;
      adc_sck_o           : out   std_logic;
      adc_cnv_o           : out   std_logic;
      adc_sdi_o           : out   std_logic;
      si57x_oe_o          : out   std_logic;
      si57x_sda_b         : inout std_logic;
      si57x_scl_b         : inout std_logic;
      slave_i             : in    t_wishbone_slave_in;
      slave_o             : out   t_wishbone_slave_out;
      src_i               : in    t_wrf_source_in;
      src_o               : out   t_wrf_source_out;
      snk_i               : in    t_wrf_sink_in;
      snk_o               : out   t_wrf_sink_out;
      swrst_o             : out   std_logic;
      fpll_reset_o        : out   std_logic);
  end component;

  signal wrc_snk_out : t_wrf_sink_out;
  signal wrc_snk_in  : t_wrf_sink_in;
  signal wrc_src_out : t_wrf_source_out;
  signal wrc_src_in  : t_wrf_source_in;

  signal wrc_true_snk_out : t_wrf_sink_out;
  signal wrc_true_snk_in  : t_wrf_sink_in;
  signal wrc_true_src_out : t_wrf_source_out;
  signal wrc_true_src_in  : t_wrf_source_in;

  signal wrc_snk_in_cyc, wrc_src_out_cyc : std_logic;
  signal wrc_snk_in_stb, wrc_src_out_stb : std_logic;
  signal wrc_snk_in_we, wrc_src_out_we   : std_logic;
  signal wrc_snk_in_adr, wrc_src_out_adr : std_logic_vector(1 downto 0);
  signal wrc_snk_in_sel, wrc_src_out_sel : std_logic_vector(1 downto 0);
  signal wrc_snk_in_dat, wrc_src_out_dat : std_logic_vector(15 downto 0);

  signal wrc_snk_out_stall, wrc_src_in_stall : std_logic;
  signal wrc_snk_out_err, wrc_src_in_err     : std_logic;
  signal wrc_snk_out_rty, wrc_src_in_rty     : std_logic;
  signal wrc_snk_out_ack, wrc_src_in_ack     : std_logic;


  signal pll_init_done, pll_init_done_sys, spec_reset_n : std_logic;

  signal reset_delay_cnt : unsigned(7 downto 0);
  
begin  -- rtl

  U_Buf_CLK_PLL : IBUFGDS
    generic map (
      DIFF_TERM    => true,
      IBUF_LOW_PWR => false  -- Low power (TRUE) vs. performance (FALSE) setting for referenced
      )
    port map (
      O  => clk_125m_pllref,            -- Buffer output
      I  => dds_wr_ref_clk_p_i,  -- Diff_p buffer input (connect directly to top-level port)
      IB => dds_wr_ref_clk_n_i  -- Diff_n buffer input (connect directly to top-level port)
      );

  
  U_Reset_Generator : spec_reset_gen
    port map (
      clk_sys_i        => clk_dmtd,
      rst_pcie_n_a_i   => l_rst_n,
      rst_button_n_a_i => button1_i,
      rst_n_o          => spec_reset_n);

  U_AD9516_bootstrap : pll_init
    generic map (
      g_simulation => g_simulation)
    port map (
      clk_i   => clk_dmtd,
      rst_n_i => spec_reset_n,
      done_o  => pll_init_done,
      cs_n_o  => dds_pll_sys_cs_n_o,
      mosi_o  => dds_pll_sdio_b,
      sck_o   => dds_pll_sclk_o);

  dds_pll_sys_reset_n_o <= '1';
  dds_pll_sys_sync_n_o  <= '1';

  fpll_reset <= not pll_init_done;

  p_gen_reset : process(clk_sys, fpll_locked)
  begin
    if fpll_locked = '0' then
      reset_delay_cnt <= (others => '0');
      local_reset_n   <= '0';
    elsif rising_edge(clk_sys) then
      if(not reset_delay_cnt = 0) then
        local_reset_n <= '1';
      else
        reset_delay_cnt <= reset_delay_cnt + 1;
      end if;
    end if;
  end process;

  cmp_sys_clk_pll : PLL_BASE
    generic map (
      BANDWIDTH          => "OPTIMIZED",
      CLK_FEEDBACK       => "CLKFBOUT",
      COMPENSATION       => "INTERNAL",
      DIVCLK_DIVIDE      => 1,
      CLKFBOUT_MULT      => 8,
      CLKFBOUT_PHASE     => 0.000,
      CLKOUT0_DIVIDE     => 2,          -- 500 MHz
      CLKOUT0_PHASE      => 0.000,
      CLKOUT0_DUTY_CYCLE => 0.500,
      CLKOUT1_DIVIDE     => 8,          -- 125 MHz
      CLKOUT1_PHASE      => 0.000,
      CLKOUT1_DUTY_CYCLE => 0.500,
      CLKOUT2_DIVIDE     => 16,         -- 62.5 MHz
      CLKOUT2_PHASE      => 0.000,
      CLKOUT2_DUTY_CYCLE => 0.500,
      CLKIN_PERIOD       => 8.0,
      REF_JITTER         => 0.016)
    port map (
      CLKFBOUT => pllout_clk_fb_pllref,
      CLKOUT1  => pllout_clk_ref,
      CLKOUT0  => clk_dds,
      CLKOUT2  => pllout_clk_sys,
      CLKOUT3  => open,
      CLKOUT4  => open,
      CLKOUT5  => open,
      LOCKED   => fpll_locked,
      RST      => fpll_reset,
      CLKFBIN  => pllout_clk_fb_pllref,
      CLKIN    => clk_125m_pllref);


  cmp_clk_vcxo : BUFG
    port map (
      O => clk_20m_vcxo_buf,
      I => clk_20m_vcxo_i);

  cmp_dmtd_clk_pll : PLL_BASE
    generic map (
      BANDWIDTH          => "OPTIMIZED",
      CLK_FEEDBACK       => "CLKFBOUT",
      COMPENSATION       => "INTERNAL",
      DIVCLK_DIVIDE      => 1,
      CLKFBOUT_MULT      => 50,
      CLKFBOUT_PHASE     => 0.000,
      CLKOUT0_DIVIDE     => 16,         -- 62.5 MHz
      CLKOUT0_PHASE      => 0.000,
      CLKOUT0_DUTY_CYCLE => 0.500,
      CLKOUT1_DIVIDE     => 16,         -- 62.5 MHz
      CLKOUT1_PHASE      => 0.000,
      CLKOUT1_DUTY_CYCLE => 0.500,
      CLKOUT2_DIVIDE     => 8,
      CLKOUT2_PHASE      => 0.000,
      CLKOUT2_DUTY_CYCLE => 0.500,
      CLKIN_PERIOD       => 50.0,
      REF_JITTER         => 0.016)
    port map (
      CLKFBOUT => pllout_clk_fb_dmtd,
      CLKOUT0  => pllout_clk_dmtd,
      CLKOUT1  => open,                 --pllout_clk_sys,
      CLKOUT2  => open,
      CLKOUT3  => open,
      CLKOUT4  => open,
      CLKOUT5  => open,
      LOCKED   => open,
      RST      => '0',
      CLKFBIN  => pllout_clk_fb_dmtd,
      CLKIN    => clk_20m_vcxo_buf);

  cmp_clk_dmtd_buf : BUFG
    port map (
      O => clk_dmtd,
      I => pllout_clk_dmtd);

  cmp_clk_sys_buf : BUFG
    port map (
      O => clk_sys,
      I => pllout_clk_sys);

-- cmp_clk_dds_buf : BUFG
--    port map (
--      O => clk_dds,
--      I => pllout_clk_dds);


  cmp_clk_ref_buf : BUFG
    port map (
      O => clk_ref,
      I => pllout_clk_ref);

  cmp_gn4124_core : gn4124_core
    port map
    (
      ---------------------------------------------------------
      -- Control and status
      rst_n_a_i => L_RST_N,
      status_o  => open,

      ---------------------------------------------------------
      -- P2L Direction
      --
      -- Source Sync DDR related signals
      p2l_clk_p_i  => P2L_CLKp,
      p2l_clk_n_i  => P2L_CLKn,
      p2l_data_i   => P2L_DATA,
      p2l_dframe_i => P2L_DFRAME,
      p2l_valid_i  => P2L_VALID,
      -- P2L Control
      p2l_rdy_o    => P2L_RDY,
      p_wr_req_i   => P_WR_REQ,
      p_wr_rdy_o   => P_WR_RDY,
      rx_error_o   => RX_ERROR,
      vc_rdy_i     => VC_RDY,

      ---------------------------------------------------------
      -- L2P Direction
      --
      -- Source Sync DDR related signals
      l2p_clk_p_o  => L2P_CLKp,
      l2p_clk_n_o  => L2P_CLKn,
      l2p_data_o   => L2P_DATA,
      l2p_dframe_o => L2P_DFRAME,
      l2p_valid_o  => L2P_VALID,
      -- L2P Control
      l2p_edb_o    => L2P_EDB,
      l2p_rdy_i    => L2P_RDY,
      l_wr_rdy_i   => L_WR_RDY,
      p_rd_d_rdy_i => P_RD_D_RDY,
      tx_error_i   => TX_ERROR,

      ---------------------------------------------------------
      -- Interrupt interface
      dma_irq_o => open,
      irq_p_i   => '0',
      irq_p_o   => open,

      dma_reg_clk_i => clk_sys,

      ---------------------------------------------------------
      -- CSR wishbone interface (master pipelined)
      csr_clk_i   => clk_sys,
      csr_adr_o   => gn_wb_adr,
      csr_dat_o   => cnx_slave_in(c_MASTER_GENNUM).dat,
      csr_sel_o   => cnx_slave_in(c_MASTER_GENNUM).sel,
      csr_stb_o   => cnx_slave_in(c_MASTER_GENNUM).stb,
      csr_we_o    => cnx_slave_in(c_MASTER_GENNUM).we,
      csr_cyc_o   => cnx_slave_in(c_MASTER_GENNUM).cyc,
      csr_dat_i   => cnx_slave_out(c_MASTER_GENNUM).dat,
      csr_ack_i   => cnx_slave_out(c_MASTER_GENNUM).ack,
      csr_stall_i => cnx_slave_out(c_MASTER_GENNUM).stall,

      dma_clk_i   => clk_sys,
      dma_ack_i   => '1',
      dma_stall_i => '0',
      dma_dat_i   => (others => '0'),

      dma_reg_adr_i => (others => '0'),
      dma_reg_dat_i => (others => '0'),
      dma_reg_sel_i => (others => '0'),
      dma_reg_stb_i => '0',
      dma_reg_cyc_i => '0',
      dma_reg_we_i  => '0'
      );

  cnx_slave_in(c_MASTER_GENNUM).adr    <= gn_wb_adr(29 downto 0) & "00";
  cnx_slave_in(c_MASTER_ETHERBONE).cyc <= '0';

  U_Intercon : xwb_sdb_crossbar
    generic map (
      g_num_masters => c_NUM_WB_SLAVES,
      g_num_slaves  => c_NUM_WB_MASTERS,
      g_registered  => true,
      g_wraparound  => true,
      g_layout      => c_INTERCONNECT_LAYOUT,
      g_sdb_addr    => c_SDB_ADDRESS)
    port map (
      clk_sys_i => clk_sys,
      rst_n_i   => local_reset_n,
      slave_i   => cnx_slave_in,
      slave_o   => cnx_slave_out,
      master_i  => cnx_master_in,
      master_o  => cnx_master_out);

  U_The_DDS_Core : dds_core
    port map (
      clk_sys_i         => clk_sys,
      clk_dds_i         => clk_dds,
      clk_ref_i         => clk_ref,
      rst_n_i           => local_reset_n,
      tm_link_up_i      => tm_link_up,
      tm_time_valid_i   => tm_time_valid,
      tm_tai_i          => tm_utc,
      tm_cycles_i       => tm_cycles,
      dac_n_o           => dds_dac_n_o,
      dac_p_o           => dds_dac_p_o,
      dac_pwdn_o        => dds_dac_pwdn_o,
      clk_dds_locked_i  => fpll_locked,
--      pll_vcxo_cs_n_o     => dds_pll_vcxo_cs_n_o,
--      pll_vcxo_function_o => dds_pll_vcxo_function_o,
      pll_vcxo_sdo_i    => dds_pll_vcxo_sdo_i,
      pll_vcxo_status_i => dds_pll_vcxo_status_i,
--      pll_sys_cs_n_o      => dds_pll_sys_cs_n_o,
      pll_sys_refmon_i  => dds_pll_sys_refmon_i,
      pll_sys_ld_i      => dds_pll_sys_ld_i,
--      pll_sys_reset_n_o   => dds_pll_sys_reset_n_o,
      pll_sys_status_i  => dds_pll_sys_status_i,
--      pll_sys_sync_n_o    => dds_pll_sys_sync_n_o,
--      pll_sclk_o          => dds_pll_sclk_o,
--      pll_sdio_b          => dds_pll_sdio_b,
      pd_ce_o           => dds_pd_ce_o,
      pd_lockdet_i      => dds_pd_lockdet_i,
      pd_clk_o          => dds_pd_clk_o,
      pd_data_b         => dds_pd_data_b,
      pd_le_o           => dds_pd_le_o,
      adc_sdo_i         => dds_adc_sdo_i,
      adc_sck_o         => dds_adc_sck_o,
      adc_cnv_o         => dds_adc_cnv_o,
      adc_sdi_o         => dds_adc_sdi_o,
      slave_i           => cnx_master_out(c_SLAVE_DDS_CORE),
      slave_o           => cnx_master_in(c_SLAVE_DDS_CORE),
      src_i             => wrc_snk_out,
      src_o             => wrc_snk_in,
      snk_i             => wrc_src_out,
      snk_o             => wrc_src_in,
      swrst_o           => swrst,
--      fpll_reset_o        => fpll_reset,
      si57x_scl_b       => dds_si57x_scl_b,
      si57x_sda_b       => dds_si57x_sda_b,
      si57x_oe_o        => dds_si57x_oe_o
      );



-- Tristates for FMC EEPROM
  fmc_scl_b  <= '0' when (wrc_scl_out = '0') else 'Z';
  fmc_sda_b  <= '0' when (wrc_sda_out = '0') else 'Z';
  wrc_scl_in <= fmc_scl_b;
  wrc_sda_in <= fmc_sda_b;
  fd_scl_in  <= fmc_scl_b;
  fd_sda_in  <= fmc_sda_b;

-- Tristates for SFP EEPROM
  sfp_mod_def1_b <= '0' when sfp_scl_out = '0' else 'Z';
  sfp_mod_def2_b <= '0' when sfp_sda_out = '0' else 'Z';
  sfp_scl_in     <= sfp_mod_def1_b;
  sfp_sda_in     <= sfp_mod_def2_b;

  carrier_onewire_b <= '0' when wrc_owr_en(0) = '1' else 'Z';
  wrc_owr_in(0)     <= carrier_onewire_b;

  U_WR_CORE : xwr_core
    generic map (
      g_simulation                => g_simulation,
      g_phys_uart                 => true,
      g_virtual_uart              => true,
      g_with_external_clock_input => false,
      g_aux_clks                  => 0,
      g_ep_rxbuf_size             => 1024,
      g_dpram_initf               => f_pick(g_simulation = 0, "", "default"),
      g_dpram_size                => 90112/4,
      g_interface_mode            => PIPELINED,
      g_address_granularity       => BYTE)
    port map (
      clk_sys_i  => clk_sys,
      clk_dmtd_i => clk_dmtd,
      clk_ref_i  => clk_ref,
      rst_n_i    => local_reset_n,

      dac_hpll_load_p1_o => dac_hpll_load_p1,
      dac_hpll_data_o    => dac_hpll_data,
      dac_dpll_load_p1_o => dac_dpll_load_p1,
      dac_dpll_data_o    => dac_dpll_data,

      phy_ref_clk_i      => clk_ref,
      phy_tx_data_o      => phy_tx_data,
      phy_tx_k_o         => phy_tx_k,
      phy_tx_disparity_i => phy_tx_disparity,
      phy_tx_enc_err_i   => phy_tx_enc_err,
      phy_rx_data_i      => phy_rx_data,
      phy_rx_rbclk_i     => phy_rx_rbclk,
      phy_rx_k_i         => phy_rx_k,
      phy_rx_enc_err_i   => phy_rx_enc_err,
      phy_rx_bitslide_i  => phy_rx_bitslide,
      phy_rst_o          => phy_rst,
      phy_loopen_o       => phy_loopen,

      led_act_o  => LED_RED,
      led_link_o => LED_GREEN,

      scl_o     => wrc_scl_out,
      scl_i     => wrc_scl_in,
      sda_o     => wrc_sda_out,
      sda_i     => wrc_sda_in,
      sfp_scl_o => sfp_scl_out,
      sfp_scl_i => sfp_scl_in,
      sfp_sda_o => sfp_sda_out,
      sfp_sda_i => sfp_sda_in,
      sfp_det_i => sfp_mod_def0_b,

      uart_rxd_i => uart_rxd_i,
      uart_txd_o => uart_txd_o,

      owr_en_o => wrc_owr_en,
      owr_i    => wrc_owr_in,

      slave_i => cnx_master_out(c_SLAVE_WRCORE),
      slave_o => cnx_master_in(c_SLAVE_WRCORE),


      wrf_src_o => wrc_true_src_out,
      wrf_src_i => wrc_true_src_in,
      wrf_snk_o => wrc_true_snk_out,
      wrf_snk_i => wrc_true_snk_in,

      tm_link_up_o    => tm_link_up,
      tm_time_valid_o => tm_time_valid,
      tm_tai_o        => tm_utc,
      tm_cycles_o     => tm_cycles,

      btn1_i => '1',
      btn2_i => '1',

      rst_aux_n_o => open,
      pps_p_o     => pps
      );


  U_GTP : wr_gtp_phy_spartan6
    generic map (
      g_simulation => g_simulation,
      g_enable_ch0 => 0,
      g_enable_ch1 => 1)
    port map (
      gtp_clk_i          => clk_ref,
      ch0_ref_clk_i      => clk_ref,
      ch0_tx_data_i      => x"00",
      ch0_tx_k_i         => '0',
      ch0_tx_disparity_o => open,
      ch0_tx_enc_err_o   => open,
      ch0_rx_rbclk_o     => open,
      ch0_rx_data_o      => open,
      ch0_rx_k_o         => open,
      ch0_rx_enc_err_o   => open,
      ch0_rx_bitslide_o  => open,
      ch0_rst_i          => '1',
      ch0_loopen_i       => '0',

      ch1_ref_clk_i      => clk_ref,
      ch1_tx_data_i      => phy_tx_data,
      ch1_tx_k_i         => phy_tx_k,
      ch1_tx_disparity_o => phy_tx_disparity,
      ch1_tx_enc_err_o   => phy_tx_enc_err,
      ch1_rx_data_o      => phy_rx_data,
      ch1_rx_rbclk_o     => phy_rx_rbclk,
      ch1_rx_k_o         => phy_rx_k,
      ch1_rx_enc_err_o   => phy_rx_enc_err,
      ch1_rx_bitslide_o  => phy_rx_bitslide,
      ch1_rst_i          => phy_rst,
      ch1_loopen_i       => '0',        --phy_loopen,
      pad_txn0_o         => open,
      pad_txp0_o         => open,
      pad_rxn0_i         => '0',
      pad_rxp0_i         => '0',
      pad_txn1_o         => sfp_txn_o,
      pad_txp1_o         => sfp_txp_o,
      pad_rxn1_i         => sfp_rxn_i,
      pad_rxp1_i         => sfp_rxp_i);



  U_DAC_ARB : spec_serial_dac_arb
    generic map (
      g_invert_sclk    => false,
      g_num_extra_bits => 8)

    port map (
      clk_i   => clk_sys,
      rst_n_i => local_reset_n,

      val1_i  => dac_dpll_data,
      load1_i => dac_dpll_load_p1,

      val2_i  => dac_hpll_data,
      load2_i => dac_hpll_load_p1,

      dac_cs_n_o(0) => dac_cs1_n,
      dac_cs_n_o(1) => dac_cs2_n_o,
--      dac_clr_n_o   => open,
      dac_sclk_o    => dac_sclk,
      dac_din_o     => dac_din);

  dac_sclk_o <= dac_sclk;
  dac_din_o  <= dac_din;


  dds_wr_dac_sync_n_o <= dac_cs1_n;
  dds_wr_dac_din_o    <= dac_din;
  dds_wr_dac_sclk_o   <= dac_sclk;

--  dac_clr_n_o <= '1';

  sfp_tx_disable_o <= '0';



--  cnx_master_in(1).ack   <= '1';
--  cnx_master_in(1).stall <= '0';
--  cnx_master_in(1).err   <= '0';
--  cnx_master_in(1).rty   <= '0';

-- Drive unused signals


  dds_onewire_b      <= 'Z';
  dds_trig_term_en_o <= '0';
  dds_trig_dir_o     <= '0';
  dds_trig_act_o     <= '0';

  gen_sim_stuff : if(g_bypass_wrcore /= 0) generate
    wrc_snk_in_cyc <= wrc_snk_in.cyc;
    wrc_snk_in_stb <= wrc_snk_in.stb;
    wrc_snk_in_we  <= wrc_snk_in.we;
    wrc_snk_in_sel <= wrc_snk_in.sel;
    wrc_snk_in_adr <= wrc_snk_in.adr;
    wrc_snk_in_dat <= wrc_snk_in.dat;

    wrc_snk_out.rty   <= wrc_snk_out_rty;
    wrc_snk_out.stall <= wrc_snk_out_stall;
    wrc_snk_out.ack   <= wrc_snk_out_ack;
    wrc_snk_out.err   <= wrc_snk_out_err;

    wrc_src_out.cyc <= wrc_src_out_cyc;
    wrc_src_out.stb <= wrc_src_out_stb;
    wrc_src_out.we  <= wrc_src_out_we;
    wrc_src_out.sel <= wrc_src_out_sel;
    wrc_src_out.adr <= wrc_src_out_adr;
    wrc_src_out.dat <= wrc_src_out_dat;

    wrc_src_in_ack   <= wrc_src_in.ack;
    wrc_src_in_stall <= wrc_src_in.stall;
    wrc_src_in_err   <= wrc_src_in.err;
    wrc_src_in_rty   <= wrc_src_in.rty;
    
    
  end generate gen_sim_stuff;

  gen_nosim_stuff : if(g_bypass_wrcore = 0) generate
    
    
    wrc_true_snk_in <= wrc_snk_in;
    wrc_true_src_in <= wrc_src_in;
    wrc_snk_out     <= wrc_true_snk_out;
    wrc_src_out     <= wrc_true_src_out;
    
    
  end generate gen_nosim_stuff;


end rtl;

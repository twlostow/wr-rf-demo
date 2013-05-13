library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


use work.streamers_pkg.all;
use work.wr_fabric_pkg.all;
use work.gencores_pkg.all;
use work.genram_pkg.all;
use work.dds_wbgen2_pkg.all;

entity dds_rx_path is
  generic(
    g_acc_bits : integer);

  port (
    clk_sys_i : in std_logic;
    clk_ref_i : in std_logic;

    rst_n_sys_i : in std_logic;
    rst_n_ref_i : in std_logic;

    tune_o      : out std_logic_vector(17 downto 0);
    cic_reset_o : out std_logic;

    acc_o      : out std_logic_vector(g_acc_bits-1 downto 0);
    acc_load_o : out std_logic;

    snk_i : in  t_wrf_sink_in;
    snk_o : out t_wrf_sink_out;


    tm_time_valid_i : in std_logic;
    tm_tai_i        : in std_logic_vector(39 downto 0);
    tm_cycles_i     : in std_logic_vector(27 downto 0);

    regs_i : in  t_dds_out_registers;
    regs_o : out t_dds_in_registers
    );

end dds_rx_path;

architecture behavioral of dds_rx_path is

  component timestamp_compare
    generic (
      g_cycles_bits  : integer := 28;
      g_tai_bits     : integer := 32;
      g_ref_clk_rate : integer := 125000000);
    port (
      clk_i      : in  std_logic;
      rst_n_i    : in  std_logic;
      valid_i    : in  std_logic;
      a_tai_i    : in  std_logic_vector(g_tai_bits-1 downto 0);
      a_cycles_i : in  std_logic_vector(g_cycles_bits-1 downto 0);
      b_tai_i    : in  std_logic_vector(g_tai_bits-1 downto 0);
      b_cycles_i : in  std_logic_vector(g_cycles_bits-1 downto 0);
      valid_o    : out std_logic;
      equal_o    : out std_logic;
      a_less_o   : out std_logic;
      a_great_o  : out std_logic);
  end component;

  component timestamp_adder
    generic (
      g_frac_bits    : integer := 2;
      g_cycles_bits  : integer := 28;
      g_tai_bits     : integer := 32;
      g_ref_clk_rate : integer := 125000000);
    port (
      clk_i      : in  std_logic;
      rst_n_i    : in  std_logic;
      valid_i    : in  std_logic;
      enable_i   : in  std_logic                                := '1';
      a_tai_i    : in  std_logic_vector(g_tai_bits-1 downto 0);
      a_cycles_i : in  std_logic_vector(g_cycles_bits-1 downto 0);
      a_frac_i   : in  std_logic_vector(g_frac_bits-1 downto 0) := (others => '0');
      b_tai_i    : in  std_logic_vector(g_tai_bits-1 downto 0);
      b_cycles_i : in  std_logic_vector(g_cycles_bits-1 downto 0);
      b_frac_i   : in  std_logic_vector(g_frac_bits-1 downto 0) := (others => '0');
      valid_o    : out std_logic;
      q_tai_o    : out std_logic_vector(g_tai_bits-1 downto 0);
      q_cycles_o : out std_logic_vector(g_cycles_bits-1 downto 0);
      q_frac_o   : out std_logic_vector(g_frac_bits-1 downto 0));
  end component;

  type t_rx_state is (RX_WAIT_SAMPLE, RX_TUNE, RX_ACC);

  type t_drive_state is (DRV_WAIT_SAMPLE, DRV_READ_SAMPLE, DRV_ADJUST, DRV_WAIT_TRIGGER);

  type t_cic_reset_state is(CIC_WAIT, CIC_DONE);


  signal mac_target : std_logic_vector(47 downto 0);

  signal rx_data  : std_logic_vector(63 downto 0);
  signal rx_valid : std_logic;
  signal rx_dreq  : std_logic;
  signal rx_last  : std_logic;
  signal rx_first : std_logic;

  signal rx_cnt, hit_cnt, miss_cnt : unsigned(23 downto 0);

  signal acc_sys, acc_ref                   : std_logic_vector(g_acc_bits-1 downto 0);
  signal tune_sys, tune_ref                 : std_logic_vector(17 downto 0);
  signal tai_sys, tai_ref, tai_adj          : std_logic_vector(31 downto 0);
  signal cycles_sys, cycles_ref, cycles_adj : std_logic_vector(27 downto 0);

  signal tai_d0    : std_logic_vector(31 downto 0);
  signal cycles_d0 : std_logic_vector(27 downto 0);

  signal compare_enable, compare_done : std_logic;

  signal new_sample_sys, new_sample_ref, new_sample_rdy : std_logic;
  signal adjusted_rdy, drive_start                      : std_logic;

  signal rx_state  : t_rx_state;
  signal drv_state : t_drive_state;
  signal cic_state : t_cic_reset_state;

  signal ts_miss, ts_hit : std_logic;
  signal sync_ready      : std_logic;

  signal fifo_in                        : std_logic_vector(127 downto 0);
  signal fifo_out                       : std_logic_vector(127 downto 0);
  signal fifo_rd, fifo_full, fifo_empty : std_logic;

  signal slave_mode_on : std_logic;
  
begin  -- behavioral

  U_Sync_SlaveMode : gc_sync_ffs
    port map (
      clk_i    => clk_ref_i,
      rst_n_i  => rst_n_ref_i,
      data_i   => regs_i.cr_slave_o,
      synced_o => slave_mode_on);


  U_RX_streamer : xrx_streamer
    generic map (
      g_data_width        => 64,
      g_buffer_size       => 64,
      g_filter_remote_mac => false)
    port map (
      clk_sys_i               => clk_sys_i,
      rst_n_i                 => rst_n_sys_i,
      snk_i                   => snk_i,
      snk_o                   => snk_o,
      clk_ref_i               => clk_ref_i,
      tm_time_valid_i         => tm_time_valid_i,
      tm_tai_i                => tm_tai_i,
      tm_cycles_i             => tm_cycles_i,
      rx_first_o              => rx_first,
      rx_last_o               => rx_last,
      rx_data_o               => rx_data,
      rx_valid_o              => rx_valid,
      rx_dreq_i               => rx_dreq,
      cfg_mac_local_i         => mac_target,
      cfg_accept_broadcasts_i => '1');

  mac_target <= regs_i.mach_mach_o & regs_i.macl_macl_o;


  p_rx_fsm : process(clk_sys_i)
  begin
    if rising_edge(clk_sys_i) then
      if rst_n_sys_i = '0' then
        rx_state       <= RX_WAIT_SAMPLE;
        new_sample_sys <= '0';
        rx_cnt         <= (others => '0');
      else
        if(regs_i.cr_slave_o = '0') then
          rx_dreq <= '1';
        else
          
          case rx_state is
            when RX_WAIT_SAMPLE =>
              rx_dreq        <= '1';
              new_sample_sys <= '0';
              if(regs_i.cr_slave_o = '1' and rx_valid = '1' and rx_first = '1')then
                rx_state              <= RX_ACC;
                tai_sys (31 downto 0) <= rx_data(63 downto 32);
                cycles_sys            <= rx_data(27 downto 0);

              end if;

            when RX_ACC =>
              if(rx_valid = '1') then
                acc_sys  <= rx_data(g_acc_bits-1 downto 0);
                rx_state <= RX_TUNE;
              end if;
              
            when RX_TUNE =>
              if(rx_valid = '1') then
                tune_sys <= rx_data(17 downto 0);
                rx_state <= RX_WAIT_SAMPLE;
                if(rx_data(47 downto 32) = regs_i.cr_clk_id_o) then
                  rx_cnt         <= rx_cnt + 1;
                  new_sample_sys <= not fifo_full;
                end if;
              end if;


          end case;
        end if;
      end if;
    end if;
  end process;

  U_Sync_FIFO : generic_async_fifo
    generic map (
      g_data_width => 128,
      g_size       => 64)
    port map (
      rst_n_i    => rst_n_sys_i,
      clk_wr_i   => clk_sys_i,
      d_i        => fifo_in,
      we_i       => new_sample_sys,
      wr_full_o  => fifo_full,
      clk_rd_i   => clk_ref_i,
      q_o        => fifo_out,
      rd_i       => fifo_rd,
      rd_empty_o => fifo_empty);



  fifo_in(42 downto 0)   <= acc_sys;
  fifo_in(127 downto 96) <= tai_sys;
  fifo_in(91 downto 64)  <= cycles_sys;
  fifo_in(63 downto 46)  <= tune_sys;

  acc_ref    <= fifo_out(42 downto 0);
  tai_ref    <= fifo_out(127 downto 96);
  cycles_ref <= fifo_out(91 downto 64);
  tune_ref   <= fifo_out(63 downto 46);

  U_Add_delay : timestamp_adder
    port map (
      clk_i                    => clk_ref_i,
      rst_n_i                  => rst_n_ref_i,
      valid_i                  => new_sample_rdy,
      enable_i                 => '1',
      a_tai_i                  => tai_ref,
      a_cycles_i               => cycles_ref,
      b_tai_i                  => x"00000000",
      b_cycles_i(15 downto 0)  => regs_i.dlyr_delay_o,
      b_cycles_i(27 downto 16) => x"000",
      valid_o                  => adjusted_rdy,
      q_tai_o                  => tai_adj,
      q_cycles_o               => cycles_adj);

  p_delay_timebase : process(clk_ref_i)
  begin
    if rising_edge(clk_ref_i) then
      tai_d0    <= tm_tai_i(31 downto 0);
      cycles_d0 <= tm_cycles_i;
    end if;
  end process;

  U_Miss_Hit_Check : timestamp_compare
    port map (
      clk_i      => clk_ref_i,
      rst_n_i    => rst_n_ref_i,
      valid_i    => compare_enable,
      a_tai_i    => tai_adj,
      a_cycles_i => cycles_adj,
      b_tai_i    => tai_d0,
      b_cycles_i => cycles_d0,
      valid_o    => compare_done,
      equal_o    => ts_hit,
      a_less_o   => open,
      a_great_o  => ts_miss);

  p_drive_fsm : process(clk_ref_i)
  begin
    if rising_edge(clk_ref_i) then
      if rst_n_ref_i = '0' or slave_mode_on = '0' or tm_time_valid_i = '0' then
        acc_load_o     <= '0';
        drv_state      <= DRV_WAIT_SAMPLE;
        fifo_rd        <= '0';
        compare_enable <= '0';
        new_sample_ref <= '0';
        hit_cnt        <= (others => '0');
        miss_cnt       <= (others => '0');
      else

        case drv_state is
          when DRV_WAIT_SAMPLE =>
            acc_load_o <='0';
            compare_enable <= '0';
            if(fifo_empty = '0') then
              fifo_rd   <= '1';
              drv_state <= DRV_READ_SAMPLE;
            end if;

          when DRV_READ_SAMPLE =>
            compare_enable <= '1';
            fifo_rd        <= '0';
            new_sample_ref <= '1';
            drv_state      <= DRV_ADJUST;

          when DRV_ADJUST =>
            new_sample_ref <= '0';
            if(compare_done = '1') then
              if(ts_miss = '1') then
                miss_cnt  <= miss_cnt + 1;
                drv_state <= DRV_WAIT_SAMPLE;
              else
                drv_state <= DRV_WAIT_TRIGGER;
              end if;
            end if;
            
          when DRV_WAIT_TRIGGER =>
            if(ts_hit = '1') then
              acc_load_o <= '0';
              acc_o      <= acc_ref;
              tune_o     <= tune_ref;
              drv_state  <= DRV_WAIT_SAMPLE;
              hit_cnt    <= hit_cnt+ 1;
            else
              acc_load_o <= '0';
            end if;
            
        end case;
      end if;
    end if;
  end process;

  p_cic_reset_fsm : process(clk_ref_i)
  begin
    if rising_edge(clk_ref_i) then
      if rst_n_ref_i = '0' or tm_time_valid_i = '0' or slave_mode_on = '0' then
        cic_state <= CIC_WAIT;
      else

        case cic_state is
          when CIC_WAIT =>
            if(drv_state = DRV_WAIT_TRIGGER and ts_hit = '1' and tm_time_valid_i = '1') then
              cic_state <= CIC_DONE;
            end if;

          when CIC_DONE =>
            if(tm_time_valid_i = '0') then
              cic_state <= CIC_WAIT;
            end if;
            
        end case;
        
      end if;
    end if;
  end process;

  cic_reset_o <= '1' when rst_n_ref_i = '0' or (tm_time_valid_i = '1' and ts_hit = '1' and (cic_state = CIC_WAIT) and slave_mode_on = '1') else '0';

  regs_o.hit_cnt_hit_cnt_i   <= std_logic_vector(hit_cnt);
  regs_o.miss_cnt_miss_cnt_i <= std_logic_vector(miss_cnt);
  regs_o.rx_cnt_rx_cnt_i     <= std_logic_vector(rx_cnt);
  
end behavioral;

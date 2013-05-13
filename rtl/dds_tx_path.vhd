library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.streamers_pkg.all;
use work.wr_fabric_pkg.all;
use work.gencores_pkg.all;
use work.dds_wbgen2_pkg.all;
entity dds_tx_path is
  generic(
    g_acc_bits : integer);

  port (
    clk_sys_i : in std_logic;
    clk_ref_i : in std_logic;

    rst_n_sys_i : in std_logic;
    rst_n_ref_i : in std_logic;

    tune_i   : in std_logic_vector(17 downto 0);
    cic_ce_i : in std_logic;
    acc_i    : in std_logic_vector(g_acc_bits-1 downto 0);

    src_i : in  t_wrf_source_in;
    src_o : out t_wrf_source_out;

    tm_time_valid_i : in std_logic;
    tm_tai_i        : in std_logic_vector(39 downto 0);
    tm_cycles_i     : in std_logic_vector(27 downto 0);

    regs_i : in  t_dds_out_registers;
    regs_o : out t_dds_in_registers
    );

end dds_tx_path;

architecture behavioral of dds_tx_path is

  type t_state is (WAIT_SAMPLE, TX_TIMESTAMP, TX_TUNE, TX_ACC, TX_PAD);

  signal tx_data  : std_logic_vector(63 downto 0);
  signal tx_valid : std_logic;
  signal tx_dreq  : std_logic;
  signal tx_last  : std_logic;

  signal mac_target : std_logic_vector(47 downto 0);

  signal acc_snap    : std_logic_vector(g_acc_bits-1 downto 0);
  signal tune_snap   : std_logic_vector(17 downto 0);
  signal tai_snap    : std_logic_vector(39 downto 0);
  signal cycles_snap : std_logic_vector(27 downto 0);
  signal new_sample  : std_logic;

  signal new_sample_sys, tune_valid : std_logic;

  signal state : t_state;

  signal tx_cnt : unsigned(23 downto 0);
  
begin  -- behavioral

  regs_o.tx_cnt_tx_cnt_i <= std_logic_vector(tx_cnt);

  p_take_tags : process(clk_ref_i)
  begin
    if rising_edge(clk_ref_i) then
      if rst_n_ref_i = '0' then
        new_sample <= '0';
        tune_valid <= '0';
      else
        tune_valid <= cic_ce_i;
        if(tune_valid = '1' and tm_time_valid_i = '1') then
          new_sample  <= '1';
          acc_snap    <= acc_i;
          tune_snap   <= tune_i;
          tai_snap    <= tm_tai_i;
          cycles_snap <= tm_cycles_i;
        else
          new_sample <= '0';
        end if;
      end if;
    end if;
  end process;

  U_Sync : gc_pulse_synchronizer
    port map (
      clk_in_i  => clk_ref_i,
      clk_out_i => clk_sys_i,
      rst_n_i   => rst_n_sys_i,
      d_p_i     => new_sample,
      q_p_o     => new_sample_sys);

  U_Streamer : xtx_streamer
    generic map (
      g_data_width             => 64,
      g_tx_threshold           => 4,
      g_tx_max_words_per_frame => 128,
      g_tx_timeout             => 64)
    port map (
      clk_sys_i        => clk_sys_i,
      rst_n_i          => rst_n_sys_i,
      src_i            => src_i,
      src_o            => src_o,
      clk_ref_i        => clk_ref_i,
      tm_time_valid_i  => tm_time_valid_i,
      tm_tai_i         => tm_tai_i,
      tm_cycles_i      => tm_cycles_i,
      tx_data_i        => tx_data,
      tx_valid_i       => tx_valid,
      tx_dreq_o        => tx_dreq,
      tx_last_i        => tx_last,
      cfg_mac_target_i => mac_target);

  mac_target <= regs_i.mach_mach_o & regs_i.macl_macl_o;

  p_tx_fsm : process(clk_sys_i)
  begin
    if rising_edge(clk_sys_i) then
      if rst_n_sys_i = '0' or regs_i.cr_master_o = '0' then
        state    <= WAIT_SAMPLE;
        tx_valid <= '0';
        tx_last  <= '0';
        tx_data  <= (others => '0');
        tx_cnt   <= (others => '0');
        
      else
        case state is
          when WAIT_SAMPLE =>

            tx_valid <= '0';
            tx_last  <= '0';
            if(regs_i.cr_master_o = '1' and new_sample_sys = '1') then
              state <= TX_TIMESTAMP;
            end if;

          when TX_TIMESTAMP =>
            tx_cnt <= tx_cnt + 1;
            if(tx_dreq = '1') then
              tx_data(27 downto 0)  <= cycles_snap;
              tx_data(63 downto 32) <= tai_snap(31 downto 0);
              tx_valid              <= '1';
              tx_last               <= '0';
              state                 <= TX_ACC;
            else
              tx_valid <= '0';
            end if;

          when TX_ACC =>
            if(tx_dreq = '1') then
              tx_data(g_acc_bits-1 downto 0) <= acc_snap;
              tx_valid                       <= '1';
              tx_last                        <= '0';
              state                          <= TX_TUNE;
            else
              tx_valid <= '0';
            end if;

          when TX_TUNE =>
            if(tx_dreq = '1') then
              tx_data(17 downto 0)  <= tune_snap;
              tx_data(47 downto 32) <= regs_i.cr_clk_id_o;
              tx_valid              <= '1';
              tx_last               <= '0';
              state                 <= TX_PAD;
            else
              tx_valid <= '0';
            end if;

          when TX_PAD =>
            if(tx_dreq = '1') then
              tx_valid <= '1';
              tx_last  <= '1';

              state <= WAIT_SAMPLE;
            else
              tx_valid <= '0';
            end if;
            
        end case;
      end if;
    end if;
  end process;
  
end behavioral;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.dds_wbgen2_pkg.all;

entity ad7980_if is
  
  port (
    clk_i   : in std_logic;
    rst_n_i : in std_logic;

    trig_i : in std_logic;

    d_o       : out std_logic_vector(15 downto 0);
    d_valid_o : out std_logic;

    adc_sdo_i : in  std_logic;
    adc_sck_o : out std_logic;
    adc_cnv_o : out std_logic;
    adc_sdi_o : out std_logic
    );

end ad7980_if;

architecture rtl of ad7980_if is

  component spi_master
    generic (
      g_div_ratio_log2 : integer;
      g_num_data_bits  : integer);
    port (
      clk_sys_i  : in  std_logic;
      rst_n_i    : in  std_logic;
      start_i    : in  std_logic;
      cpol_i     : in  std_logic;
      data_i     : in  std_logic_vector(g_num_data_bits - 1 downto 0);
      drdy_o     : out std_logic;
      ready_o    : out std_logic;
      data_o     : out std_logic_vector(g_num_data_bits - 1 downto 0);
      spi_cs_n_o : out std_logic;
      spi_sclk_o : out std_logic;
      spi_mosi_o : out std_logic;
      spi_miso_i : in  std_logic);
  end component;

  signal count  : unsigned(7 downto 0);
  signal do_acq : std_logic;

  type t_state is (WAIT_TRIG, START_CNV, READBACK);

  signal state : t_state;

  signal d_rdy : std_logic;
begin  -- rtl

  U_SPI_Master : spi_master
    generic map (
      g_div_ratio_log2 => 3,
      g_num_data_bits  => 16)
    port map (
      clk_sys_i  => clk_i,
      rst_n_i    => rst_n_i,
      start_i    => do_acq,
      cpol_i     => '0',
      data_i     => x"0000",
      data_o     => d_o,
      drdy_o     => d_rdy,
      spi_sclk_o => adc_sck_o,
      spi_miso_i => adc_sdo_i);

  d_valid_o <= d_rdy;
  adc_sdi_o <= '1';

  p_acquire : process(clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        count     <= (others => '0');
        adc_cnv_o <= '0';
        do_acq    <= '0';
        state     <= WAIT_TRIG;
      else

        case state is
          when WAIT_TRIG =>
            if(trig_i = '1') then
              count     <= (others => '0');
              adc_cnv_o <= '1';
              state     <= START_CNV;
            end if;
          when START_CNV =>
            count<= count +1;
            if(count = 100) then
              adc_cnv_o <= '0';
              do_acq    <= '1';
              state     <= READBACK;
            end if;

          when READBACK =>
            do_acq <= '0';
            if(d_rdy = '1') then
              state <= WAIT_TRIG;
            end if;
            
        end case;
      end if;
    end if;
  end process;
  

end rtl;

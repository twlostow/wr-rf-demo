
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timestamp_compare is
  generic
    (
      -- sizes of the respective bitfields of the input/output timestamps
      g_cycles_bits : integer := 28;
      g_tai_bits    : integer := 40;

      -- upper bound of the coarse part
      g_ref_clk_rate : integer := 125000000
      );

  port(
    clk_i   : in std_logic;
    rst_n_i : in std_logic;

    valid_i : in std_logic;  -- when HI, a_* and b_* contain valid timestamps

    -- Input timestamps
    a_tai_i    : in std_logic_vector(g_tai_bits-1 downto 0);
    a_cycles_i : in std_logic_vector(g_cycles_bits-1 downto 0);

    b_tai_i    : in std_logic_vector(g_tai_bits-1 downto 0);
    b_cycles_i : in std_logic_vector(g_cycles_bits-1 downto 0);

    -- Normalized sum output (valid when valid_o == 1)
    valid_o : out std_logic;

    equal_o   : out std_logic;
    a_less_o  : out std_logic;
    a_great_o : out std_logic

    );
end timestamp_compare;

architecture rtl of timestamp_compare is

  signal tai_less, tai_equal       : std_logic;
  signal cycles_less, cycles_equal : std_logic;
  signal stage1                    : std_logic;

  
  
  
begin  -- rtl

  p_stage1 : process(clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        stage1 <= '0';
      else
        stage1 <= valid_i;

        if(unsigned(a_tai_i) < unsigned(b_tai_i)) then
          tai_less <= '1';
        else
          tai_less <= '0';
        end if;

        if(unsigned(a_tai_i) = unsigned(b_tai_i)) then
          tai_equal <= '1';
        else
          tai_equal <= '0';
        end if;

        if(unsigned(a_cycles_i) < unsigned(b_cycles_i)) then
          cycles_less <= '1';
        else
          cycles_less <= '0';
        end if;

        if(unsigned(a_cycles_i) = unsigned(b_cycles_i)) then
          cycles_equal <= '1';
        else
          cycles_equal <= '0';
        end if;

        
        
      end if;
    end if;
  end process;

  p_stage2 : process(clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        valid_o <= '0';
      else
        equal_o   <= tai_equal and cycles_equal;
        a_less_o  <= tai_less or (tai_equal and cycles_less);
        a_great_o <= (not (tai_equal or tai_less)) or (tai_equal and (not (cycles_less or cycles_equal)));
        valid_o <= stage1;
      end if;
    end if;
  end process;
  
end rtl;

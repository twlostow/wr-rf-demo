library ieee;
use ieee.STD_LOGIC_1164.all;

entity lfsr_gen is
  
  generic (
    g_length     : integer;
    g_init_value : std_logic_vector;
    g_taps       : std_logic_vector;
    g_recurse    : integer := 1
    );

  port (
    clk_i   : in std_logic;
    rst_n_i : in std_logic;

    enable_i : in  std_logic;
    q_o      : out std_logic_vector(g_length-1 downto 0)
    );

end lfsr_gen;

architecture rtl of lfsr_gen is

  subtype t_lfsr_reg is std_logic_vector(g_length-1 downto 0);

  function f_next(x : t_lfsr_reg; taps : std_logic_vector; recurse : integer) return t_lfsr_reg is
    variable tmp : t_lfsr_reg;
    variable t0  : std_logic;
  begin

    tmp := x;
    for i in 1 to recurse loop
      t0  := tmp(0);
      tmp := '0' & tmp(tmp'length-1 downto 1);

      if(t0 = '1')then
        tmp := tmp xor taps;
      end if;
    end loop;  -- i
    return tmp;
  end f_next;

  signal r : t_lfsr_reg;
  
begin  -- rtl

  p_generate : process(clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        r <= g_init_value;
      elsif(enable_i = '1') then
        r   <= f_next(r, g_taps, g_recurse);
        q_o <= r;
      end if;
    end if;
  end process;

end rtl;

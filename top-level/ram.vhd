library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
port (
  clk: in std_logic;
  rst: in std_logic;
  rw:  in std_logic;
  addr:in std_logic_vector(7 downto 0);
  din: in std_logic_vector(7 downto 0);
  dout:out std_logic_vector(7 downto 0)
);
end ram;

architecture arch_ram of ram is
-- tipo de dado (RAM)
type ram_type is array (0 to 255) of std_logic_vector(7 downto 0);

signal ram:ram_type;

begin
  process (clk,rst)
  begin
    if rst<='1' then
      -- carregamento de software
      ram(0) <= "01001100"; --INC A (4C)
      ram(1) <= "01001100"; --INC A (4C)
      ram(2) <= "01001100"; --INC A (4C)
      ram(3) <= "01001010"; --DEC A (4A)

    elsif clk'event and clk<='1' then
      if rw<='1' then --escrita
        ram (to_integer(unsigned(addr))) <= din;
      end if;
    end if;
  end process;
  dout <= ram (to_integer(unsigned(addr)));
end arch_ram;

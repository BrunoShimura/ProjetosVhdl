library ieee;
use ieee.std_logic_1164.all;

entity hc05 is
port (
  clk:  in std_logic;
  rst:  in std_logic;
  dout: in std_logic_vector(7 downto 0)
  rw:   out std_logic;
  addr: out std_logic_vector(7 downto 0);
  din:  out std_logic_vector(7 downto 0);
  led:  out std_logic_vector(7 downto 0)
);
end hc05;

architecture arch_hc05 of hc05 is
begin

end arch_hc05;

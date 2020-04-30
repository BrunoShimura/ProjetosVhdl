library ieee;
use ieee.std_logic_1164.all;

entity top is
port (
  clk:  in std_logic;
  rst:  in std_logic;
  led:  out std_logic_vector(7 downto 0)
);
end top;

architecture arch_top of top is
-- componentes

component hc05
port (
  clk:  in std_logic;
  rst:  in std_logic;
  dout: in std_logic_vector(7 downto 0);
  rw:   out std_logic;
  addr: out std_logic_vector(7 downto 0);
  din:  out std_logic_vector(7 downto 0);
  led:  out std_logic_vector(7 downto 0)
);
end component;

component ram
port (
  clk:  in std_logic;
  rst:  in std_logic;
  rw:   in std_logic;
  addr: in std_logic_vector(7 downto 0);
  din:  in std_logic_vector(7 downto 0);
  dout: out std_logic_vector(7 downto 0)
);
end component;

--sinais
signal  sdout: std_logic_vector(7 downto 0);
signal  srw:   std_logic;
signal  saddr: std_logic_vector(7 downto 0);
signal  sdin:  std_logic_vector(7 downto 0);

begin

hc05_lite:hc05 port map(clk,rst,sdout,srw,saddr,sdin,led);
ram1:ram port map(clk,rst,srw,saddr,sdin,sdout);

end arch_top;

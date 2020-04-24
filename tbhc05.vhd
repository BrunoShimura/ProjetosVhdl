LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY tbhc05 IS 
END tbhc05;

architecture arch_tbhc05 of tbhc05 is

component top  
port (
      clk: in std_logic;
	  rst: in std_logic;
	  led: out std_logic_vector(7 downto 0)
);
END component;

constant PERIODO: time := 100 ns;

-- sinais de controle
signal clk:  std_logic;
signal rst:  std_logic;
signal led:  std_logic_vector(7 downto 0);

begin
-- instanciar top
top1:top port map(clk,rst,led);

geraclk:process
begin
     clk<='0';
	 wait for PERIODO/2; -- 50 ns
	 clk<='1';
	 wait for PERIODO/2; -- 50 ns
end process;

reset:process
begin
     rst='1'; 
	 wait for 2*PERIODO; -- 200ns 
	 rst <='0';
	 wait;
end process;

end arch_tbhc05;

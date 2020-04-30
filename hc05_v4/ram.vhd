LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ram IS 
port (
      clk: in std_logic;
	  rst: in std_logic;
	  rw: in std_logic;
	  addr: in std_logic_vector(7 downto 0);
	  din: in std_logic_vector(7 downto 0);
	  dout: out std_logic_vector(7 downto 0) 
);
END ram;

architecture arch_ram of ram is
-- tipo de dado (RAM)
type ram_type is array (0 to 255) of std_logic_vector(7 downto 0);

signal ram:ram_type;

begin
	process (clk,rst)
	begin
	     if rst='1' then
		    -- carregamento do software 1 (loop infinito) 
			-- ram(0) <= "10100110"; --LDA (IME) A6
			-- ram(1) <= "00000101"; --#5
			-- ram(2) <= "01001100"; --INCA 4C
			-- ram(3) <= "01001100"; --INCA 4C
			-- ram(4) <= "01001100"; --INCA 4C
			-- ram(5) <= "01001010"; --DECA 4A
			-- ram(6) <= "00100000"; --JMP  20
			-- ram(7) <= "00000000"; --#0
			
			-- carregamento do software 2
			ram(0) <= "10100110"; --LDA (IME) A6
			ram(1) <= "00001001"; --#9
			ram(2) <= "01001010"; --DECA 4A
			ram(3) <= "00100111"; --JZ (IME) -- 27
			ram(4) <= "00000111"; --#7
			ram(5) <= "00100000"; --JMP  20
			ram(6) <= "00000010"; --#2
			ram(7) <= "01001100"; --INCA 4C
			ram(8) <= "01001100"; --INCA 4C
			ram(9) <= "01001100"; --INCA 4C
			
			
			
		 elsif clk'event and clk='1' then
		    if rw='1' then -- escrita
			   ram (to_integer(unsigned(addr))) <= din;
			end if;
		 end if;
	end process;
	
	dout <= ram(to_integer(unsigned(addr)));
	
end arch_ram;
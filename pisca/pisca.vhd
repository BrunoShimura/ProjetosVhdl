-- =====================================================================

-- seg <= "11000000"; --0
-- seg <= "11111001"; --1
-- seg <= "10100100"; --2
-- seg <= "10110000"; --3
-- seg <= "10011001"; --4
-- seg <= "10010010"; --5
-- seg <= "10000010"; --6
-- seg <= "11111000"; --7
-- seg <= "10000000"; --8
-- seg <= "10010000"; --9

-- =====================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- =====================================================================

entity pisca is
Port( 
		clk : in	STD_LOGIC;
		an  : out	STD_LOGIC_vector(3 downto 0);
		seg : out	STD_LOGIC_vector(7 downto 0)
	);
end pisca;
architecture Behavioral of pisca is

-- =====================================================================

signal cont: integer range 0 to 100000001;
signal num: integer range 0 to 9;

-- =====================================================================

begin
	an <= "1110";
	process(clk)
		begin
			if clk'event and clk='1' then
				cont <= cont + 1;
				if cont <= 50000000 then
					case num is
						when 0 =>
							seg <= "11000000"; --0
						when 1 =>
							seg <= "11111001"; --1
						when 2 =>
							seg <= "10100100"; --2
						when 3 =>
							seg <= "10110000"; --3
						when 4 =>
							seg <= "10011001"; --4
						when 5 =>
							seg <= "10010010"; --5
						when 6 =>
							seg <= "10000010"; --6
						when 7 =>
							seg <= "11111000"; --7
						when 8 =>
							seg <= "10000000"; --8
						when 9 =>
							seg <= "10010000"; --9
					end case;
				end if;
				if cont = 100000000 then
					if num <= 9 then
						num <= num + 1;
					end if;
					if num = 9 then 
						num <= 0;
					end if;
					cont <= 0;
				end if;
			end if;
	end process;
end Behavioral;

-- =====================================================================

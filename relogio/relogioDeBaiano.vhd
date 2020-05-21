
-- =====================================================================
-- membros (time baianor) 
-- =====================================================================

-- Bruno Anthony Shimura 	RA:577928.
-- André Vaz Miyagi			RA:577715.
-- Gabriel Martinez			RA:581771.
-- Enzo Dal Evedove			RA:579424.

-- =====================================================================
-- idéia do projeto (relógio) 
-- =====================================================================

-- minuto|segundo
--  __ __ __ __  
-- |dm|um|ds|us|   
-- |-- -- -- --|
-- |__|__|__|__|
   
-- us = unidade segundo	(9)
-- ds = dezena segundo	(5)
-- um = unidade minuto	(9) 
-- dm = dezena minuto	(5)

-- Exemplo: 00.00 até 59.59

-- =====================================================================
-- valores de 0 a 9 do 7-segmento
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

entity relogioDeBaiano is
Port(
		clk:in	STD_LOGIC;
		an:out	STD_LOGIC_vector(3 downto 0);
		seg:out	STD_LOGIC_vector(7 downto 0)
	);
end relogioDeBaiano;
architecture Behavioral of relogioDeBaiano is

-- =====================================================================
-- declaração de sinais
-- =====================================================================

-- tempo de um segundo
signal cont: integer range 0 to 100000001;	-- 1hz | 1s

-- tempo que fica em cada display 7-segmentos
signal contdisp: integer range 0 to 100001;	--1kz | 1/1000s

-- qual display vai acender
signal display: integer range 0 to 4;

signal num: integer range 0 to 9;

signal sus: integer range 0 to 9;	-- us = unidade segundo	(9)
signal sds: integer range 0 to 5;	-- ds = dezena segundo	(5)
signal sum: integer range 0 to 9;	-- um = unidade minuto	(9) 
signal sdm: integer range 0 to 5;	-- dm = dezena minuto	(5)

-- =====================================================================
begin
	process(clk)
		begin
			if clk'event and clk='1' then
				cont <= cont + 1;	--1s (relogio)
				contdisp <= contdisp + 1;	--1ms (troca display)
-- =====================================================================
-- logica para trocar de display
-- =====================================================================
				if contdisp = 10000 then	--1ms
					display <= display + 1;
					contdisp <= 0;
					if display = 4 then
						display <= 0;
					end if;
				end if;
-- =====================================================================
-- logica para mostrar numero no display 0 (00.00) até (00.09)
-- =====================================================================
				if display = 0 then
					an <= "1110";
					case sus is
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
-- =====================================================================
-- logica para mostrar numero no display 1 (00.00) até (00.59)
-- =====================================================================
				if display = 1 then
					an <= "1101";
					case sds is
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
					end case;
				end if;
-- =====================================================================
-- logica para mostrar numero no display 2 (00.00) até (09.59)
-- =====================================================================
				if display = 2 then
					an <= "1011";
					case sum is
						when 0 =>
							seg <= "01000000"; --0
						when 1 =>
							seg <= "01111001"; --1
						when 2 =>
							seg <= "00100100"; --2
						when 3 =>
							seg <= "00110000"; --3
						when 4 =>
							seg <= "00011001"; --4
						when 5 =>
							seg <= "00010010"; --5
						when 6 =>
							seg <= "00000010"; --6
						when 7 =>
							seg <= "01111000"; --7
						when 8 =>
							seg <= "00000000"; --8
						when 9 =>
							seg <= "00010000"; --9
					end case;
				end if;
-- =====================================================================
-- logica para mostrar numero no display 3 (00.00) até (59.59)
-- =====================================================================
				if display = 3 then
					an <= "0111";
					case sdm is
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
					end case;
				end if;
-- =====================================================================
-- cont relogio
-- =====================================================================
				if cont = 100000000 then 
-- =====================================================================
-- lógica do relógio
-- =====================================================================
					if sus <= 9 then
						sus <= sus + 1;
					end if;
					if sus = 9 then 
						sus <= 0;
						sds <= sds + 1;
							if sds = 5 then
								sds <= 0;
								sum <= sum + 1;
								if sum = 9 then
									sum <= 0;
									sdm <= sdm + 1;
									if sdm = 5 then 
										sdm <= 0;
									end if;
								end if;
							end if;
					end if;
					cont <= 0;
-- =====================================================================
				end if;
			end if;
	end process;
end Behavioral;

-- =====================================================================
-- é isso... vlw flw !!!
-- =====================================================================

-- us = unidade segundo	(9)
-- ds = dezena segundo	(5)
-- um = unidade minuto	(9) 
-- dm = dezena minuto	(5)

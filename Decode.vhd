LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY decode IS 
port (
      din: in std_logic_vector(2 downto 0);
	  clk: in std_logic;
	  dout: out std_logic_vector(7 downto 0) 
);
END decode;

architecture arch_decode of decode is
Begin
      process(clk)
	  begin
	       if clk'event and clk='1' then
		      case din is
			     when "000" => dout <= "00000001";
				 when "001" => dout <= "00000010";
				 when "010" => dout <= "00000100";
				 when "011" => dout <= "00001000";
				 when "100" => dout <= "00010000";
				 when "101" => dout <= "00100000";
				 when "110" => dout <= "01000000";
				 when "111" => dout <= "10000000";
				 when others => dout <= "00000000";
			  end case;
		   end if;
	  end process;
end arch_decode;
 
--din   dout [oooooooo]
--000   00000001 
--001   00000010 
--010   00000100 
--011   00001000
--100   00010000 



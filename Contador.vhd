LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY cont01 IS 
port (
      clk,rst: in std_logic;
	  dout: out std_logic_vector(3 downto 0) 
);
END cont01;

architecture arch_cont01 of cont01 is
-- sinais
signal cont: std_logic_vector(3 downto 0);
begin	
	process(clk,rst)
	begin
	     if rst='1' then
		    cont <= "0000";
		 elsif clk'event and clk='1' then
		     cont <= cont +1;
			 -- Ã© bom tratar o estouro
			 -- dout <= dout +1; #errado!
		 end if;
		 
	end process;
	
	
	dout <= cont;
	
end arch_cont01;

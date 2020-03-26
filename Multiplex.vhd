LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux2x1 IS 
	PORT (
		clk,rst,enable,sel: in STD_LOGIC;
		E1,E2:in STD_LOGIC;
		S: out  STD_LOGIC
	);
END mux2x1; 

ARCHITECTURE arch_mux2x1 OF mux2x1 is
BEGIN
	PROCESS(clk,rst)
	BEGIN
	     IF rst='1' THEN
		    S<='0';
		 ELSIF clk'EVENT AND clk='1' then
			IF enable='1' THEN
			    IF sel='0' THEN
				   S<=E1;
				ELSE
				   S<=E2;
				END IF;
			END IF;
		 END IF;
	END PROCESS;
END arch_mux2x1;

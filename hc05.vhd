LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY hc05 IS 
port (
      clk: in std_logic;
	  rst: in std_logic;
	  dout: in std_logic_vector(7 downto 0);
	  rw: out std_logic;
	  addr: out std_logic_vector(7 downto 0);
	  din: out std_logic_vector(7 downto 0);
	  led: out std_logic_vector(7 downto 0)
	  
);
END hc05;

architecture arch_hc05 of hc05 is
-- Maquina de estados
signal estado: std_logic_vector(2 downto 0);

-- constantes para definir estados
constant RESET1: std_logic_vector(2 downto 0) :="000";
constant RESET2: std_logic_vector(2 downto 0) :="001";
constant BUSCA: std_logic_vector(2 downto 0)  :="010";
constant DECODE: std_logic_vector(2 downto 0) :="011";
constant EXECUTA: std_logic_vector(2 downto 0):="100";

-- Registradores
signal A: std_logic_vector(7 downto 0);
signal PC: std_logic_vector(7 downto 0);

-- Código da instrução (similar RI)
signal opcode: std_logic_vector(7 downto 0);
signal fase: std_logic_vector(1 downto 0);

begin

    addr <= PC;
	led <= A;
	
	process(clk,rst)
	begin
	     if rst='1' then
		    A <= (others=>'0');
			PC <= (others=>'0');
			rw <= '0';
			din <= (others=>'0');
			opcode <= (others=>'0');
			estado <= RESET1;
			fase <= "00";
		 elsif clk'event and clk='1' then
		    case estado is
				when RESET1 =>
					PC <= (others=>'0');
					rw <= '0'; -- RAM em leitura
					fase <= "00";
					estado <= RESET2;
				when RESET2 =>
					estado <= BUSCA;
				when BUSCA =>
					 opcode <= dout; -- recebe cod. da instrução
					 estado <= DECODE;
				when DECODE =>
					  case opcode is
					    when "01001100"  => -- INC A (4C)
							A <= A +1;
							estado <= EXECUTA;
						when "01001010"  => -- DEC A (4A)
							A <= A -1;
							estado <= EXECUTA;
						when "10100110"  => -- LDA(IME)(A6)
							 if fase="00" then
								PC <= PC+1; -- prox. posicao
								fase <= "01";
							 else
								A <= dout;  -- armazena dado	
								estado <= EXECUTA;
							 end if;
														
                        when others=> null;						
					  end case;
				when EXECUTA =>
					 fase <= "00";
					 PC <= PC +1; -- Próxima instrução
					 estado <= BUSCA;
				when others => estado <= RESET1;
			end case;
		 end if;
	end process;

end arch_hc05;
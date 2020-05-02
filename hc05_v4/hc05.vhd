LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY hc05 IS
port (
      clk: in std_logic;
	  rst: in std_logic;
	  dout: in std_logic_vector(7 downto 0);
	  enter: in std_logic;  -- switch (6)
	  dado: in std_logic_vector(3 downto 0); --switch(3:0)
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
signal aux_pc: std_logic_vector(7 downto 0);


-- Código da instrução (similar RI)
signal opcode: std_logic_vector(7 downto 0);
signal fase: std_logic_vector(1 downto 0);
signal aux_dado:std_logic_vector(3 downto 0); -- switch

-- status (CMP)
signal status: std_logic_vector (4 downto 0);
-- | =(0), <(1), >(2), <=(3), >=(4)

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
			status<="00000"; -- CMP (resultado)
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
						when "00100000"  => -- JMP(IME)(20) -- BRA
							 if fase="00" then
								PC <= PC+1; -- prox. posicao
								fase <= "01";
							 else
								PC <= dout;  -- armazena dado
								estado <= BUSCA;
								fase <= "00";
							 end if;
						when "00100111"  => -- JZ(IME)(27) -- BRE
							 if fase="00" then
								PC <= PC+1; -- prox. posicao
								fase <= "01";
							 else
								if A = "00000000" then -- Saltar
								   PC <= dout;  -- prox. end.
								   estado <= BUSCA;
								   fase <= "00";
							    else -- nao saltar
									estado <= EXECUTA;
								end if;
							 end if;
						when "10101011"  => -- ADD(IME)(AB)
							 if fase="00" then
								PC <= PC+1; -- prox. posicao
								fase <= "01";
							 else
								A <= A+dout;  -- armazena dado
								estado <= EXECUTA;
							 end if;
						when "10100000"  => -- SUB(IME)(A0)
							 if fase="00" then
								PC <= PC+1; -- prox. posicao
								fase <= "01";
							 else
								A <= A-dout;  -- armazena dado
								estado <= EXECUTA;
							 end if;
						when "00100101"	 --25 (ler dado/switch)
						     if fase="00" then
							    if enter='1' then
								   aux_dado <= dado;
								   fase <= "01";
								end if;
							 else
							     if enter='0' then
									estado <= EXECUTA;
								 end if;
							 end if;
						when "10110111"	 --B7 (STA)	-- sem simulaçao
							 if fase="00" then
								PC <= PC+1; -- prox. posicao
								fase <= "01";
							 elsif fase="01" then
						        aux_pc <= PC;
								PC <= dout;
								din <= A; -- dado a ser escrito
								fase <= "10";
							 elsif fase="10" then
								RW <= '1'; -- escrever
								fase <= "11";
							 else
						        RW <= '0';	-- leitura
								PC <= aux_pc;
								estado <= executa;
							end if;
						when "00110101"  => -- CMP (35)
							 if fase="00" then
								PC <= PC+1; -- prox. posicao
								fase <= "01";
								status <="00000";
							 else
								  -- A= 3
								  -- Valor=3
								  -- A <= valor
								if A = dout then    --igual(JE/JNE)
								   status(0)<= '1';
								end if;
								if A < dout then
									status(1)<= '1'; -- menor (JL)
								end if;
								if A > dout then	-- maior (JG)
									status(2)<= '1';
								end if;
								if A<=dout then
									status(3)<= '1'; --menor igual(JLE)
								end if;
								if A>=dout then    -- maior igual (JGE)
								    status(4)<= '1';
								end if;
								estado <= EXECUTA;
							 end if;

						when "00101000"  => -- JE(IME)(28) -- BRE
							 if fase="00" then
								PC <= PC+1; -- prox. posicao
								fase <= "01";
							 else
                   if status(0)='1' then
								   PC <= dout;  -- prox. end.
								   estado <= BUSCA;
								   fase <= "00";
							    else -- nao saltar
									estado <= EXECUTA;
								end if;
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

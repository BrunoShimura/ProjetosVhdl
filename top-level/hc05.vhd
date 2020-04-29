library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity hc05 is
port (
  clk:  in std_logic;
  rst:  in std_logic;
  dout: in std_logic_vector(7 downto 0)
  rw:   out std_logic;
  addr: out std_logic_vector(7 downto 0);
  din:  out std_logic_vector(7 downto 0);
  led:  out std_logic_vector(7 downto 0)
);
end hc05;

architecture arch_hc05 of hc05 is
-- Maquina de estados
signal estado: std_logic_vector(2 downto 0);

-- Constantes para definir estados
constant RESET1: std_logic_vector(2 downto 0) :="000";
constant RESET2: std_logic_vector(2 downto 0) :="001";
constant BUSCA: std_logic_vector(2 downto 0)  :="010";
constant DECODE: std_logic_vector(2 downto 0) :="011";
constant EXECUTA: std_logic_vector(2 downto 0):="100";

-- Registradores
signal A: std_logic_vector(7 downto 0);
signal PC: std_logic_vector(7 downto 0);

--Código da instroção (Registrador de instroção)
signal opcode: std_logic_vector(7 downto 0);

begin
  addr <= PC;
  led <= A;
  process(clk,rst)
  begin
    if rst='1' then
      A <= (others=>'0');
      PC <= (others=>'0');
      estado <= RESET1;
    elsif clk'event and clk='1' then
      case estado is
        when RESET1 =>
          PC <= (others=>'0');
          RW <= '0'; --RAM em leitura
          estado <= RESET2;
        when RESET2 =>
          estado <= BUSCA;
        when BUSCA =>
          opcode <= dout; --Recebe cod. da instrução
          estado <= DECODE;
        when DECODE =>
          case opcode is
            when "01001100" => --- incrementa A(4C)
              A <= A + 1;
              estado <= EXECUTA;
            when "01001010" => --- decrementa A(4A)
              A <= A - 1;
              estado <= EXECUTA;
            when others=> null;
          end case;
        when EXECUTA =>
          PC <= PC + 1; --- Próxima instrução
          estado <= BUSCA;
        when others => estado <= RESET1;
      end case;
    end if;
  end process;
end arch_hc05;

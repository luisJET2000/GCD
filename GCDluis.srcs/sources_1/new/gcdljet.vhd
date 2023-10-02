

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.STD_LOGIC_unsigned.all;

entity gcdljet is
Port ( clk : in STD_LOGIC; clr : in STD_LOGIC; go : in STD_LOGIC;
    xin : in STD_LOGIC_VECTOR (3 downto 0);    --primer numero para GCD ej()
    yin : in STD_LOGIC_VECTOR (3 downto 0);    --segundo numero para GCD
    done : out STD_LOGIC;                     --termina el registro
    gcd : out STD_LOGIC_VECTOR (3 downto 0) ;   --gcd el maximo comun divisor de los dos numeros
    clk_1:		out STD_LOGIC;
     an : out STD_LOGIC_VECTOR (3 downto 0));
     
end gcdljet;

architecture Behavioral of gcdljet is   --La arquitectura describe lo que el circuito hace. En otras palabras, en VHDL describe la implementación interna de la entidad asociada a ella.
signal aen : std_logic_vector (3 downto 0);
    --señales para el divisor de frecuencia
 
    signal clk190 : std_logic;
 signal digit : std_logic_vector (3 downto 0);
    signal count : std_logic_vector (1 downto 0);
    signal x, y: std_logic_vector (3 downto 0);
    -- prueba de divisor de 
    constant max_count: INTEGER := 100000000;
	signal count_1: INTEGER range 0 to max_count;
	signal clk_state: STD_LOGIC := '0';
begin
 gen_clock: process(clk, clk_state, count_1)
	begin
		if clk'event and clk='1' then
			if count_1 < max_count then 
				count_1 <= count_1+1;
			else
				clk_state <= not clk_state;
				count_1 <= 0;
			end if;
		end if;
	end process;
	
	persecond: process (clk_state)
	begin
		clk_1 <= clk_state;
	end process;
    --Selecciona (con la señal count) 1 de 4 entradas (de 4 bits cada una) 
  
algoritmo_gcd: process (clk, clr) variable calc, donev : std_logic; begin
    if (clr = '1') then
x <= (others => '0'); y <= (others => '0');
gcd <= (others => '0'); donev := '0';
calc := '0';
        elsif (rising_edge(clk)) then
donev := '0';
    if (go = '1') then
x <= xin; y <= yin; calc := '1';
        elsif (calc = '1') then
    if (x = y) then
gcd <= x; donev := '1';
calc := '0';
    elsif (x < y) then
y <= y - x;
    end if;
    end if;
else end if;
x <= x - y;
done <= donev;

end process algoritmo_gcd;
  with count select
 digit <= x(3 downto 0) when "00",
        x(7 downto 4) when"01";
--Convierte un número binario de 4 bits a 7 segmentos
    with digit select
gcd <= "1001111" when "0001", --1
        "0010010" when "0010", --2
        "0000110" when "0011", --3
        "1001100" when "0100", --4
        "0100100" when "0101", --5
        "0100000" when "0110", --6
        "0001111" when "0111", --7
        "0000000" when "1000", --8
        "0000100" when "1001", --9
        "0001000" when "1010", --A
        "1100000" when "1011", --B
        "0110001" when "1100", --C
        "1000010" when "1101", --D
        "0110000" when "1110", --E
        "0111000" when "1111", --F
        "0000001" when others; --0
    --selección del dígito
    ancode: process (count)
    begin
        if (aen(conv_integer(count)) = '1') then --convierte el valor de count(1:0) a entero
            an <= (others => '1'); --asigna '1s' a toda la señal an(3:0) = "1111"
            an(conv_integer(count)) <= '0';
        else
            an <= "1111";
        end if;
    end process ancode;
end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:28:37 10/31/2017 
-- Design Name: 
-- Module Name:    div_frec - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity frec_pixel is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_pixel : out  STD_LOGIC;
			  clk_b : out std_logic;
			  clk_col: out std_logic;
			  button: in std_logic;
			  choque: in std_logic;
			  perdimos: out std_logic;
			  inic: out std_logic);
end frec_pixel;

architecture Behavioral of frec_pixel is

signal ini, p_ini, pix, clk_bird, p_clk_bird, clk_columna, p_clk_columna, aux, p_aux: std_logic;
signal cont, p_cont, cont2, p_cont2: unsigned(24 downto 0);
signal perdemos, p_perdemos: std_logic;
	type tipo_estado is (parado, jugamos, chocamos);	
	signal estado, p_estado: tipo_estado;

begin
	
	clk_pixel <= pix;
	clk_b <= clk_bird;
	clk_col <= clk_columna;
	perdimos <= perdemos;
	inic<=ini;

	 sinc: process (clk, reset)
	 
		begin
			if(reset = '1') then
			pix <= '0';
			clk_bird <= '0';
			clk_columna <= '0';
			cont <= (others=>'0');
			cont2 <= (others=>'0');
			estado <= parado;
			perdemos <= '1';
			ini<='0';
			aux<='0';
			
			elsif (rising_edge(clk)) then
			pix <= not pix;
			clk_bird <= p_clk_bird;
			clk_columna <= p_clk_columna;
			cont <= p_cont;
			cont2<=p_cont2;
			estado <= p_estado;
			perdemos <= p_perdemos;
			ini<=p_ini;
			aux<=p_aux;
			
			end if;
			
	end process;
			
	reloj_pajaro: process (cont, clk_bird, cont2, clk_columna)
	begin
		p_cont <= cont+1;
		p_clk_bird <= clk_bird;
		p_cont2 <= cont2+1;
		p_clk_columna <= clk_columna;
		
		if (cont = 650000) then
			p_clk_bird <= not clk_bird;
			p_cont<=(others=>'0');
		end if;
		if (cont2 = 200000) then
			p_clk_columna <= not clk_columna;
			p_cont2<=(others=>'0');
		end if;
	end process;
	
	inicio_juego: process(estado, button, choque, perdemos, ini, aux)
	begin
		p_estado <= estado;
		p_perdemos <= perdemos;
		p_ini<=ini;
		p_aux<=aux;
		
		case estado is
		when parado =>
			p_perdemos<='0';
			p_ini<='1';
			if(button = '1') then
				p_estado <= jugamos;
			end if;
			
		when jugamos =>
			p_perdemos<='0';
			p_ini<='0';
			if (choque = '1') then
				p_estado <= chocamos;
			end if;
		
		when chocamos =>
			p_perdemos<='1';
			p_ini<='0';
			if(button = '1') then
				p_aux <= '1';
			elsif(aux = '1') then
				p_estado <= parado;
				p_aux<='0';
			end if;
		end case;
		
	end process;
		
end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:47:00 12/12/2017 
-- Design Name: 
-- Module Name:    columna - Behavioral 
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

entity columna is
Generic(	posx_ini_col1: unsigned(9 downto 0);
			posx_ini_col2: unsigned(9 downto 0);
			posx_ini_col3: unsigned(9 downto 0));
Port (clk : in STD_LOGIC;
		enable: in std_logic;
		reset : in STD_LOGIC;
		px_col1: out std_logic_vector(9 downto 0);
		py_col1: out std_logic_vector(9 downto 0);
		px_col2: out std_logic_vector(9 downto 0);
		py_col2: out std_logic_vector(9 downto 0);
		px_col3: out std_logic_vector(9 downto 0);
		py_col3: out std_logic_vector(9 downto 0);
		perdimos: in std_logic;
		ini: in std_logic);
end columna;

architecture Behavioral of columna is

signal 	posx_col1, p_posx_col1: unsigned(9 downto 0);
signal 	posy_col1, p_posy_col1: unsigned(9 downto 0);
signal	posx_col2, p_posx_col2: unsigned(9 downto 0);
signal	posy_col2, p_posy_col2: unsigned(9 downto 0);
signal	posx_col3, p_posx_col3: unsigned(9 downto 0);
signal	posy_col3, p_posy_col3: unsigned(9 downto 0);
signal aux, p_aux: std_logic;

begin
	px_col1 <= std_logic_vector(posx_col1);
	py_col1 <= std_logic_vector(posy_col1);

	px_col2 <= std_logic_vector(posx_col2);
	py_col2 <= std_logic_vector(posy_col2);

	px_col3 <= std_logic_vector(posx_col3);
	py_col3 <= std_logic_vector(posy_col3);


sinc: process(clk, reset)
	begin
		
		if(reset='1') then
			
			posx_col1 <= posx_ini_col1;
			posx_col2 <= posx_ini_col2;
			posx_col3 <= posx_ini_col3;
			posy_col1 <= "0000001000";
			posy_col2 <= "0000011000";
			posy_col3 <= "0000000100";
			aux <= '0';
			
		elsif (rising_edge(clk)) then
			posx_col1 <= p_posx_col1;
			posx_col2 <= p_posx_col2;
			posx_col3 <= p_posx_col3;
			posy_col1 <= p_posy_col1;
			posy_col2 <= p_posy_col2;
			posy_col3 <= p_posy_col3;
			aux <= p_aux;
		end if;
		
	end process;
	 
movimiento: process(enable, posx_col1, posx_col2, posx_col3, aux, perdimos,ini, posy_col1, posy_col2, posy_col3)
		begin
		
		p_posx_col1 <= posx_col1;
		p_posx_col2 <= posx_col2;
		p_posx_col3 <= posx_col3;
		
		p_posy_col1 <= posy_col1;
		p_posy_col2 <= posy_col2;
		p_posy_col3 <= posy_col3;
		
		p_aux <= aux;		
		
		if(ini='1') then
			p_posx_col1 <= posx_ini_col1;
			p_posx_col2 <= posx_ini_col2;
			p_posx_col3 <= posx_ini_col3;
			p_posy_col1 <= "0000110100";
			p_posy_col2 <= "0010001000";
			p_posy_col3 <= "0001101000";
		end if;		
		
		if (enable='1' and aux='0' and perdimos='0') then
		
			p_posx_col1 <= posx_col1-1;
			p_posx_col2 <= posx_col2-1;
			p_posx_col3 <= posx_col3-1;
			p_aux <= '1';
			
		end if;
		
		if(enable='0') then
		
			p_aux <= '0';
			
		end if;
		
		
		if( posx_col1 = "0000000000") then
			
			p_posx_col1 <= to_unsigned(672,10);
			p_posy_col1 <= posy_col1+200;
			if(posy_col1+203>425-175) then
				p_posy_col1 <= posy_col1+203-(425-175);
			end if;
			
		elsif ( posx_col2 = "0000000000") then
			
			p_posx_col2 <= to_unsigned(672,10);
			p_posy_col2 <= posy_col2+100;
			if(posy_col2+102>425-175) then
				p_posy_col2 <= posy_col2+102-(425-175);
			end if;
			
		elsif ( posx_col3 = "0000000000") then
			
			p_posx_col3 <= to_unsigned(672,10);
			p_posy_col3 <= posy_col3+150;
			if(posy_col3+151>425-175) then
				p_posy_col3 <= posy_col3+151-(425-175);
			end if;
			
		end if;		
		
		end process;
		
	

end Behavioral;


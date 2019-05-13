----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:29:54 10/31/2017 
-- Design Name: 
-- Module Name:    gen_color - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity gen_color is
Port ( blank_h : in STD_LOGIC;
		 blank_v : in STD_LOGIC;
		 RED_in : in STD_LOGIC_VECTOR (2 downto 0);
		 GRN_in : in STD_LOGIC_VECTOR (2 downto 0);
		 BLUE_in : in STD_LOGIC_VECTOR (1 downto 0);
		 RED : out STD_LOGIC_VECTOR (2 downto 0);
		 GRN : out STD_LOGIC_VECTOR (2 downto 0);
		 BLUE : out STD_LOGIC_VECTOR (1 downto 0));
end gen_color;

architecture Behavioral of gen_color is

begin

gen_color:process(Blank_H, Blank_V, RED_in, GRN_in, BLUE_in)
	begin
	
		if (Blank_H='1' or Blank_V='1') then
			RED<=(others => '0'); 
			GRN<=(others => '0');
			BLUE<=(others => '0');
			
		else
			RED<=RED_in; GRN<=GRN_in; BLUE<=BLUE_in;
			
		end if;
		
end process;

end Behavioral;

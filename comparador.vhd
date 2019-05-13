----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:24:51 10/28/2017 
-- Design Name: 
-- Module Name:    comparador - Behavioral 
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

entity comparador is
		Generic (
		Nbit: integer :=8;
		End_Of_Screen: integer :=10;
		Start_Of_Pulse: integer :=20;
		End_Of_Pulse: integer := 30;
		End_Of_Line: integer := 40);
		Port (clk : in STD_LOGIC;
				reset : in STD_LOGIC;
				data : in STD_LOGIC_VECTOR (Nbit-1 downto 0);
				O1 : out STD_LOGIC;
				O2 : out STD_LOGIC;
				O3 : out STD_LOGIC);
end comparador;

architecture Behavioral of comparador is
signal datau: unsigned (Nbit-1 downto 0);
signal p_out1, out1, p_out2, out2, p_out3, out3: std_logic;

begin	

	sinc: process (clk, reset)
		begin
			if( reset ='1') then
			out1 <= '0';
			out2 <= '0';
			out3 <= '0';
			
			elsif (rising_edge(clk)) then
			out1 <= p_out1;
			out2 <= p_out2;
			out3 <= p_out3;
			
			end if;
		
		end process;

	comb: process (datau)
		begin
			if datau > End_Of_Screen then
			p_out1 <= '1';
			else
			p_out1 <= '0';
			end if;
			
			if (datau > Start_Of_Pulse and datau < End_Of_Pulse) then
			p_out2 <= '1';
			else
			p_out2 <= '0';
			end if;
			
			if datau = End_Of_Line then
			p_out3 <= '1';
			else
			p_out3 <= '0';
			end if;
		end process;
		
			O1 <= out1;
			O2 <= out2;
			O3 <= out3;
			datau <= unsigned (data);
			
end Behavioral;
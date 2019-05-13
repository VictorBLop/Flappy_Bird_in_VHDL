----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:30:41 10/31/2017 
-- Design Name: 
-- Module Name:    VGA_driver - Behavioral 
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

entity VGA_driver is
Port (
		button : in STD_LOGIC;
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		VS : out STD_LOGIC;
		HS : out STD_LOGIC;
		RED : out STD_LOGIC_VECTOR (2 downto 0);
		GRN : out STD_LOGIC_VECTOR (2 downto 0);
		BLUE : out STD_LOGIC_VECTOR (1 downto 0));
end VGA_driver;

architecture Behavioral of VGA_driver is

component contador is
	Generic (Nbit : integer :=10);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           resets : in  STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR(Nbit-1 downto 0));
end component;

component dibuja is
Generic(posX_inicial : unsigned(9 downto 0):="0001100100";
			posY_inicial : unsigned (9 downto 0):="0001100100";
			gravedad: integer:=1;
			Vy_inicial : integer:=0;
			Vy_salto_ini : integer := 10);
Port ( button: in std_logic;
		enable: in std_logic;
		clk: in std_logic;
		reset: in std_logic;
		eje_x : in STD_LOGIC_VECTOR (9 downto 0);
		eje_y : in STD_LOGIC_VECTOR (9 downto 0);
		RED : out STD_LOGIC_VECTOR(2 downto 0);
		GRN : out STD_LOGIC_VECTOR(2 downto 0);
		BLUE : out STD_LOGIC_VECTOR(1 downto 0);
		px_col1: in std_logic_vector(9 downto 0);
		py_col1: in std_logic_vector(9 downto 0);
		px_col2: in std_logic_vector(9 downto 0);
		py_col2: in std_logic_vector(9 downto 0);
		px_col3: in std_logic_vector(9 downto 0);
		py_col3: in std_logic_vector(9 downto 0);
		choque: out std_logic;
		perdimos: in std_logic;
		direcc: out std_logic_vector(9 downto 0);
		data: in std_logic_vector(2 downto 0);
		o3v: in std_logic;
		ini: in std_logic);
end component;

COMPONENT Marciano IS
PORT (
	clka : IN STD_LOGIC;
	addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
	douta : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END COMPONENT;


component gen_color is
Port ( blank_h : in STD_LOGIC;
		 blank_v : in STD_LOGIC;
		 RED_in : in STD_LOGIC_VECTOR (2 downto 0);
		 GRN_in : in STD_LOGIC_VECTOR (2 downto 0);
		 BLUE_in : in STD_LOGIC_VECTOR (1 downto 0);
		 RED : out STD_LOGIC_VECTOR (2 downto 0);
		 GRN : out STD_LOGIC_VECTOR (2 downto 0);
		 BLUE : out STD_LOGIC_VECTOR (1 downto 0));
end component;

component frec_pixel is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_pixel : out  STD_LOGIC;
			  clk_b : out std_logic;
			  clk_col : out std_logic;
			  button: in std_logic;
			  choque: in std_logic;
			  perdimos: out std_logic;
			  inic: out std_logic);
end component;

component comparador is
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
end component;

component columna is
Generic(	posx_ini_col1: unsigned(9 downto 0);
			posx_ini_col2: unsigned(9 downto 0);
			posx_ini_col3: unsigned(9 downto 0));
Port(clk : in STD_LOGIC;
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
end component;


signal en1,en2, o1h, o3h, o1v, o3v, choque, para_juego, ini: std_logic; 
signal q1, q2:std_logic_vector(9 downto 0);
signal red1, grn1, data : std_logic_vector(2 downto 0);
signal blue1 : std_logic_vector(1 downto 0);
signal enable_pajaro, enable_columna: std_logic;
signal px_col1,py_col1,px_col2,py_col2,px_col3,py_col3, direcc: std_logic_vector (9 downto 0);

begin
en2 <= en1 and o3h;

	DIV_FREQ: frec_pixel 
		port map(clk, reset, en1, enable_pajaro ,enable_columna, button,choque,para_juego,ini);

	CONTH: contador 
		generic map(10)
		port map(clk,reset,en1,o3h,q1); --clk,reset,enable,resets,Q)
	
	CONTV: contador
		generic map(10)
		port map(clk, reset, en2, o3v, q2);
		
	COMPH: comparador
		generic map(10,639,655,751,799)
		port map(clk,reset,q1,o1h,HS,o3h);

	COMPV: comparador
		generic map(10,479,489,491,520)
		port map(clk,reset,q2,o1v,VS,o3v);
		
	DIBUJA1: dibuja 
	generic map("0001100100","0001100100",1,0,12)
	port map(button,enable_pajaro, clk ,reset,q1, q2, red1, grn1, blue1,px_col1,py_col1,px_col2,py_col2,px_col3,py_col3,choque,para_juego,direcc,data,o1v,ini);

	Marciano_down: Marciano
	PORT MAP (clk, direcc, data);
	
	GENERADOR_COLOR: gen_color port map(o1h, o1v, red1, grn1, blue1, RED, GRN, BLUE);
	
	COLUMNAS: columna
	generic map(to_unsigned(300,10),to_unsigned(520,10),to_unsigned(760,10))
	port map(clk,enable_columna,reset,px_col1,py_col1,px_col2,py_col2,px_col3,py_col3,para_juego,ini);

end Behavioral;
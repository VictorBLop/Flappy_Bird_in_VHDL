----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:27:52 10/31/2017 
-- Design Name: 
-- Module Name:    dibuja - Behavioral 
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

entity dibuja is
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
end dibuja;


architecture Behavioral of dibuja is

	signal ejex, ejey: unsigned (9 downto 0);
	
	signal posY, p_posY: unsigned(9 downto 0):="0001100100";
	
	signal Vy, p_Vy: integer range 0 to 31;
	
	type tipo_estado is (reposo, actualizar_posY, actualizar_Vy);	
	signal estado, p_estado: tipo_estado;
	
	
	type tipo_estado2 is (esperopulso, pulso, finpulso);	
	signal estado2, p_estado2: tipo_estado2;
	
	signal arriba, p_arriba, aux1, p_aux1 : std_logic;
	signal aux, p_aux, aux2, p_aux2: std_logic;
	signal posx_col1,posy_col1,posx_col2,posy_col2,posx_col3,posy_col3 : unsigned(9 downto 0);
	signal choq, p_choq, choque_columna, p_choque_columna: std_logic;
	signal dir, p_dir: unsigned(9 downto 0);
	
begin

		ejex <= unsigned (eje_x);
		ejey <= unsigned (eje_y);
		posx_col1<=unsigned (px_col1);
		posy_col1<=unsigned (py_col1);
		posx_col2<=unsigned (px_col2);
		posy_col2<=unsigned (py_col2);
		posx_col3<=unsigned (px_col3);
		posy_col3<=unsigned (py_col3);
		choque <= choq or choque_columna;
		direcc<=std_logic_vector(dir);

	dibuja: process(ejex, ejey, posY, posx_col1,posy_col1, posx_col2,posy_col2, posx_col3,posy_col3,dir,data,o3v,aux1,arriba)
	begin
		
				RED<="000"; GRN<="000"; BLUE<="00";
				
				p_dir<=dir;
				p_aux1<=aux1;
				
					if(o3v='1') then
						p_dir<=(others=>'0');
					end if;

			if (((ejex<posx_col1 and (ejex>posx_col1-32 or posx_col1<32)) and (ejey<posy_col1 or ejey>posy_col1+175) )or
			((ejex<posx_col2 and (ejex>posx_col2-32 or posx_col2<32)) and (ejey<posy_col2 or ejey>posy_col2+175)) or 
			((ejex<posx_col3 and (ejex>posx_col3-32 or posx_col3<32)) and (ejey<posy_col3 or ejey>posy_col3+175))) then
					
					RED<="001"; GRN<="101"; BLUE <="00";
					
					if ((ejex>posX_inicial and ejex<33+posX_inicial) and(ejey>posY and ejey<posY+33)) then		
						if(aux1='0')then
							p_aux1<='1';
							p_dir<=dir+1;
						else
						p_aux1<='0';
						end if;
					end if;
							
			elsif ((ejex>posX_inicial and ejex<33+posX_inicial) and(ejey>posY and ejey<posY+33)) then
			
					RED(0)<=data(2); GRN(0)<=data(1); BLUE(0)<=data(0);
					RED(1)<=data(2); GRN(1)<=data(1); BLUE(1)<=data(0);
					RED(2)<=data(2); GRN(2)<=data(1);
					
					if(aux1='0')then
						p_aux1<='1';
						p_dir<=dir+1;
					else
						p_aux1<='0';
					end if;
					
									
					if((data="000") or (arriba='0' and dir>648)) then
						RED<="000"; GRN<="000"; BLUE<="00";
					end if;
					
			end if;
			

	end process;
	
	sinc: process(clk,reset)
	begin
		if (reset = '1') then
			posY <= posY_inicial;
			Vy <= Vy_inicial;
			estado <= reposo;
			estado2 <= esperopulso;
			arriba <= '0';
			aux<='0';
			aux2<='0';
			choq <= '0';
			choque_columna <= '0';
			dir<=(others=>'0');
			aux<='0';
			
		elsif (rising_edge(clk)) then
			posY <= p_posY;
			estado <= p_estado;
			estado2 <= p_estado2;
			Vy <= p_Vy;
			arriba <= p_arriba;
			aux<=p_aux;
			aux2<=p_aux2;
			choq <= p_choq;
			choque_columna <= p_choque_columna;
			dir<=p_dir;
			aux1<=p_aux1;
			
		end if;
	end process;
		
	-----------Máquina de estados para actualizar posicion y velocidad-------------
	
	maquina_de_estados: process(ini,estado, enable, Vy, posY, button, arriba,aux,aux2,choq,perdimos,ejex,ejey,posx_col1,posy_col1,posx_col2,posy_col2,posx_col3,posy_col3)
	begin
	
		p_estado <= estado;
		p_posY <= posY;
		p_Vy <= Vy;
		p_arriba <= arriba;
		p_aux<=aux;
		p_choq <= '0';
		p_choque_columna <= '0';
		
		case estado is
			
			when reposo =>
				if (enable='1' and aux='0') then
					p_estado <= actualizar_posY;
					p_aux<='1';
				end if;
				
			when actualizar_posY =>
			if(perdimos='1') then
				p_posY <= posY + Vy;
				if(posY+Vy>500) then
					p_posY<=to_unsigned(500,10);
				end if;
			elsif(ini='1')then
				p_posY<=posY_inicial;
			elsif (arriba = '1') then
				p_posY <= posY - Vy;
				if (posY + Vy > 550) then
					p_posY <= to_unsigned(0,10);
					p_choq <= '1';
				end if;
			else
				p_posY <= posY + Vy;
				if (posY + Vy > 450)then
					p_posY <= to_unsigned(450,10);
					p_choq <= '1';
				end if;
			end if;
				p_estado <= actualizar_Vy;
			
			when actualizar_Vy =>
			if(perdimos='1') then
				p_Vy <= Vy + gravedad;
				if Vy > 18 then
					p_Vy <= Vy;
				end if;	
			elsif(ini='1')then
				p_Vy<=Vy_inicial;
			elsif (arriba = '1') then
				p_Vy <= Vy - gravedad;
			else
				p_Vy <= Vy + gravedad;
				if Vy > 18 then
					p_Vy <= Vy;
				end if;
			end if;
			p_estado <= reposo;
							
			end case;
			

				--PULSO DEL BOTON
		if (aux2='1') then
			p_arriba <= '1';
			p_Vy <= Vy_salto_ini;
			
		elsif (Vy=0) then
			p_arriba <= '0';
		
		end if;
		
		if(enable='0') then
			p_aux<='0';
		end if;
		
			--Choque con la columna
	
		if(((ejex>posX_inicial and ejex<32+posX_inicial) and(ejey>posY and ejey<posY+32))and(((ejex<posx_col1 and (ejex>posx_col1-32 or posx_col1<32)) and (ejey<posy_col1 or ejey>posy_col1+175) )or
			((ejex<posx_col2 and (ejex>posx_col2-32 or posx_col2<32)) and (ejey<posy_col2 or ejey>posy_col2+175)) or 
			((ejex<posx_col3 and (ejex>posx_col3-32 or posx_col3<32)) and (ejey<posy_col3 or ejey>posy_col3+175)))) then
			p_choque_columna<='1';
			
		end if;	
		
	end process;
	
	---Maquina de estados => Pulsación de botón----
	
	pulso_boton : process(button, button, aux2, estado2)
		
		begin
		
		p_estado2 <= estado2;
		p_aux2 <= aux2;
		
			case estado2 is
			
			when esperopulso=>
				if(button='1') then	
					p_estado2<=pulso;
					p_aux2<='0';
				end if;
				
			when pulso=>
				p_estado2 <= finpulso;
					p_aux2<='1';
				
			when finpulso=>
			p_aux2<='0';
				if(button='0') then	
					p_estado2<=esperopulso;
				end if;
					
			end case;
			
		
			
		end process;
				
			
			
end Behavioral;

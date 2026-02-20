----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/04/2021 03:13:14 PM
-- Design Name: 
-- Module Name: FileWriter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FileWriter is
	GENERIC 
		(
			G_data_width 			: INTEGER := 2;
			G_half_width 			: INTEGER := 1; --this parameter is equal to G_data_width/2;
			real_file_name_addr 	: STRING  := "NOTHING";
			imag_file_name_addr 	: STRING  := "NOTHING"
		);
	PORT 
		(
			i_Clk   				: IN  STD_LOGIC;
			i_Reset 				: IN  STD_LOGIC;
			i_ax_1_data_tdata   	: IN  STD_LOGIC_VECTOR ( (G_data_width - 1) DOWNTO 0 );
			i_ax_1_data_tvalid  	: IN  STD_LOGIC
	
		);
end FileWriter;

architecture Behavioral of FileWriter is
	
	function to_string ( a: std_logic_vector) return string is
		variable b : string (1 to a'length) := (others => NUL);
		variable stri : integer := 1; 
		begin
			for i in a'range loop
				b(stri) := std_logic'image(a(i))(2);
				stri := stri+1;
			end loop;
		return b;
	end function;
	
begin

READER_PROCESS : PROCESS ( i_Clk ) IS 

	-- FILE NAME 
		file f_din_data_real   : text open write_mode is real_file_name_addr;
		file f_din_data_imag   : text open write_mode is imag_file_name_addr;
	
	-- LINE DECLERATION 
		Variable v_oline_data_real: LINE;  
		Variable v_oline_data_imag: LINE;  
		
	-- INTEGER DECLERATION 
		Variable v_str_data_real	: STRING( 1 TO G_half_width );
		Variable v_str_data_imag	: STRING( 1 TO G_half_width );

BEGIN 
	if rising_edge ( i_Clk ) then 
		if i_Reset = '0' then 

			if i_ax_1_data_tvalid = '1' then 
			
				-- TYPE CONVERSION 
				v_str_data_real		:=	TO_STRING(i_ax_1_data_tdata( (G_half_width-1) DOWNTO 0 ));
				v_str_data_imag    	:=  TO_STRING(i_ax_1_data_tdata( (G_data_width-1) DOWNTO G_half_width));
				
				-- WRITE  
				write(v_oline_data_real, v_str_data_real);
				write(v_oline_data_imag, v_str_data_imag );
				
				-- WRITE LINE
				writeline(f_din_data_real ,v_oline_data_real);
				writeline(f_din_data_imag ,v_oline_data_imag);
				
			end if;
			
		end if;
	end if;
END PROCESS;

end Behavioral;

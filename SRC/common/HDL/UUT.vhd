----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2025 09:20:41 PM
-- Design Name: 
-- Module Name: UUT - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UUT is
	PORT 
		(
			i_Clk						: IN  STD_LOGIC;
			i_Reset 						: IN  STD_LOGIC;
			i_data_tdata 					: IN  STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			i_data_tvalid 				: IN  STD_LOGIC;
			o_data_tdata 					: OUT STD_LOGIC_VECTOR( 16 DOWNTO 0 );
			o_data_tvalid 				: OUT STD_LOGIC 
			
		);
		attribute direct_reset : string;
		attribute direct_reset of i_Reset: signal is "yes";
end UUT;

architecture Behavioral of UUT is

-- =====================================================================================================
-- SIGNAL DCLERATION 
-- =====================================================================================================
	-- INPUT_REGISTER_PROCESS
		Signal s_real_tdata 	: SIGNED( 16 DOWNTO 0 ) := ( Others => '0' );
		Signal s_imag_tdata 	: SIGNED( 16 DOWNTO 0 ) := ( Others => '0' );
		Signal s_reim_tvalid 	: STD_LOGIC := '0';

begin


INPUT_REGISTER_PROCESS : PROCESS (i_Clk) IS 
BEGIN 
	if rising_Edge (i_Clk) then 
		if i_Reset = '1' then 
			
			s_real_tdata 		<= ( Others => '0' );			
			s_imag_tdata 		<= ( Others => '0' );		
			s_reim_tvalid 	<= '0';			
			
		else 
			
			s_real_tdata( 15 DOWNTO 0 ) 	<= SIGNED(i_data_tdata( 15 DOWNTO 0 ));
			s_real_tdata(16)				<= i_data_tdata(15);
			s_imag_tdata( 15 DOWNTO 0 ) 	<= SIGNED(i_data_tdata( 31 DOWNTO 16));
			s_imag_tdata(16)				<= i_data_tdata(31); 
			s_reim_tvalid					<= i_data_tvalid;
			
		end if;
	end if;
END PROCESS INPUT_REGISTER_PROCESS;

OUTPUT_REGISTER_PROCESS : PROCESS (i_Clk) IS 
BEGIN 
	if rising_Edge (i_Clk) then 
		if i_Reset = '1' then 
			
			o_data_tdata 		<= ( Others => '0' );
			o_data_tvalid 	<= '0';
			
		else 
			
			o_data_tdata 		<= STD_LOGIC_VECTOR(s_imag_tdata + s_real_tdata);
			o_data_tvalid 	<= s_reim_tvalid;
			
		end if;
	end if;
END PROCESS OUTPUT_REGISTER_PROCESS;




end Behavioral;

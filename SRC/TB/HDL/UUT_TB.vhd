----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2025 08:45:29 PM
-- Design Name: 
-- Module Name: UUT_TB - Behavioral
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

library WORK;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.fixPkg.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UUT_TB is
--  Port ( );
end UUT_TB;

architecture Behavioral of UUT_TB is


-- ==========================================================================================
-- TYPE DECLERATION 
-- ==========================================================================================
	TYPE STR_ARRAY_RD IS ARRAY ( NATURAL RANGE <> ) OF STRING( 1 TO 11 );
	TYPE STD_ARRAY_16 IS ARRAY ( NATURAL RANGE <> ) OF STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	CONSTANT DATA_WIDTH : NATURAL := 32;

-- ==========================================================================================
-- SIGNAL DECLERATION 
-- ==========================================================================================
	-- CLOCK AND RESET 
		Signal s_Clk						: STD_LOGIC := '0';
		Signal s_Reset					: STD_LOGIC := '0';

	-- Inst_FileReaderv_1
		Signal s_rd_tdata 				: STD_LOGIC_VECTOR( DATA_WIDTH - 1 DOWNTO 0 ) := ( Others => '0' );
		Signal s_rd_tvalid 				: STD_LOGIC := '0';
	
	-- Inst_Stream2Burst
		Signal s_burst_tdata 				: STD_LOGIC_VECTOR( DATA_WIDTH - 1 DOWNTO 0 ) := ( Others => '0' );
		Signal s_burst_tvalid 			: STD_LOGIC := '0';
		Signal s_burst_tlast	 			: STD_LOGIC := '0';

	-- CHANGE_FIX_POINT_PROCESS
		Signal s_converted_tdata			: STD_LOGIC_VECTOR( 31 DOWNTO 0 ) := ( Others => '0' );
		Signal s_converted_tvalid			: STD_LOGIC := '0';
		Signal s_converted_tlast			: STD_LOGIC := '0';

begin

	Inst_FileReaderv : Entity Work.FileReaderv_1 
		GENERIC MAP 
			(
				G_interval					=> 20,
				G_data_width 				=> DATA_WIDTH,
				G_half_width 				=> DATA_WIDTH / 2,
				G_data_len	 				=> 6*1024, 
				real_file_name_addr 			=> "data_real.txt",
				imag_file_name_addr 			=> "data_imag.txt"
			)
		PORT MAP 
			(
				i_Clk   						=> s_Clk,
				i_Reset 						=> s_Reset,
				o_ax_1_data_tdata   			=> s_rd_tdata,
				o_ax_1_data_tvalid  			=> s_rd_tvalid		
			);
	
	Inst_Stream2Burst : Entity Work.Stream2Burst 
		GENERIC MAP 
			(
				DATA_WIDTH 					=> DATA_WIDTH,
				BURST_LEN					=> 1024
			)
		PORT MAP 
			(
				i_clk						=> s_Clk,
				i_Reset 						=> s_Reset,
				i_stream_tdata 				=> s_rd_tdata,
				i_stream_tvalid 				=> s_rd_tvalid,
				o_burst_tdata 				=> s_burst_tdata,
				o_burst_tvalid 				=> s_burst_tvalid,
				o_burst_tlast 				=> s_burst_tlast	
			);

	Inst_UUT : Entity Work.UUT 
		PORT MAP 
			(
				i_Clk						=> s_Clk,
				i_Reset 						=> s_Reset,
				i_data_tdata 				=> s_burst_tdata,
				i_data_tvalid 				=> s_burst_tvalid,
				o_data_tdata 				=> OPEN,
				o_data_tvalid 				=> OPEN
				
			);

CHANGE_FIX_POINT_PROCESS : PROCESS (s_Clk) IS 
BEGIN 
	if rising_Edge (s_Clk) then 
		
		s_converted_tdata		<= convert(s_burst_tdata( 15 DOWNTO 0 ), 16, 11, 32, 14);
		s_converted_tvalid	<= s_burst_tvalid;
		s_converted_tlast		<= s_burst_tlast;
		
	end if; 
END PROCESS CHANGE_FIX_POINT_PROCESS;
		
	
-- GENERATE CLOCK AND RESET 
	s_Clk 	<= NOT s_Clk AFTER 5ns;
	s_Reset	<= '1',  '0' AFTER 50ns;

end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/05/2026 12:40:59 PM
-- Design Name: 
-- Module Name: Sample_TB - Behavioral
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
use WORK.fixPkg.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Sample_TB is
--  Port ( );
end Sample_TB;

architecture Behavioral of Sample_TB is

-- ========================================================================================
-- TYPE AND CONSTANT DECLERATION 
-- ========================================================================================
	
	CONSTANT DATA_WIDTH := INTEGER RANGE 0 TO 127 := 32;
	CONSTANT II := 1;
	
-- ========================================================================================
-- SIGNAL DECLERATION 
-- ========================================================================================
	-- CLOCK AND RESET 
		Signal s_proc_clk				: STD_LOGIC := '0';
		Signal s_Reset				: STD_LOGIC := '0';
		
	-- Inst_FileReaderv_1
		Signal s_data_tdata 			: STD_LOGIC_VECTOR( DATA_WIDTH - 1 DOWNTO 0 ) := ( Others => '0' );
		Signal s_data_tvalid 			: STD_LOGIC := '0';
	
	-- Inst_Stream2Burst
		Signal s_Burst_tdata 			: STD_LOGIC_VECTOR( DATA_WIDTH - 1 DOWNTO 0 ) := ( Others => '0' );
		Signal s_burst_tvalid 		: STD_LOGIC := '0';
		Signal s_burst_tlast 			: STD_LOGIC := '0';
	
begin
	
	Inst_FileReaderv_1 : Entity Work.FileReaderv_1 
		GENERIC MAP 
			(
				G_interval				=> II,
				G_data_width 			=> DATA_WIDTH,
				G_half_width 			=> DATA_WIDTH / 2, 
				G_data_len	 			=> 655360, 
				real_file_name_addr 		=> "data_re.txt",
				imag_file_name_addr 		=> "data_im.txt"
			)
		PORT MAP 
			(
				i_Clk   					=> s_proc_clk,
				i_Reset 					=> s_Reset,
				o_ax_1_data_tdata   		=> s_data_tdata,
				o_ax_1_data_tvalid  		=> s_data_tvalid
			);
	
	Inst_Stream2Burst : Entity Work.Stream2Burst 
		GENERIC MAP 
			(
				DATA_WIDTH 				=> 32,
				BURST_LEN				=> 1024
			)
		PORT MAP 
			(
				i_clk					=> s_proc_clk,
				i_Reset 					=> s_Reset,
				i_stream_tdata 			=> s_data_tdata,
				i_stream_tvalid 			=> s_data_tvalid,
				o_burst_tdata 			=> s_Burst_tdata,
				o_burst_tvalid 			=> s_burst_tvalid,
				o_burst_tlast 			=> s_burst_tlast
			);

	s_proc_clk	<= NOT s_proc_clk AFTER 5ns;
	s_Reset	<= '1', '0' AFTER 500ns;
	

end Behavioral;

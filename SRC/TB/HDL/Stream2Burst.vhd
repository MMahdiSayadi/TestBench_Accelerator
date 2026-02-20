----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/31/2026 10:57:15 AM
-- Design Name: 
-- Module Name: Stream2Burst - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Stream2Burst is
	GENERIC 
		(
			DATA_WIDTH 		: NATURAL := 32;
			BURST_LEN		: NATURAL := 1024
		);
	PORT 
		(
			i_clk			: IN  STD_LOGIC;
			i_Reset 			: IN  STD_LOGIC;
			i_stream_tdata 	: IN  STD_LOGIC_VECTOR( DATA_WIDTH - 1 DOWNTO 0 );
			i_stream_tvalid 	: IN  STD_LOGIC;
			o_burst_tdata 	: OUT STD_LOGIC_VECTOR( DATA_WIDTH - 1 DOWNTO 0 ) := ( Others => '0' );
			o_burst_tvalid 	: OUT STD_LOGIC := '0';
			o_burst_tlast 	: OUT STD_LOGIC := '0'
		);
end Stream2Burst;

architecture Behavioral of Stream2Burst is
	
-- ===============================================================================
-- SIGNAL DECLERATION 	
-- ===============================================================================	
	-- Inst_SimFifo
		Signal s_fifo_tdata 			: STD_LOGIC_VECTOR( DATA_WIDTH - 1 DOWNTO 0 ) := ( Others => '0' );
		Signal s_fifo_tvalid 			: STD_LOGIC := '0';
		Signal s_rfifo_tvalid 		: STD_LOGIC := '0';
		Signal s_fifo_trden 			: STD_LOGIC := '0';
		Signal s_fifo_tcntr 			: NATURAL := 0;
		
	-- FIFO_READ_MNG_PROCESS
		Signal s_rd_cs 				: NATURAL := 0;
		Signal s_sample_cntr 			: NATURAL := 0;
	
begin

	Inst_SimFifo : Entity Work.SimFifo 
		GENERIC MAP 
			(
				FIFO_WIDTH				=> DATA_WIDTH,
				FIFO_DEPTH				=> BURST_LEN
			)
		PORT MAP 
			(
				i_Clk					=> i_clk,
				i_Reset 					=> i_Reset,
				din						=> i_stream_tdata,
				wren						=> i_stream_tvalid,
				rden						=> s_fifo_trden,
				dout						=> s_fifo_tdata,
				valid 					=> s_fifo_tvalid,
				tcntr 					=> s_fifo_tcntr
			);

FIFO_READ_MNG_PROCESS : PROCESS (i_clk) IS 
BEGIN 
	if rising_Edge (i_clk) then 
		if i_Reset = '1' then 
		
			s_rd_cs 		<=  0 ;
			s_fifo_trden <= '0';
			
		else 
			
			CASE s_rd_cs IS 
				WHEN 0 => 
					
					if s_fifo_tcntr = BURST_LEN then 
						s_rd_cs <= 1;
					end if; 
					
					s_fifo_trden 	<= '0';
					s_sample_cntr 	<=  0 ;
				WHEN 1 => 
					
					if s_sample_cntr < BURST_LEN - 1 then 
						s_sample_cntr <= s_sample_cntr + 1;
					else 
						s_rd_cs 		<=  0 ;
					end if; 
					s_fifo_trden <= '1';

				WHEN OTHERS => 
					NULL;
			END CASE;
			
		end if; 
	end if; 
END PROCESS FIFO_READ_MNG_PROCESS;

OUTPUT_REGISTER_PROCESS : PROCESS (i_clk) IS 
BEGIN 
	if rising_Edge (i_clk) then 
		
		o_burst_tdata 	<= s_fifo_tdata;
		o_burst_tvalid 	<= s_fifo_tvalid;
		s_rfifo_tvalid 	<= s_fifo_tvalid;	

	end if; 
END PROCESS OUTPUT_REGISTER_PROCESS;
o_burst_tlast <= s_rfifo_tvalid AND NOT s_fifo_tvalid;




end Behavioral;

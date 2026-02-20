----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/30/2026 09:37:21 AM
-- Design Name: 
-- Module Name: SimFifo - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SimFifo is
	GENERIC 
		(
			FIFO_WIDTH		: NATURAL := 32;
			FIFO_DEPTH		: NATURAL := 1024
		);
	PORT 
		(
			i_Clk			: IN  STD_LOGIC;
			i_Reset 			: IN  STD_LOGIC;
			din				: IN  STD_LOGIC_VECTOR( FIFO_WIDTH - 1 DOWNTO 0 );
			wren				: IN  STD_LOGIC;
			rden				: IN  STD_LOGIC;
			dout				: OUT STD_LOGIC_VECTOR( FIFO_WIDTH - 1 DOWNTO 0 ) := ( Others => '0' );
			valid 			: OUT STD_LOGIC := '0' ;
			tcntr 			: OUT NATURAL := 0
		);
end SimFifo;

architecture Behavioral of SimFifo is

-- ==============================================================================
-- TYPE AND CONSTANT DECLERATION 
-- ==============================================================================
	TYPE STD_ARRAY IS ARRAY ( NATURAL RANGE <> ) OF STD_LOGIC_VECTOR( FIFO_WIDTH - 1 DOWNTO 0 );
	
	
-- ==============================================================================
-- SIGNAL DECLERATION 
-- ==============================================================================
	-- FIFO_HANDLER_PROCESS
		Signal s_SimFifo		: STD_ARRAY( 0 TO FIFO_DEPTH + 3 ) := ( Others => ( Others => '0' ) );
		Signal s_dif_tcntr 	: INTEGER RANGE -FIFO_DEPTH TO FIFO_DEPTH := 0;
		Signal s_fifo_tcntr 	: NATURAL := 0;
		Signal s_wridx 		: NATURAL := 0;
		Signal s_rdidx		: NATURAL := 0;
		Signal s_fifoFlag 	: STD_LOGIC_VECTOR( 1 DOWNTO 0 ) := ( Others => '0' );
		Signal s_fifocs 		: NATURAL := 0;


begin


FIFO_HANDLER_PROCESS : PROCESS (i_Clk) IS 
BEGIN 
	if rising_Edge (i_Clk) then 
		if i_Reset = '1' then 
			
		else

			CASE s_fifocs IS 
				WHEN 0 => 
					
					if wren = '1' then 
						if s_wridx < FIFO_DEPTH then 
							s_wridx <= s_wridx + 1;
						else
							s_wridx <= 0;
						end if;
						s_SimFifo(s_wridx) <= din;
					end if; 
					
					if rden = '1' then 
						if s_rdidx < FIFO_DEPTH then 
							s_rdidx <= s_rdidx + 1;
						else
							s_rdidx <= 0;
						end if;
						dout 	<= s_SimFifo(s_rdidx);
						valid	<= '1';
					else 
						valid	<= '0';
					end if; 

				WHEN 1 =>
					
					if wren = '1' then 
						if s_wridx < FIFO_DEPTH then 
							s_wridx <= s_wridx + 1;
						else
							s_wridx <= 0;
						end if;
						s_SimFifo(s_wridx) <= din;
					end if; 
					valid	<= '0';
					
				WHEN 2 =>
					
					if wren = '1' then 
						if s_wridx < FIFO_DEPTH then 
							s_wridx <= s_wridx + 1;
						else
							s_wridx <= 0;
						end if;
						s_SimFifo(s_wridx) <= din;
					end if; 
					valid	<= '0';
					
				WHEN 3 =>
					
					if wren = '1' then 
						if s_wridx < FIFO_DEPTH then 
							s_wridx <= s_wridx + 1;
						else
							s_wridx <= 0;
						end if;
						s_SimFifo(s_wridx) <= din;
					end if; 
					
				WHEN 4 => 
					
					if rden = '1' then 
						if s_rdidx < FIFO_DEPTH then 
							s_rdidx <= s_rdidx + 1;
						else
							s_rdidx <= 0;
						end if;
						dout 	<= s_SimFifo(s_rdidx);
						valid	<= '1';
					else 
						valid	<= '0';
					end if; 
					
				WHEN OTHERS => 
					NULL;
			END CASE;
			
		end if; 
	end if; 
END PROCESS FIFO_HANDLER_PROCESS;


CUNCURENT_CASE_MNG : PROCESS (s_dif_tcntr, s_fifo_tcntr, s_wridx, s_rdidx, s_fifocs) IS 
BEGIN 

	if s_fifo_tcntr /= 0 AND s_fifo_tcntr /= FIFO_DEPTH then 
		s_fifocs <= 0;
	elsif s_fifo_tcntr = 0 AND s_wridx = 0 then -- fifo is empty 
		s_fifocs <= 1;
	elsif s_fifo_tcntr = 0 AND s_wridx /= 0 AND s_wridx /= FIFO_DEPTH then -- fifo empty 
		s_fifocs <= 2;
	elsif s_fifo_tcntr = 0 AND s_wridx = FIFO_DEPTH then -- fifo is full 
		s_fifocs <= 3;
	elsif s_fifo_tcntr = FIFO_DEPTH then -- fifo is full 
		s_fifocs <= 4;
	end if;
	
	if s_dif_tcntr >= 0 then 
		tcntr		<= s_dif_tcntr;
		s_fifo_tcntr	<= s_dif_tcntr;
	else 
		tcntr		<= 1 + FIFO_DEPTH + s_dif_tcntr;
		s_fifo_tcntr	<= 1 + FIFO_DEPTH + s_dif_tcntr;
	end if; 

END PROCESS CUNCURENT_CASE_MNG;

s_fifoFlag 	<= wren & rden;
s_dif_tcntr <= s_wridx - s_rdidx;




end Behavioral;

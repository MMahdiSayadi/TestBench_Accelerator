library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

PACKAGE fixPkg IS 

Function convert 
	(
		Signal X  	: std_logic_vector;
		Constant w1 	: natural;
		Constant f1 	: natural;
		Constant w2 	: natural;
		Constant f2 	: natural
	) 
Return std_logic_vector;

END PACKAGE fixPkg;

PACKAGE BODY fixPkg IS 
	
	
	
function convert
	(
		Signal x  	: std_logic_vector;
		Constant w1 	: natural;
		Constant f1 	: natural;
		Constant w2 	: natural;
		Constant f2 	: natural
	) 
return std_logic_vector is

	variable y : std_logic_vector( w2 - 1 downto 0 ) := ( Others => '0' );
	variable i1 : natural := 0;
	variable i2 : natural := 0;
	
begin
	
	-- calculate integer parts 
	i1 := w1 - f1;
	i2 := w2 - f2;
	
	if i1 > i2 AND f1 > f2 then 
		y( w2 - 1 DOWNTO f2) := x( f1 + i2 - 1 DOWNTO f1 );
		y( f2 - 1 DOWNTO 0 ) := x( f1 - 1 DOWNTO f1 - f2 );
	end if;
	
	if i1 > i2 AND f1 < f2 then 
		y( w2 - 1 DOWNTO f2) := x( f1 + i2 - 1 DOWNTO f1 );
		y( f2 - 1 DOWNTO f2 - f1 ) := x( f1 - 1 DOWNTO 0 );
	end if;
	
	if i1 < i2 AND f1 > f2 then 
		y( w2 - 1 DOWNTO w2 - i2 + i1 ) := ( Others => x(w1 - 1) );
		y( w2 - i2 + i1 - 1 DOWNTO f2 ) := x( w1 - 1 DOWNTO f1 );
		y( f2 - 1 DOWNTO 0 ) := x( f1 - 1 DOWNTO f1 - f2 );
	end if;
	
	if i1 < i2 AND f1 < f2 then 
		y( w2 - 1 DOWNTO w2 - i2 + i1 ) := ( Others => x(w1 - 1) );
		y( w2 - i2 + i1 - 1 DOWNTO f2 ) := x( w1 - 1 DOWNTO f1 );
		y( f2 - 1 DOWNTO f2 - f1 ) := x( f1 - 1 DOWNTO 0 );
	end if;
	
	if i1 = i2 AND f1 > f2 then 
		y( w2 - 1 DOWNTO f2 ) := x( w1 - 1 DOWNTO f1 );
		y( f2 - 1 DOWNTO 0  ) := x( f1 - 1 DOWNTO f1 - f2 );
	end if;
	
	if i1 = i2 AND f1 < f2 then 
		y( w2 - 1 DOWNTO f2 ) := x( w1 - 1 DOWNTO f1 );
		y( f2 - 1 DOWNTO f1 - f2  ) := x( f1 - 1 DOWNTO 0 );
	end if;
	
	return y;
end function;	

END PACKAGE BODY fixPkg;



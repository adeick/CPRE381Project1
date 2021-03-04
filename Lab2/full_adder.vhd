-------------------------------------------------------------------------
-- John Brose
-------------------------------------------------------------------------


-- full_adder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 3-input full 
-- adder with 2 output bits.
--
--
-- NOTES:
-- 2/8/21 by JB::Design created.
-------------------------------------------------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
-- entity
entity full_adder is
	port(i_A	: in std_logic;
	     i_B	: in std_logic;
	     i_C	: in std_logic;
	     o_S	: out std_logic;
	     o_C	: out std_logic);
end full_adder;
-- architecture
architecture structural of full_adder is

	-- AND gate
	component andg2 is
	  port( i_A,i_B : in std_logic;
		o_F	: out std_logic);
	end component;

	-- OR gate
	component org2 is
	  port( i_A,i_B : in std_logic;
		o_F	: out std_logic);
	end component;

	-- XOR gate
	component xorg2 is
	  port( i_A,i_B	: in std_logic;
		o_F	: out std_logic);
	end component;

	-- intermediate signal declaration
	signal s_XOR,s_A1,s_A2 : std_logic;

begin
	x1: xorg2
	  port map(i_A => i_A,
		   i_B => i_B,
		   o_F => s_XOR);

	x2: andg2
	  port map(i_A => s_XOR,
		   i_B => i_C,
		   o_F => s_A1);

	x3: andg2
	  port map(i_A => i_A,
		   i_B => i_B,
		   o_F => s_A2);

	x4: xorg2
	  port map(i_A => s_XOR,
		   i_B => i_C,
		   o_F => o_S);

	x5: org2
	  port map(i_A => s_A1,
		   i_B => s_A2,
		   o_F => o_C);
end structural;
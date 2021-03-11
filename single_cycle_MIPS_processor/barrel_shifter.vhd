-------------------------------------------------------------------------
-- John Brose
-------------------------------------------------------------------------


-- barrel_shifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the barrel 
-- shifter for ALU in the MIPS single cycle processor
--
-- The barrel shifter supports 2^5-1 shifts left or right logical or
-- arithmetic
--
-- NOTES:
-- 03/11/21 by JB::Design created.
-------------------------------------------------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
-- entity
entity barrel_shifter is
	port(i_data		: in std_logic_vector(31 downto0);
	     i_shamt  	  	: in std_logic_vector(4 downto 0);
	     i_shft_dir	  	: in std_logic; -- 0 left, 1 right
	     i_shft_type	: in std_logic; -- 0 logical, 1 arithmetic
	     o_data     : out std_logic_vector(31 downto 0));
end barrel_shifter;

-- architecture
architecture dataflow of barrel_shifter is

  component mux2t1_N is
  generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
  end component;

  signal buf : std_logic_vector(31 downto 0);

begin
  buf <= 
  x1: mux2t1_N
	generic map(N=>32)
	port map(i_S  => i_shamt(0),
		 i_D0 => i_data,
		 i_D1 => ,
		 o_O  => );

end dataflow;
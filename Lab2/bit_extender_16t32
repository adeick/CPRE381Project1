-------------------------------------------------------------------------
-- John Brose
-------------------------------------------------------------------------


-- mux32t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a N bit bus 
-- 32-input mux 
--
--
-- NOTES:
-- 2/18/21 by JB::Design created.
-------------------------------------------------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
-- entity
package STD_LOGIC_MATRIX is
	type std_logic_matrix is array (integer range <>) of std_logic_vector(31 downto 0);
end package;
use work.STD_LOGIC_MATRIX.all;

library IEEE;
use IEEE.std_logic_1164.all;

entity mux32t1_N is
  --generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic_vector(4 downto 0);
       i_D          : in std_logic_matrix(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
end mux32t1_N;

-- architecture
architecture structural of mux32t1_N is

  component mux32t1 is
	port(i_D    	  : in std_logic_vector(31 downto 0);
	     i_S	  : in std_logic_vector(4 downto 0);
	     o_O	  : out std_logic);
  end component;

begin

  -- Instantiate N dff instances.
  G_NBit_MUX32t1: for i in 0 to 31 generate
    MUX32t1_N: mux32t1 port map(
	      i_S	=> i_S,   
	      i_D(0)	=> i_D(0)(i),
	      i_D(1)	=> i_D(1)(i),
	      i_D(2)	=> i_D(2)(i),
	      i_D(3)	=> i_D(3)(i),
	      i_D(4)	=> i_D(4)(i),
	      i_D(5)	=> i_D(5)(i),
	      i_D(6)	=> i_D(6)(i),
	      i_D(7)	=> i_D(7)(i),
	      i_D(8)	=> i_D(8)(i),
	      i_D(9)	=> i_D(9)(i),
	      i_D(10)	=> i_D(10)(i),
	      i_D(11)	=> i_D(11)(i),
	      i_D(12)	=> i_D(12)(i),
	      i_D(13)	=> i_D(13)(i),
	      i_D(14)	=> i_D(14)(i),
	      i_D(15)	=> i_D(15)(i),
	      i_D(16)	=> i_D(16)(i),
	      i_D(17)	=> i_D(17)(i),
	      i_D(18)	=> i_D(18)(i),
	      i_D(19)	=> i_D(19)(i),
	      i_D(20)	=> i_D(20)(i),
	      i_D(21)	=> i_D(21)(i),
	      i_D(22)	=> i_D(22)(i),
	      i_D(23)	=> i_D(23)(i),
	      i_D(24)	=> i_D(24)(i),
	      i_D(25)	=> i_D(25)(i),
	      i_D(26)	=> i_D(26)(i),
	      i_D(27)	=> i_D(27)(i),
	      i_D(28)	=> i_D(28)(i),
	      i_D(29)	=> i_D(29)(i),
	      i_D(30)	=> i_D(30)(i),
	      i_D(31)	=> i_D(31)(i),

              o_O       => o_O(i));
  end generate G_NBit_MUX32t1;
  
end structural;
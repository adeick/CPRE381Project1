-------------------------------------------------------------------------
-- John Brose
-------------------------------------------------------------------------


-- adder_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N bit ripple
-- carry adder
--
-- NOTES:
-- 2/8/21 by JB::Design created.
-------------------------------------------------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity adder_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B	    : in std_logic_vector(N-1 downto 0);
       i_C	    : in std_logic;
       o_S	    : out std_logic_vector(N-1 downto 0);
       o_C          : out std_logic);
end adder_N;

-- architecture
architecture structural of adder_N is

  component full_adder is
	port(i_A	: in std_logic;
	     i_B	: in std_logic;
	     i_C	: in std_logic;
	     o_S	: out std_logic;
	     o_C	: out std_logic);
  end component;

  signal s_C : std_logic_vector(N-2 downto 0);

begin

  -- Instantiate N full_adder instances.
  -- special case where i_C is inputed from outside
  x1: full_adder
     port map(i_A => i_A(0),
	      i_B => i_B(0),
	      i_C => i_C,
	      o_S => o_S(0),
	      o_C => s_C(0));

  -- middle area of full adders
  G_NBit_ADDER: for i in 1 to N-2 generate
    ADDERI: full_adder port map(
              i_A     => i_A(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_B     => i_B(i),
              i_C     => s_C(i-1),
              o_S     => o_S(i),  
              o_C     => s_C(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_ADDER;

  -- special case where o_C is outputed to the output
  x2: full_adder
     port map(i_A => i_A(N-1),
	      i_B => i_B(N-1),
	      i_C => s_C(N-2),
	      o_S => o_S(N-1),
	      o_C => o_C);
  
end structural;
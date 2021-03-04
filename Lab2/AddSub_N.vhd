-------------------------------------------------------------------------
-- John Brose
-------------------------------------------------------------------------


-- AddSub_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N bit adder
-- -subtractor based off of select signal nAdd_Sub
--
-- NOTES:
-- 2/8/21 by JB::Design created.
-------------------------------------------------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity AddSub_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A          : in std_logic_vector(N-1 downto 0);
       i_B	    : in std_logic_vector(N-1 downto 0);
       i_nAdd_Sub   : in std_logic;
       o_S	    : out std_logic_vector(N-1 downto 0);
       o_C          : out std_logic);
end AddSub_N;

-- architecture
architecture structural of AddSub_N is

  component adder_N is
  	generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  	port(i_A          : in std_logic_vector(N-1 downto 0);
       	     i_B	  : in std_logic_vector(N-1 downto 0);
             i_C	  : in std_logic;
             o_S	  : out std_logic_vector(N-1 downto 0);
             o_C          : out std_logic);
  end component;

  component ones_comp_N is
  	generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  	port(i_A          : in std_logic_vector(N-1 downto 0);
 	     o_F          : out std_logic_vector(N-1 downto 0));
  end component;

  component mux2t1_N is
	generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  	port(i_S          : in std_logic;
             i_D0         : in std_logic_vector(N-1 downto 0);
             i_D1         : in std_logic_vector(N-1 downto 0);
             o_O          : out std_logic_vector(N-1 downto 0));
  end component;

  signal s_Bnot : std_logic_vector(N-1 downto 0);
  signal s_B	: std_logic_vector(N-1 downto 0);

begin


  x1: ones_comp_N
     generic map(N=>N)
     port map(i_A => i_B,
	      o_F => s_Bnot);

  x2: mux2t1_N
     generic map(N=>N)
     port map(i_S  => i_nAdd_Sub,
	      i_D0 => i_B,
	      i_D1 => s_Bnot,
	      o_O => s_B);

  x3: adder_N
     generic map(N=>N)
     port map(i_A => i_A,
	      i_B => s_B,
	      i_C => i_nAdd_Sub,
	      o_S => o_S,
	      o_C => o_C);
  
end structural;
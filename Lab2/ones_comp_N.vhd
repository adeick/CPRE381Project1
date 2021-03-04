-------------------------------------------------------------------------
-- John Brose
-------------------------------------------------------------------------


-- ones_comp.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a ones complement
-- structure
--
-- NOTES:
-- 2/8/21 by JB::Design created.
-------------------------------------------------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity ones_comp_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));
end ones_comp_N;

-- architecture
architecture structural of ones_comp_N is

  component invg is
    port(i_A                  : in std_logic;
         o_F                  : out std_logic);
  end component;

begin

  -- Instantiate N inverters instances.
  G_NBit_ONES_COMP: for i in 0 to N-1 generate
    ONESCOMPI: invg port map(
              i_A     => i_A(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
              o_F      => o_F(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_ONES_COMP;
  
end structural;
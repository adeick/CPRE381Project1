-------------------------------------------------------------------------
-- John Brose
-------------------------------------------------------------------------
-- bit_extender_16t32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 16 to 32 bit
-- extender signed or zero extended based on select signal
--
--
-- NOTES:
-- 2/22/21 by JB::Design created.
-------------------------------------------------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
-- entity

library IEEE;
use IEEE.std_logic_1164.all;

entity bit_extender_16t32 is
  port(i_SignSel    : in std_logic;
       i_D          : in std_logic_vector(15 downto 0);
       o_D          : out std_logic_vector(31 downto 0));
end bit_extender_16t32;

-- architecture
architecture structural of bit_extender_16t32 is
  component mux32t1 is
	port(i_D    	  : in std_logic_vector(31 downto 0);
	     i_S	  : in std_logic_vector(4 downto 0);
	     o_O	  : out std_logic);
  end component;

begin
  with i_SignSel select o_D <=
    (15 downto 0 => i_D, others=>'0')     when '0',
    (15 downto 0 => i_D, others=>i_D(15)) when '1',
    X"00000000" when others;
  
end structural;
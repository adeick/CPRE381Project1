-------------------------------------------------------------------------
-- John Brose
-- Student Iowa State University
-------------------------------------------------------------------------
-- tb_mux32t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a 5 to 32 decoder
--
--              
-- 02/11/2021 by JB::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use IEEE.numeric_std.all;	-- For to_usnigned
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_mux32t1 is
  generic(gCLK_HPER   : time := 50 ns);
end tb_mux32t1;

architecture behavior of tb_mux32t1 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component mux32t1
	port(i_D    	  : in std_logic_vector(31 downto 0);
	     i_S	  : in std_logic_vector(4 downto 0);
	     o_O	  : out std_logic);
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK : std_logic := '0';

  signal s_D  : std_logic_vector(31 downto 0) := (others => '0');
  signal s_S  : std_logic_vector(4 downto 0) := (others => '0');
  signal s_O  : std_logic;

begin

  DUT: mux32t1 
  port map(i_S => s_S,
           i_D => s_D,
           o_O   => s_O);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin

    --test all values with enable at 1
    s_D <= X"F0F0F0F0";
    for i in 0 to 31 loop
      s_S   <= std_logic_vector(to_unsigned(i,s_S'length));
    wait for cCLK_PER; 
    end loop;
     

    wait;
  end process;
  
end behavior;
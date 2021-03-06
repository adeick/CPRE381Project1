-------------------------------------------------------------------------
-- John Brose
-- Student Iowa State University
-------------------------------------------------------------------------
-- tb_bit_extender_16t32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for 16 to 32
-- bit extender
--
-- 02/22/2021 by JB::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use IEEE.numeric_std.all;	-- For to_usnigned
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_bit_extender_16t32 is
  generic(gCLK_HPER   : time := 50 ns);
end tb_bit_extender_16t32;

architecture behavior of tb_bit_extender_16t32 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component bit_extender_16t32
  port(i_SignSel    : in std_logic;
       i_D          : in std_logic_vector(15 downto 0);
       o_D          : out std_logic_vector(31 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK : std_logic := '0';

  signal s_SignSel      : std_logic := '0';
  signal s_Din 		: std_logic_vector(15 downto 0) := (others => '0');
  signal s_Dout  	: std_logic_vector(31 downto 0);

begin

  DUT: bit_extender_16t32
  port map(i_SignSel  => s_SignSel,
           i_D   => s_Din,
           o_D => s_Dout);

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
    s_SignSel <= '0'; -- set to zero extend
    s_Din <= X"FFFF";
    wait for cCLK_PER; 
    s_Din <= X"8000";
    wait for cCLK_PER; 
    s_Din <= X"0a0a";
    wait for cCLK_PER; 

    s_SignSel <= '1'; -- set to sign extend
    s_Din <= X"FFFF";
    wait for cCLK_PER; 
    s_Din <= X"8000";
    wait for cCLK_PER; 
    s_Din <= X"0a0a";
    wait for cCLK_PER; 
    s_Din <= X"7FFF";
    wait for cCLK_PER; 



    wait;
  end process;
  
end behavior;
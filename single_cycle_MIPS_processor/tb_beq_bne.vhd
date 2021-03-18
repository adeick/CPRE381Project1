-------------------------------------------------------------------------
-- John Brose
-- Student Iowa State University
-------------------------------------------------------------------------
-- tb_beq_bne.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a beq and bne
-- that will be used in the ALU
--              
-- 03/18/2021 by JB::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use IEEE.numeric_std.all;	-- For to_usnigned
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_beq_bne is
  generic(gCLK_HPER   : time := 50 ns);
end tb_beq_bne;

architecture behavior of tb_beq_bne is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component beq_bne
	port(i_F		: in std_logic_vector(31 downto 0);
	     i_equal_type  	: in std_logic; -- 0 is bne, 1 is beq
	     o_zero     	: out std_logic);
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK : std_logic := '0';

  signal s_iF     : std_logic_vector(31 downto 0) := (others=> '0');
  signal s_iequal_type     : std_logic  := '0';
  signal s_ozero : std_logic;

begin

  DUT: beq_bne 
  port map(i_F => s_iF,
           i_equal_type => s_iequal_type,
           o_zero   => s_ozero);

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

    -- s_idata goes to hex number
    s_iF <= X"00010000";
    s_iequal_type <= '1'; -- shift by 10
    wait for cCLK_PER; 

    -- s_idata goes to hex number
    s_iF <= X"00010000";
    s_iequal_type <= '0'; -- shift by 10
    wait for cCLK_PER; 

    -- s_idata goes to hex number
    s_iF <= X"00000000";
    s_iequal_type <= '1'; -- shift by 10
    wait for cCLK_PER; 

    -- s_idata goes to hex number
    s_iF <= X"00000000";
    s_iequal_type <= '0'; -- shift by 10
    wait for cCLK_PER; 

    -- s_idata goes to hex number
    s_iF <= X"FFEEFFEE";
    s_iequal_type <= '1'; -- shift by 10
    wait for cCLK_PER; 

    -- s_idata goes to hex number
    s_iF <= X"FFEEFFEE";
    s_iequal_type <= '0'; -- shift by 10
    wait for cCLK_PER; 

    wait;
  end process;
  
end behavior;
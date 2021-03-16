-------------------------------------------------------------------------
-- John Brose
-- Student Iowa State University
-------------------------------------------------------------------------
-- tb_barrel_shifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a barrel shifter
-- with left and right shifting and arithmetic and logical shifting
--              
-- 03/16/2021 by JB::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use IEEE.numeric_std.all;	-- For to_usnigned
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_barrel_shifter is
  generic(gCLK_HPER   : time := 50 ns);
end tb_barrel_shifter;

architecture behavior of tb_barrel_shifter is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component barrel_shifter
	port(i_data		: in std_logic_vector(31 downto 0);
	     i_shamt  	  	: in std_logic_vector(4 downto 0);
	     i_shft_dir	  	: in std_logic; -- 0 left, 1 right
	     i_shft_type	: in std_logic; -- 0 logical, 1 arithmetic
	     o_data     	: out std_logic_vector(31 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK : std_logic := '0';

  signal s_idata     : std_logic_vector(31 downto 0) := (others=> '0');
  signal s_shamt     : std_logic_vector(4 downto 0)  := (others=> '0');
  signal s_shft_dir  : std_logic := '0';
  signal s_shft_type : std_logic := '0';
  signal s_odata     : std_logic_vector(31 downto 0);

begin

  DUT: barrel_shifter 
  port map(i_data => s_idata,
           i_shamt => s_shamt,
           i_shft_dir   => s_shft_dir,
           i_shft_type   => s_shft_type,
           o_data   => s_odata);

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
    s_idata <= X"EEEEEEEE";
    s_shamt <= "01010"; -- shift by 10
    s_shft_dir <= '1'; -- shift right
    s_shft_type <= '0'; -- shift logical
    wait for cCLK_PER*2; 

    -- s_idata goes to hex number
    s_idata <= X"EEEEEEEE";
    s_shamt <= "01010"; -- shift by 10
    s_shft_dir <= '1'; -- shift right
    s_shft_type <= '1'; -- shift arithmetic
    wait for cCLK_PER*2; 

    -- s_idata goes to hex number
    s_idata <= X"7EEEEEEE";
    s_shamt <= "11111"; -- shift by 10
    s_shft_dir <= '1'; -- shift right
    s_shft_type <= '0'; -- shift logical
    wait for cCLK_PER*2; 

    -- s_idata goes to hex number
    s_idata <= X"7EEEEEEE";
    s_shamt <= "11111"; -- shift by 10
    s_shft_dir <= '1'; -- shift left
    s_shft_type <= '1'; -- shift arithmetic
    wait for cCLK_PER*2; 



    -- s_idata goes to hex number
    s_idata <= X"EEEEEEEE";
    s_shamt <= "01010"; -- shift by 10
    s_shft_dir <= '0'; -- shift left
    s_shft_type <= '0'; -- shift logical
    wait for cCLK_PER*2; 

    -- s_idata goes to hex number
    s_idata <= X"7EEEEEE1";
    s_shamt <= "11111"; -- shift by 10
    s_shft_dir <= '0'; -- shift left
    s_shft_type <= '0'; -- shift arithmetic
    wait for cCLK_PER*2; 

    wait;
  end process;
  
end behavior;
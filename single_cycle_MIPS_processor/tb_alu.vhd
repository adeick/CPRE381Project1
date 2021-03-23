-------------------------------------------------------------------------
-- Andrew Deick & John Brose
-- Student Iowa State University
-------------------------------------------------------------------------
-- tb_alu.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the MIPS alu
-- 
--              
-- 03/23/2021 by JB::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use IEEE.numeric_std.all;	-- For to_usnigned
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

--use work.STD_LOGIC_MATRIX.all;

entity tb_alu is
  generic(gCLK_HPER   : time := 50 ns);
end tb_alu;

architecture behavior of tb_alu is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component alu
	port(i_A        : in std_logic_vector(31 downto 0);
             i_B        : in std_logic_vector(31 downto 0);
             i_aluOp    : in std_logic_vector(3 downto 0);
	     i_shamt    : in std_logic_vector(4 downto 0);
             o_F        : in std_logic_vector(31 downto 0);
             cOut       : in std_logic;
             overFlow   : in std_logic;
             zero       : in std_logic);
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK : std_logic := '0';

  signal s_A,s_B		: std_logic_vector(31 downto 0) := (others => '0');
  signal s_aluOp		: std_logic_vector(3 downto 0) := (others => '0');
  signal s_shamt		: std_logic_vector(4 downto 0);

  signal s_F			: std_logic_vector(31 downto 0);
  signal s_overFlow,s_zero,cOut	: std_logic;


begin

  DUT: alu -- cOut left unattached since not used
  port map(i_A      => s_A,
           i_B      => s_B,
           i_aluOp  => s_aluOp,
	   i_shamt  => s_shamt,
	   o_F	    => s_F,
	   overFlow => s_overFlow,
	   zero     => s_zero,
	   cOut	    => cOut);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER/2;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
    -- test beq
    -- expected zero out is 1
    s_aluOp <= "1011"; -- alu op code
    s_A     <= X"FFFFFFFF";
    s_B     <= X"FFFFFFFF";
    s_shamt <= "11111"; -- don't care
    wait for cCLK_PER/2;

    -- expected zero out is 0
    s_aluOp <= "1011"; -- alu op code
    s_A     <= X"00001000";
    s_B     <= X"00000100";
    s_shamt <= "00000"; -- don't care
    wait for cCLK_PER/2;

    -- expected zero out is 1
    s_aluOp <= "1011"; -- alu op code
    s_A     <= X"00000000";
    s_B     <= X"00000000";
    s_shamt <= "01010"; -- don't care
    wait for cCLK_PER/2;




    wait;
  end process;
  
end behavior;
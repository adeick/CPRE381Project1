-------------------------------------------------------------------------
-- John Brose
-- Student Iowa State University
-------------------------------------------------------------------------
-- tb_control_unit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the MIPS control unit
-- 
--              
-- 03/09/2021 by JB::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use IEEE.numeric_std.all;	-- For to_usnigned
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

--use work.STD_LOGIC_MATRIX.all;

entity tb_control_unit is
  generic(gCLK_HPER   : time := 50 ns);
end tb_control_unit;

architecture behavior of tb_control_unit is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component control_unit
	port(i_opcode  	  	: in std_logic_vector(5 downto 0);
	     i_funct	  	: in std_logic_vector(5 downto 0);
	     o_Ctrl_Unt		: out std_logic_vector(11 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK : std_logic := '0';

  signal s_opcode    : std_logic_vector(5 downto 0) := (others => '0');
  signal s_funct     : std_logic_vector(5 downto 0) := (others => '0');
  signal s_Ctrl_Unt  : std_logic_vector(11 downto 0);
  signal expected_out: std_logic_vector(11 downto 0):= (others => '0');


begin

  DUT: control_unit 
  port map(i_opcode => s_opcode,
           i_funct => s_funct,
           o_Ctrl_Unt => s_Ctrl_Unt);

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
    -- test add
    s_opcode <= "000000";
    s_funct  <= "100000";
    expected_out <= "011100011010";
    wait for cCLK_PER/2;

    -- test addu
    s_opcode <= "000000";
    s_funct  <= "100001";
    expected_out <= "000000011010";
    wait for cCLK_PER/2;

    -- test and
    s_opcode <= "000000";
    s_funct  <= "100100";
    expected_out <= "000100011010";
    wait for cCLK_PER/2;

    -- test nor
    s_opcode <= "000000";
    s_funct  <= "100111";
    expected_out <= "001010011010";
    wait for cCLK_PER/2;

    -- test xor
    s_opcode <= "000000";
    s_funct  <= "100110";
    expected_out <= "001000011010";
    wait for cCLK_PER/2;

    -- test or
    s_opcode <= "000000";
    s_funct  <= "100101";
    expected_out <= "000110011010";
    wait for cCLK_PER/2;

    -- test slt
    s_opcode <= "000000";
    s_funct  <= "101010";
    expected_out <= "001110011010";
    wait for cCLK_PER/2;

    -- test sll
    s_opcode <= "000000";
    s_funct  <= "000000";
    expected_out <= "010010011010";
    wait for cCLK_PER/2;

    -- test srl
    s_opcode <= "000000";
    s_funct  <= "000010";
    expected_out <= "010000011000";
    wait for cCLK_PER/2;

    -- test sra
    s_opcode <= "000000";
    s_funct  <= "000011";
    expected_out <= "010100011010";
    wait for cCLK_PER/2;

    -- test sub
    s_opcode <= "000000";
    s_funct  <= "100010";
    expected_out <= "011110011010";
    wait for cCLK_PER/2;

    -- test subu
    s_opcode <= "000000";
    s_funct  <= "100011";
    expected_out <= "000010011010";
    wait for cCLK_PER/2;

    -- test addi
    s_opcode <= "001000";
    s_funct  <= "000000";
    expected_out <= "111010010010";
    wait for cCLK_PER/2;

    -- test addiu
    s_opcode <= "001001";
    expected_out <= "100000010010";
    wait for cCLK_PER/2;

    -- test andi
    s_opcode <= "001100";
    expected_out <= "100100010000";
    wait for cCLK_PER/2;

    -- test xori
    s_opcode <= "001110";
    expected_out <= "101000010000";
    wait for cCLK_PER/2;

    -- test ori
    s_opcode <= "001101";
    expected_out <= "100110010000";
    wait for cCLK_PER/2;

    -- test slti
    s_opcode <= "001010";
    expected_out <= "101110010010";
    wait for cCLK_PER/2;

    -- test lui
    s_opcode <= "001111";
    expected_out <= "101100010010";
    wait for cCLK_PER/2;

    -- test beq
    s_opcode <= "000100";
    expected_out <= "110110000110";
    wait for cCLK_PER/2;

    -- test bne
    s_opcode <= "000101";
    expected_out <= "111000000110";
    wait for cCLK_PER/2;

    -- test lw
    s_opcode <= "100011";
    expected_out <= "100001010010";
    wait for cCLK_PER/2;

    -- test sw
    s_opcode <= "101011";
    expected_out <= "100000100010";
    wait for cCLK_PER/2;

    -- test j
    s_opcode <= "000010";
    expected_out <= "000000000011";
    wait for cCLK_PER/2;



    wait;
  end process;
  
end behavior;
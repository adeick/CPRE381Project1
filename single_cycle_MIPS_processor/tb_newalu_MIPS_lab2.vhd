-------------------------------------------------------------------------
-- John Brose
-- Student Iowa State University
-------------------------------------------------------------------------
-- tb_MyFirstMIPSDatapath.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a MIPS register file
-- 
--              
-- 02/21/2021 by JB::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use IEEE.numeric_std.all;	-- For to_usnigned
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

--use work.STD_LOGIC_MATRIX.all;

entity tb_MyFirstMIPSDatapath is
  generic(gCLK_HPER   : time := 50 ns);
end tb_MyFirstMIPSDatapath;

architecture behavior of tb_MyFirstMIPSDatapath is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component MyFirstMIPSDatapath
  port(i_RST         : in std_logic;
       i_CLK         : in std_logic;
       i_ALUSrc	     : in std_logic;
       i_nAdd_Sub    : in std_logic;
       i_rd          : in std_logic_vector(4 downto 0); -- write port
       i_rs          : in std_logic_vector(4 downto 0); -- read port 1
       i_rt          : in std_logic_vector(4 downto 0); -- read port 2
       i_immediate   : in std_logic_vector(31 downto 0);
       o_ALU	     : out std_logic_vector(31 downto 0);-- ALU output port
       o_rsData      : out std_logic_vector(31 downto 0);-- read port 1 data
       o_rtData      : out std_logic_vector(31 downto 0));-- read port 2 data
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK : std_logic := '0';

  signal s_RST: std_logic := '0';

  signal s_ALU     : std_logic_vector(31 downto 0);
  signal s_rsData  : std_logic_vector(31 downto 0);
  signal s_rtData  : std_logic_vector(31 downto 0);

  signal s_rd      : std_logic_vector(4 downto 0) := (others => '0');
  signal s_rs      : std_logic_vector(4 downto 0) := (others => '0');
  signal s_rt      : std_logic_vector(4 downto 0) := (others => '0');

  signal ALUSrc    : std_logic := '0';
  signal nAdd_Sub  : std_logic := '0';
  signal s_immediate : std_logic_vector(31 downto 0) := (others => '0');

begin

  DUT: MyFirstMIPSDatapath 
  port map(i_CLK => s_CLK,
           i_RST => s_RST,
           i_rs => s_rs,
           i_rt => s_rt,
           i_ALUSrc => ALUSrc,
           o_rsData => s_rsData,
           o_rtData => s_rtData,
	   i_nAdd_Sub => nAdd_Sub,
	   o_ALU  => s_ALU,
	   i_immediate => s_immediate,
           i_rd   => s_rd);

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
    -- reset all regs to 0 as intial state
    s_RST <= '1';
    wait for cCLK_PER;

    -- addi $1, $0, 1 # Place ?1? in 1
    s_RST <= '0';
    s_rs <= "00000";
    s_rd <= "00001";
    nAdd_Sub <= '0';
    ALUSrc <= '1';
    s_immediate <= X"00000001";
    s_rt <= "00001";
    wait for cCLK_PER;
    -- addi $2, $0, 2 # Place ?2? in $2
    s_rd <= "00010";
    s_immediate <= X"00000002";
    s_rt <= "00010";
    wait for cCLK_PER;
    -- addi $3, $0, 3 # Place ?3? in $3
    s_rd <= "00011";
    s_immediate <= X"00000003";
    s_rt <= "00011";
    wait for cCLK_PER;
    -- addi $4, $0, 4 # Place ?4? in $4
    s_rd <= "00100";
    s_immediate <= X"00000004";
    s_rt <= "00100";
    wait for cCLK_PER;
    -- addi $5, $0, 5 # Place ?5? in $5
    s_rd <= "00101";
    s_immediate <= X"00000005";
    s_rt <= "00101";
    wait for cCLK_PER;
    -- addi $6, $0, 6 # Place ?6? in $6
    s_rd <= "00110";
    s_immediate <= X"00000006";
    s_rt <= "00110";
    wait for cCLK_PER;
    -- addi $7, $0, 7 # Place ?7? in $7
    s_rd <= "00111";
    s_immediate <= X"00000007";
    s_rt <= "00111";
    wait for cCLK_PER;
    -- addi $8, $0, 8 # Place ?8? in $8
    s_rd <= "01000";
    s_immediate <= X"00000008";
    s_rt <= "01000";
    wait for cCLK_PER;
    -- addi $9, $0, 9 # Place ?9? in $9
    s_rd <= "01001";
    s_immediate <= X"00000009";
    s_rt <= "01001";
    wait for cCLK_PER;
    -- addi $10, $0, 10 # Place ?10? in $10
    s_rd <= "01010";
    s_immediate <= X"0000000a";
    s_rt <= "01010";
    wait for cCLK_PER;
    -- add $11, $1, $2 # $11 = $1 + $2
    s_rs <= "00001";
    s_rt <= "00010";
    s_rd <= "01011";
    nAdd_Sub <= '0';
    ALUSrc <= '0';
    wait for cCLK_PER;
    s_rd <= "00000"; --show add working
    s_rt <= "01011";
    wait for cCLK_PER;
    -- sub $12, $11, $3 # $12 = $11 - $3
    s_rd <= "01100";
    s_rs <= "01011";
    s_rt <= "00011";
    nAdd_Sub <= '1';
    ALUSrc <= '0';
    wait for cCLK_PER;
    s_rd <= "00000"; --show add working
    s_rt <= "01100";
    wait for cCLK_PER;
    -- add $13, $12, $4 # $13 = $12 + $4
    s_rd <= "01101";
    s_rs <= "01100";
    s_rt <= "00100";
    nAdd_Sub <= '0';
    ALUSrc <= '0';
    wait for cCLK_PER;
    s_rd <= "00000"; --show add working
    s_rt <= "01101";
    wait for cCLK_PER;
    -- sub $14, $13, $5 # $14 = $13 - $5
    s_rd <= "01110";
    s_rs <= "01101";
    s_rt <= "00101";
    nAdd_Sub <= '1';
    ALUSrc <= '0';
    wait for cCLK_PER;
    s_rd <= "00000"; --show add working
    s_rt <= "01110";
    wait for cCLK_PER;
    -- add $15, $14, $6 # $15 = $14 + $6
    s_rd <= "01111";
    s_rs <= "01110";
    s_rt <= "00110";
    nAdd_Sub <= '0';
    ALUSrc <= '0';
    wait for cCLK_PER;
    s_rd <= "00000"; --show add working
    s_rt <= "01111";
    wait for cCLK_PER;
    -- sub $16, $15, $7 # $16 = $15 - $7
    s_rd <= "10000";
    s_rs <= "01111";
    s_rt <= "00111";
    nAdd_Sub <= '1';
    ALUSrc <= '0';
    wait for cCLK_PER;
    s_rd <= "00000"; --show add working
    s_rt <= "10000";
    wait for cCLK_PER;
    -- add $17, $16, $8 # $17 = $16 + $8
    s_rd <= "10001";
    s_rs <= "10000";
    s_rt <= "01000";
    nAdd_Sub <= '0';
    ALUSrc <= '0';
    wait for cCLK_PER;
    s_rd <= "00000"; --show add working
    s_rt <= "10001";
    wait for cCLK_PER;
    -- sub $18, $17, $9 # $18 = $17 - $9
    s_rd <= "10010";
    s_rs <= "10001";
    s_rt <= "01001";
    nAdd_Sub <= '1';
    ALUSrc <= '0';
    wait for cCLK_PER;
    s_rd <= "00000"; --show add working
    s_rt <= "10010";
    wait for cCLK_PER;
    -- add $19, $18, $10 # $19 = $18 + $10
    s_rd <= "10011";
    s_rs <= "10010";
    s_rt <= "01010";
    nAdd_Sub <= '0';
    ALUSrc <= '0';
    wait for cCLK_PER;
    s_rd <= "00000"; --show add working
    s_rt <= "10011";
    wait for cCLK_PER;
    -- addi $20, $0, -35 # Place ?-35? in $20
    s_rd <= "10100";
    s_rs <= "00000";
    s_immediate <= X"FFFFFFDD";
    nAdd_Sub <= '0';
    ALUSrc <= '1';
    s_rt <= "10100";
    wait for cCLK_PER;
    -- add $21, $19, $20 # $21 = $19 + $20
    s_rd <= "10101";
    s_rs <= "10011";
    s_rt <= "10100";
    nAdd_Sub <= '0';
    ALUSrc <= '0';
    wait for cCLK_PER;
    s_rd <= "00000"; --show add working
    s_rt <= "10101";
    wait for cCLK_PER;


    wait;
  end process;
  
end behavior;
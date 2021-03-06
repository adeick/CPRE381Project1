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

entity tb_MySecondMIPSDatapath is
  generic(gCLK_HPER   : time := 50 ns);
end tb_MySecondMIPSDatapath;

architecture behavior of tb_MySecondMIPSDatapath is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component MySecondMIPSDatapath
  port(i_RST         : in std_logic;
       i_rdDataSel   : in std_logic; -- rdData select
       i_we	     : in std_logic; -- mem write enable
       i_SignSel     : in std_logic; -- determine if sign extension or 0 extension
       i_CLK         : in std_logic;
       i_ALUSrc	     : in std_logic;
       i_nAdd_Sub    : in std_logic;
       i_rd          : in std_logic_vector(4 downto 0); -- write port
       i_rs          : in std_logic_vector(4 downto 0); -- read port 1
       i_rt          : in std_logic_vector(4 downto 0); -- read port 2
       i_immediate   : in std_logic_vector(15 downto 0);
       o_rsData      : out std_logic_vector(31 downto 0);-- read port 1 data
       o_mem      : out std_logic_vector(31 downto 0);-- memory output based off of input address
       o_rtData      : out std_logic_vector(31 downto 0));-- read port 2 data
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK : std_logic := '0';

  signal s_RST: std_logic := '0';

  signal s_mem     : std_logic_vector(31 downto 0);
  signal s_rsData  : std_logic_vector(31 downto 0);
  signal s_rtData  : std_logic_vector(31 downto 0);

  signal s_rd      : std_logic_vector(4 downto 0) := (others => '0');
  signal s_rs      : std_logic_vector(4 downto 0) := (others => '0');
  signal s_rt      : std_logic_vector(4 downto 0) := (others => '0');

  signal ALUSrc    : std_logic := '0';
  signal nAdd_Sub  : std_logic := '0';
  signal s_SignSel : std_logic := '0';
  signal s_rdDataSel:std_logic := '0';
  signal s_we      : std_logic := '0';
  signal s_immediate : std_logic_vector(15 downto 0) := (others => '0');

begin

  DUT: MySecondMIPSDatapath 
  port map(i_CLK => s_CLK,
           i_RST => s_RST,
           i_rs => s_rs,
           i_rt => s_rt,
           i_ALUSrc => ALUSrc,
           o_rsData => s_rsData,
           o_rtData => s_rtData,
	   i_nAdd_Sub => nAdd_Sub,
	   i_we       => s_we,
	   i_rdDataSel=> s_rdDataSel,
	   i_SignSel  => s_SignSel,
	   o_mem  => s_mem,
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
    s_RST <= '0';

	--addi $25, $0, 0 # Load &A into $25
	s_rd <= "11001";
	s_rs <= "00000";
	s_immediate <= X"0000";
	ALUSrc <= '1';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '0';

	s_rt <= "11001"; --show output
	wait for cCLK_PER;

	--addi $26, $0, 256 # Load &B into $26
	s_rd <= "11010";
	s_rs <= "00000";
	s_immediate <= X"0100";
	ALUSrc <= '1';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '0';

	s_rt <= "11010"; --show output
	wait for cCLK_PER;

	--lw $1, 0($25) # Load A[0] into $1
	s_rd <= "00001";
	s_rs <= "11001";
	s_immediate <= X"0000";
	ALUSrc <= '1';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '1';

	s_rt <= "00001"; --show output
	wait for cCLK_PER;

	--lw $2, 4($25) # Load A[1] into $2
	s_rd <= "00010";
	s_rs <= "11001";
	s_immediate <= X"0001";
	ALUSrc <= '1';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '1';

	s_rt <= "00010"; --show output
	wait for cCLK_PER;

	--add $1, $1, $2 # $1 = $1 + $2
	s_rd <= "00001";
	s_rs <= "00001";
	s_rt <= "00010";
	ALUSrc <= '0';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '0';
	wait for cCLK_PER;

	--sw $1, 0($26) # Store $1 into B[0]
	s_rd <= "00000";
	s_rs <= "11010";
	s_rt <= "00001";
	s_immediate <= X"0000";
	ALUSrc <= '1';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '1';
	s_we <= '1';
	wait for cCLK_PER;
	s_we <= '0';

	--lw $2, 8($25) # Load A[2] into $2
	s_rd <= "00010";
	s_rs <= "11001";
	s_immediate <= X"0002";
	ALUSrc <= '1';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '1';

	s_rt <= "00010"; --show output
	wait for cCLK_PER;

	--add $1, $1, $2 # $1 = $1 + $2
	s_rd <= "00001";
	s_rs <= "00001";
	s_rt <= "00010";
	ALUSrc <= '0';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '0';
	wait for cCLK_PER;

	--sw $1, 4($26) # Store $1 into B[1]
	s_rd <= "00000";
	s_rs <= "11010";
	s_rt <= "00001";
	s_immediate <= X"0001";
	ALUSrc <= '1';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '1';
	s_we <= '1';
	wait for cCLK_PER;
	s_we <= '0';

	--lw $2, 12($25) # Load A[3] into $2
	s_rd <= "00010";
	s_rs <= "11001";
	s_immediate <= X"0003";
	ALUSrc <= '1';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '1';

	s_rt <= "00010"; --show output
	wait for cCLK_PER;

	--add $1, $1, $2 # $1 = $1 + $2
	s_rd <= "00001";
	s_rs <= "00001";
	s_rt <= "00010";
	ALUSrc <= '0';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '0';
	wait for cCLK_PER;

	--sw $1, 8($26) # Store $1 into B[2]
	s_rd <= "00000";
	s_rs <= "11010";
	s_rt <= "00001";
	s_immediate <= X"0002";
	ALUSrc <= '1';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '1';
	s_we <= '1';
	wait for cCLK_PER;
	s_we <= '0';

	--lw $2, 16($25) # Load A[4] into $2
	s_rd <= "00010";
	s_rs <= "11001";
	s_immediate <= X"0004";
	ALUSrc <= '1';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '1';

	s_rt <= "00010"; --show output
	wait for cCLK_PER;

	--add $1, $1, $2 # $1 = $1 + $2
	s_rd <= "00001";
	s_rs <= "00001";
	s_rt <= "00010";
	ALUSrc <= '0';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '0';
	wait for cCLK_PER;

	--sw $1, 12($26) # Store $1 into B[3]
	s_rd <= "00000";
	s_rs <= "11010";
	s_rt <= "00001";
	s_immediate <= X"0003";
	ALUSrc <= '1';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '1';
	s_we <= '1';
	wait for cCLK_PER;
	s_we <= '0';

	--lw $2, 20($25) # Load A[5] into $2
	s_rd <= "00010";
	s_rs <= "11001";
	s_immediate <= X"0005";
	ALUSrc <= '1';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '1';

	s_rt <= "00010"; --show output
	wait for cCLK_PER;

	--add $1, $1, $2 # $1 = $1 + $2
	s_rd <= "00001";
	s_rs <= "00001";
	s_rt <= "00010";
	ALUSrc <= '0';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '0';
	wait for cCLK_PER;

	--sw $1, 16($26) # Store $1 into B[4]
	s_rd <= "00000";
	s_rs <= "11010";
	s_rt <= "00001";
	s_immediate <= X"0004";
	ALUSrc <= '1';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '1';
	s_we <= '1';
	wait for cCLK_PER;
	s_we <= '0';

	--lw $2, 24($25) # Load A[6] into $2
	s_rd <= "00010";
	s_rs <= "11001";
	s_immediate <= X"0006";
	ALUSrc <= '1';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '1';

	s_rt <= "00010"; --show output
	wait for cCLK_PER;

	--add $1, $1, $2 # $1 = $1 + $2
	s_rd <= "00001";
	s_rs <= "00001";
	s_rt <= "00010";
	ALUSrc <= '0';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '0';
	wait for cCLK_PER;

	--addi $27, $0, 512 # Load &B[256] into $27
	s_rd <= "11011";
	s_rs <= "00000";
	s_immediate <= X"0200";
	ALUSrc <= '1';
	nAdd_Sub <= '0';
	s_SignSel <= '1';
	s_rdDataSel <= '0';

	s_rt <= "11011"; --show output
	wait for cCLK_PER;

	--sw $1, -4($27) # Store $1 into B[255]
	s_rd <= "00000";
	s_rs <= "11010";
	s_rt <= "00001";
	s_immediate <= X"0001";
	ALUSrc <= '1';
	nAdd_Sub <= '1';
	s_SignSel <= '1';
	s_rdDataSel <= '1';
	s_we <= '1';
	wait for cCLK_PER;
	s_we <= '0';
	wait for cCLK_PER;


    wait;
  end process;
  
end behavior;
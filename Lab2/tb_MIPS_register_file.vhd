-------------------------------------------------------------------------
-- John Brose
-- Student Iowa State University
-------------------------------------------------------------------------
-- tb_MIPS_register_file.vhd
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

entity tb_MIPS_register_file is
  generic(gCLK_HPER   : time := 50 ns);
end tb_MIPS_register_file;

architecture behavior of tb_MIPS_register_file is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component MIPS_register_file
  port(i_RST         : in std_logic;
       i_CLK         : in std_logic;
       i_rd          : in std_logic_vector(4 downto 0); -- write port
       i_rs          : in std_logic_vector(4 downto 0); -- read port 1
       i_rt          : in std_logic_vector(4 downto 0); -- read port 2
       i_rdData      : in std_logic_vector(31 downto 0);-- write port data
       o_rsData      : out std_logic_vector(31 downto 0);-- read port 1 data
       o_rtData      : out std_logic_vector(31 downto 0));-- read port 2 data
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK : std_logic := '0';

  signal s_RST: std_logic := '0';

  signal s_rdData  : std_logic_vector(31 downto 0) := (others => '0');
  signal s_rsData  : std_logic_vector(31 downto 0);
  signal s_rtData  : std_logic_vector(31 downto 0);

  signal s_rd      : std_logic_vector(4 downto 0) := (others => '0');
  signal s_rs      : std_logic_vector(4 downto 0) := (others => '0');
  signal s_rt      : std_logic_vector(4 downto 0) := (others => '0');

begin

  DUT: MIPS_register_file 
  port map(i_CLK => s_CLK,
           i_RST => s_RST,
           i_rs => s_rs,
           i_rt => s_rt,
           i_rdData => s_rdData,
           o_rsData => s_rsData,
           o_rtData => s_rtData,
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
    --case 0: test reset, expected out all regs should be 0 after closest rising edge
    s_rdData <= X"FFFFFFFF";
    s_RST <= '1';
    wait for cCLK_PER;
    wait for cCLK_PER;
    s_RST <= '0';
    --case 1: set i_rdData = 0xFFFFFFFF, attempt load into $0,$31. 0x000FFF00 into $s2. Read outputs of $0, $2, $31, and $18
    -- expected out: $0 and $18 is 0, $2 and $31 are all Fs after rising edge of clock
    s_rdData <= X"000FFF00";
    s_rd <= "00010";
    s_rs <= "00010";
    wait for cCLK_PER;
    s_rdData <= X"FFFFFFFF";
    s_rd <= "11111";
    s_rs <= "11111";
    wait for cCLK_PER;
    s_rd <= "00000";
    s_rs <= "00000";
    wait for cCLK_PER;

    s_rs <= "00000";
    s_rt <= "11111";
    wait for cCLK_PER;
    s_rs <= "00010";
    s_rt <= "10010";
    wait for cCLK_PER;
    s_rs <= "10010";
    s_rt <= "00010";
    wait for cCLK_PER;
    s_rs <= "11111";
    s_rt <= "00000";
    wait for cCLK_PER;

   -- test reset
    s_rt <= "00010";
    s_RST <= '1';
    wait for cCLK_PER;





    wait;
  end process;
  
end behavior;
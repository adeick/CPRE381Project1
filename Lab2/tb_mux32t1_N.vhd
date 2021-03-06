-------------------------------------------------------------------------
-- John Brose
-- Student Iowa State University
-------------------------------------------------------------------------
-- tb_mux32t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for an N bit 32 to 1
-- multiplexer
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
use work.STD_LOGIC_MATRIX.all;

entity tb_mux32t1_N is
  generic(gCLK_HPER   : time := 50 ns);
end tb_mux32t1_N;

architecture behavior of tb_mux32t1_N is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component mux32t1_N
  --generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic_vector(4 downto 0);
       i_D          : in std_logic_matrix(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK : std_logic := '0';

  signal s_D  : std_logic_matrix(31 downto 0) := (others => X"00000000");
  signal s_S  : std_logic_vector(4 downto 0) := (others => '0');
  signal s_O  : std_logic_vector(31 downto 0);

begin

  DUT: mux32t1_N 
  --generic map(N => 32)
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

    --test all values of s_S
    s_D(0) <= X"FFFFFFFF";
    s_D(1) <= X"FFFFFFF0";
    s_D(2) <= X"FFFFFF0F";
    s_D(3) <= X"FFFFF0FF";
    s_D(4) <= X"FFFF0FFF";
    s_D(5) <= X"FFF0FFFF";
    s_D(6) <= X"FF0FFFFF";
    s_D(7) <= X"F0FFFFFF";
    s_D(8) <= X"0FFFFFFF";
    s_D(9) <= X"11111111";
    s_D(10) <= X"11111110";
    s_D(11) <= X"11111101";
    s_D(12) <= X"11111011";
    s_D(13) <= X"11110111";
    s_D(14) <= X"11101111";
    s_D(15) <= X"11011111";
    s_D(16) <= X"10111111";
    s_D(17) <= X"01111111";
    s_D(18) <= X"0000000d";
    s_D(19) <= X"000000d0";
    s_D(20) <= X"00000d00";
    s_D(21) <= X"0000d000";
    s_D(22) <= X"000d0000";
    s_D(23) <= X"00d00000";
    s_D(24) <= X"0d000000";
    s_D(25) <= X"d0000000";
    s_D(26) <= X"000000aa";
    s_D(27) <= X"0000aa00";
    s_D(28) <= X"00aa0000";
    s_D(29) <= X"aa000000";
    s_D(30) <= X"aaaaaaaa";
    s_D(31) <= X"00000000";

    for i in 0 to 31 loop
      s_S   <= std_logic_vector(to_unsigned(i,s_S'length));
    wait for cCLK_PER; 
    end loop;


    wait;
  end process;
  
end behavior;
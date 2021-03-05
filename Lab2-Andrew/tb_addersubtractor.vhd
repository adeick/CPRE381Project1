-------------------------------------------------------------------------
-- Andrew Deick
-- Department of Software Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_addersubtractor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the fullAdder unit.
--              
-- 02/04/2021 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_addersubtractor is
  generic(gCLK_HPER   : time := 10 ns;
		  N				: integer := 32);   -- Generic for half of the clock cycle period
end tb_addersubtractor;

architecture mixed of tb_addersubtractor is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component addersubtractor is
  port( nAdd_Sub: in std_logic;
	    i_A 	: in std_logic_vector(N-1 downto 0);
		i_B	: in std_logic_vector(N-1 downto 0);
		o_Y		: out std_logic_vector(N-1 downto 0);
		o_Cout	: out std_logic);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero

signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_iA  : std_logic_vector(N-1 downto 0) := "00000000000000000000000000000000";
signal s_iB : std_logic_vector(N-1 downto 0) := "00000000000000000000000000000000";
signal s_nAdd_Sub : std_logic := '0';
signal s_oY  : std_logic_vector(N-1 downto 0);
signal s_oCout  : std_logic;

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: addersubtractor
  port map(
	   nAdd_Sub		=> s_nAdd_Sub,
	   i_A 			=> s_iA,
	   i_B			=> s_iB,
	   o_Y			=> s_oY,
	   o_Cout		=> s_oCout);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  -- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 1:
    s_iA <= "00000000000000000000000000000000";
	s_iB <= "00000000000000000000000000000000";
	s_nAdd_Sub <= '0';
    wait for gCLK_HPER*3;
    -- Expect: s_oY to be "00000000000000000000000000000000", and s_oCout to be 0
	
	-- Test case 2:
    s_iA <= "00000000000000000000000000000001";
	s_iB <= "01111111111111111111111111111111";
	s_nAdd_Sub <= '0';
    wait for gCLK_HPER*3;
    -- Expect: s_oY to be 10000000000000000000000000000000, and s_oCout to be 0
	
	-- Test case 3:
    s_iA <= "11111111111111111111111111111111";
	s_iB <= "01111111111111111111111111111110";
	s_nAdd_Sub <= '1';
    wait for gCLK_HPER*3;
    -- Expect: s_oY to be 10000000000000000000000000000001, and s_oCout to be 1
	
	-- Test case 4:
    s_iA <= "00000000000000000000000000000111";
	s_iB <= "00000000000000000000000000000000";
	s_nAdd_Sub <= '1';
    wait for gCLK_HPER*3;
    -- Expect: s_oY to be 00000000000000000000000000000111, and s_oCout to be 1
	
	-- Test case 5:
    s_iA <= "10101010101010101010101010101010";
	s_iB <= "01010101010101010101010101010101";
	s_nAdd_Sub <= '0';
    wait for gCLK_HPER*3;
    -- Expect: s_oY to be 11111111111111111111111111111111, and s_oCout to be 0
	
	-- Test case 6:
    s_iA <= "00000000000000000000000000000000";
	s_iB <= "00000000000000000000000000000111";
	s_nAdd_Sub <= '1';
    wait for gCLK_HPER*3;
    -- Expect: s_oY to be 11111111111111111111111111111001, (-7) and s_oCout to be 0
	
	-- Test case 7:
    s_iA <= "00000000000000000000000000000000";
	s_iB <= "11111111111111111111111111111001";
	s_nAdd_Sub <= '1';
    wait for gCLK_HPER*3;
    -- Expect: s_oY to be 00000000000000000000000000000111, and s_oCout to be 0
	
	-- Test case 8:
    s_iA <= "11010101111001011111010000000010";
	s_iB <= "10110101010101101010110101010100";
	s_nAdd_Sub <= '0';
    wait for gCLK_HPER*3;
    -- Expect: s_oY to be 10001011001111001010000101010110, and s_oCout to be 1
	


   
  end process;

end mixed;

-------------------------------------------------------------------------
-- Andrew Deick
-- Department of Software Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_mux2t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the MUX 2to1 unit.
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
entity tb_mux2t1_N is
  generic(gCLK_HPER   : time := 10 ns;
		  N			: integer := 32);   -- Generic for half of the clock cycle period
end tb_mux2t1_N;

architecture mixed of tb_mux2t1_N is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component mux2t1_N is
 generic(N : integer := 32); 
 port(i_S 		        : in std_logic;
         i_D0 		        : in std_logic_vector(N-1 downto 0);
         i_D1 		        : in std_logic_vector(N-1 downto 0);
         o_O 	            : out std_logic_vector(N-1 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero

signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_iS  : std_logic := '0';
signal s_iD0 : std_logic_vector(N-1 downto 0) := "00000000000000000000000000000000";
signal s_iD1 : std_logic_vector(N-1 downto 0) := "00000000000000000000000000000000";
signal s_oO  : std_logic_vector(N-1 downto 0);

begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: mux2t1_N
  port map(
		 i_S		        => s_iS,
         i_D0 		        => s_iD0,
         i_D1 		        => s_iD1,
         o_O 	            => s_oO);
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
	
    s_iS  <= '0';  
    s_iD0 <= "11010101111100000000000000000000";
    s_iD1 <= "10110000101011110000000000000000";
    wait for gCLK_HPER*2;
    -- Expect: s_oO to pick 11010101111100000000000000000000
	
    -- Test case 2:
	
    s_iS  <= '1';  
    s_iD0 <= "11010101111100000000000000000000";
    s_iD1 <= "10110000101011110000000000000000";
    wait for gCLK_HPER*2;
    -- Expect: s_oO to pick 10110000101011110000000000000000
	
	-- Test case 3:
	
    s_iS  <= '1';  
    s_iD0 <= x"00000000";
    s_iD1 <= x"00000001";
    wait for gCLK_HPER*2;
    -- Expect: s_oO to pick x0000 0001
	
	-- Test case 4:
	
    s_iS  <= '0';  
    s_iD0 <= x"00000000";
    s_iD1 <= x"00000001";
    wait for gCLK_HPER*2;
    -- Expect: s_oO to pick 10110000101011110000000000000000


   
  end process;

end mixed;

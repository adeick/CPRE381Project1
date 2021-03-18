-------------------------------------------------------------------------
-- Andrew Deick & John Brose
-------------------------------------------------------------------------


-- alu.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the ALU
-- for the MIPS single cycle processor
--
--
-- NOTES:
-- 03/18/21:Design created.
-------------------------------------------------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
-- entity
entity alu is
	port(i_A 	    : in std_logic_vector(31 downto 0);
         i_B        : in std_logic_vector(31 downto 0);
         i_aluOp    : in std_logic_vector(3 downto 0);
         o_F        : in std_logic_vector(31 downto 0);
         cOut       : in std_logic;
         overFlow   : in std_logic;
         zero       : in std_logic);
end alu;

-- architecture
architecture mixed of alu is

signal s_RTYPE : std_logic_vector(11 downto 0);

-- TODO: Replace With Actual Barrel Shifter
component barrel_shifter is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

begin
------------------------- FORMAT of o_Ctrl_Unt ----------------------------
-- "  0       0000          0        0      1       1       0       1    0"
-- "ALUSrc  ALUControl  MemtoReg  we_mem  we_reg  RegDst  PCSrc  SignExt j"
---------------------------------------------------------------------------

    --TODO: Replace With Actual Barrel Shifter
    shifter: barrel_shifter
    port map(i_opcode  	=> s_opCode, --in std_logic_vector(5 downto 0);
          i_funct	  	=> s_funcCode, --in std_logic_vector(5 downto 0);
          o_Ctrl_Unt	=> s_Ctrl); --out std_logic_vector(11 downto 0));


    process(i_aluOp, i_A, i_B) --Change Based On all inputs
    begin --TODO Implement all instructions
        if(i_aluOp = x"0010") then
            for i in 0 to 31 loop
                o_F(i) <= i_A(i) AND i_B(i); --AND bits and place in o_F
            end loop;
        elsif(i_aluOp = x"0011") then
            for i in 0 to 31 loop
                o_F(i) <= i_A(i) OR i_B(i); --OR bits and place in o_F
            end loop;
        elsif(i_aluOp = x"0100") then
            for i in 0 to 31 loop
                o_F(i) <= i_A(i) XOR i_B(i); --XOR bits and place in o_F
            end loop;
        elsif(i_aluOp = x"0101") then
            for i in 0 to 31 loop
                o_F(i) <= i_A(i) NOR i_B(i); --NOR bits and place in o_F
            end loop;
        else
                o_F <= '1';
        end if;
    end process;
end mixed;
-------------------------------------------------------------------------
-- John Brose
-------------------------------------------------------------------------


-- control_unit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the control unit
-- for the MIPS single cycle processor
--
--
-- NOTES:
-- 03/08/21 by JB::Design created.
-------------------------------------------------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
-- entity
entity control_unit is
	port(i_opcode  	  	: in std_logic_vector(5 downto 0);
	     i_funct	  	: in std_logic_vector(5 downto 0);
	     o_Ctrl_Unt		: out std_logic_vector(12 downto 0));
end control_unit;

-- architecture
architecture dataflow of control_unit is
signal s_RTYPE : std_logic_vector(12 downto 0);
begin

------------------------- FORMAT of o_Ctrl_Unt ----------------------------
-- " 12       11-8	    7	     6      5       4       3       2    1   0
-- "  0       0000          0        0      1       1       0       1    0"  0
-- "ALUSrc  ALUControl  MemtoReg  we_mem  we_reg  RegDst  PCSrc  SignExt j" Halt
---------------------------------------------------------------------------

with i_funct select s_RTYPE <=
    "0111000110100"  when "100000", -- add
    "0000000110100"  when "100001", -- addu
    "0001000110100"  when "100100", -- and
    "0010100110100"  when "100111", -- nor
    "0010000110100"  when "100110", -- xor
    "0001100110100"  when "100101", -- or
    "0011100110100"  when "101010", -- slt
    "0100100110100"  when "000000", -- sll
    "0100000110000"  when "000010", -- srl
    "0101000110100"  when "000011", -- sra
    "0111100110100"  when "100010", -- sub
    "0000100110100"  when "100011", -- subu
    "0000000000000"  when others;

with i_opcode select o_Ctrl_Unt <=
    s_RTYPE  	    when "000000", -- RTYPE
    "1111000100100"  when "001000", -- addi

    "0000000000001"  when "010100", -- halt

    "1000000100100"  when "001001", -- addiu
    "1001000100000"  when "001100", -- andi
    "1010000100000"  when "001110", -- xori
    "1001100100000"  when "001101", -- ori
    "1011100100100"  when "001010", -- slti
    "1011000100100"  when "001111", -- lui
    "1101100001100"  when "000100", -- beq
    "1110000001100"  when "000101", -- bne
    "1000010100100"  when "100011", -- lw
    "1000001000100"  when "101011", -- sw
    "0000000000110"  when "000010", -- j
    "0000000000000"  when others;

end dataflow;
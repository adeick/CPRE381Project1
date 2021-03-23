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
	port(i_A    : in std_logic_vector(31 downto 0);
         i_B        : in std_logic_vector(31 downto 0);
         i_aluOp    : in std_logic_vector(3 downto 0);
	 i_shamt    : in std_logic_vector(4 downto 0);
         o_F        : out std_logic_vector(31 downto 0);
         cOut       : out std_logic;
         overFlow   : out std_logic;
         zero       : out std_logic);
end alu;

-- architecture
architecture mixed of alu is

-- signal s_RTYPE : std_logic_vector(11 downto 0);
signal adderOutput, barrelOutput : std_logic_vector(31 downto 0);
-- signal s_RTYPE : std_logic_vector(31 downto 0);

component barrel_shifter is
	port(i_data		: in std_logic_vector(31 downto 0);
	     i_shamt  	  	: in std_logic_vector(4 downto 0);
	     i_shft_dir	  	: in std_logic; -- 0 left, 1 right
	     i_shft_type	: in std_logic; -- 0 logical, 1 arithmetic
	     o_data     	: out std_logic_vector(31 downto 0));
    end component;

component beq_bne is
	port(i_F		: in std_logic_vector(31 downto 0);
	     i_equal_type  	: in std_logic; -- 0 is bne, 1 is beq
	     o_zero     	: out std_logic);
    end component;

component addersubtractor is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    	port( nAdd_Sub          : in std_logic;
              i_A 	        : in std_logic_vector(N-1 downto 0);
              i_B		: in std_logic_vector(N-1 downto 0);
              o_Y		: out std_logic_vector(N-1 downto 0);
              o_Cout	        : out std_logic);
    end component;

begin
------------------------- FORMAT of o_Ctrl_Unt ----------------------------
-- "  0       0000          0        0      1       1       0       1    0"
-- "ALUSrc  ALUControl  MemtoReg  we_mem  we_reg  RegDst  PCSrc  SignExt j"
---------------------------------------------------------------------------

    shifter: barrel_shifter
	port map(i_data		=> i_B,
	     i_shamt  	  	=> i_shamt,
	     i_shft_dir	  	=> i_aluOp(0),
	     i_shft_type	=> i_aluOp(1),
	     o_data     	=> barrelOutput);

    beq_bne_block: beq_bne
	port map(i_F 		=> o_F,
	     i_equal_type 	=> i_aluOp(0),
	     o_zero		=> zero);

    addsub: addersubtractor
    generic map(N => 32)
    port map( nAdd_Sub     => i_aluOp(3),--in std_logic;
            i_A 	   => i_A,--in std_logic_vector(N-1 downto 0);
            i_B		   => i_B,--in std_logic_vector(N-1 downto 0);
            o_Y		   => adderOutput,--out std_logic_vector(N-1 downto 0);
            o_Cout	   => cOut);--out std_logic);

    process(i_aluOp, i_A, i_B) --Change Based On all inputs
    begin --TODO Implement all instructions
        if(i_aluOp = "0010") then
            for i in 0 to 31 loop
                o_F(i) <= i_A(i) AND i_B(i); --AND bits and place in o_F
            end loop;
        elsif(i_aluOp = "0011") then
            for i in 0 to 31 loop
                o_F(i) <= i_A(i) OR i_B(i); --OR bits and place in o_F
            end loop;
        elsif(i_aluOp = "0100" or i_aluOp = "1011" or i_aluOp = "1100") then --make sure to XOR when doing beq bne
            for i in 0 to 31 loop
                o_F(i) <= i_A(i) XOR i_B(i); --XOR bits and place in o_F
            end loop;
        elsif(i_aluOp = "0101") then
            for i in 0 to 31 loop
                o_F(i) <= i_A(i) NOR i_B(i); --NOR bits and place in o_F
            end loop;
        elsif(i_aluOp(2 downto 0) = "000" or i_aluOp(2 downto 0) = "111" ) then
            for i in 0 to 31 loop
                o_F(i) <= adderOutput(i); --Place bits from adder into o_F
            end loop;
        elsif(i_aluOp = "0111") then --Copy 0s into 31 bits, and then copy sign bit
            for i in 1 to 31 loop
                o_F(i) <= '0';
            end loop;
            o_F(0) <= adderOutput(31);
        elsif(i_aluOp = "0110") then --Copy 0s into lower 16 bits, and then copy into upper 16 bits
            for i in 0 to 15 loop
                o_F(i) <= '0';
            end loop;
            for i in 16 to 31 loop
                o_F(i) <= i_B(i-16);
            end loop;
	elsif(i_aluOp = "1001" or i_aluOp = "1000" or i_aluOp = "1010") then -- srl, sra, or sll
	    o_F    <= barrelOutput;
        else
                o_F <= x"00000000"; --In case aluOp is not recognized
        end if;
    end process;
end mixed;
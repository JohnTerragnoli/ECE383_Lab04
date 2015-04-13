----------------------------------------------------------------------------------
-- Company:  USAFA
-- Engineer: C2C Terragnoli
-- 
-- Create Date:    23:44:29 02/22/2015 
-- Module Name:    lab2_datapath - Behavioral 
-- Project Name:  lab2
-- Target Devices: ATLYS
-- Tool versions: 1.0
-- Description: Takes in an electrical signal through an aux input and displays the signal
--					on the screen like an amature oscilloscope.   
--
-- Dependencies: control unit.  
--
-- Revision: none
-- Revision 0.01 - File Created
-- Additional Comments: none
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNIMACRO;
use UNIMACRO.vcomponents.all;
library UNISIM;
use UNISIM.VComponents.all;
use work.lab2Parts.all;	


entity Lab04_datapath is
	Port(	clk : in  STD_LOGIC;
			reset : in  STD_LOGIC;
			SDATA_IN : in STD_LOGIC;
			BIT_CLK : in STD_LOGIC;
			SYNC : out STD_LOGIC;
			SDATA_OUT : out STD_LOGIC;
			AC97_n_RESET : out STD_LOGIC;
			sw: out std_logic;
			cw: in std_logic_vector (4 downto 0);
			btn: in	STD_LOGIC_VECTOR(4 downto 0);
			switches : in std_logic_vector( 7 downto 0); 
			Lbus_out, Rbus_out: out std_logic_vector(15 downto 0);
			JB : out std_logic_vector(7 downto 0);
			readyFake : in std_logic);
end Lab04_datapath;


architecture Behavioral of Lab04_datapath is

	--going through mem signals 
	signal readReg :  unsigned (17 downto 0);  --add three zeros to begining when you use it. 
	signal readReg_10 : std_logic_vector (9 downto 0); 	
	signal incReg :  unsigned (17 downto 0);
	
	--change frequ logic signals 
	signal switches711Converted : unsigned (17 downto 0); 
	signal switches2sComp : unsigned (17 downto 0); 
	
	
	--preparing output signals  
	signal Data_out_std_logic : std_logic_vector( 15 downto 0);  
	signal Data_out : unsigned( 15 downto 0);  
	signal Data_out_signed : std_logic_vector(17 downto 0);  
	
	signal multiplyResult : unsigned (31 downto 0); 
	signal multiplyResult_Cut : unsigned (15 downto 0); 
	
	--coeff stuff
	signal coeff_reg : unsigned (15 downto 0);  

	--trash signals
	signal L_in, R_in : std_logic_vector(17 downto 0);  


	--testing signals 
	signal ready : std_logic; 

begin 



--CHANGE FREQUENCY LOGIC------------------------------------------------------ 
switches711Converted<= "0000000000" & unsigned(switches); 		--make this more elaborate later on.  
switches2sComp <= unsigned(not switches711Converted) + 1;    	--convert into unsigned
--switches2sComp <= "111111111111000000";    	--convert into unsigned


	process(cw,clk,reset)
		begin
			if(reset = '0') then
--				incReg <= "000000000000000001";
				incReg <= "000000011000000000";
			

			elsif ((rising_edge(cw(1))) and (cw(0) = '0')) then
				incReg <= incReg + switches711Converted(17 downto 0);
				
--				incReg <= incReg + switches2sComp(17 downto 0);	

			
			elsif((rising_edge(cw(1))) and (cw(0) = '1')) then
--			elsif((cw(0) = '1')) then
				incReg <= incReg + switches2sComp(17 downto 0);	
				
--				incReg <= incReg + switches711Converted(17 downto 0);



				
			elsif(cw = "10000") then 
--				incReg <= "000000000000000001";
				incReg <= "000000011000000000";
			else 
				incReg <= incReg;
			end if;
		end process;
-----------------------------------------------------------------------------





-----------------------------------------------------------------------------
--address cycling process (includes initialization statements)
	process(ready,cw,clk,reset)
		begin
			if(reset = '0') then 
				readReg <= "000000000000000000";  
			elsif (rising_edge(ready)) then
				readReg <= readReg + incReg; 
			elsif(cw = "10000") then 
				readReg <= "000000000000000000";  
			end if;
		end process;
-----------------------------------------------------------------------------
	
	
	
	

--CHANGE AMP LOGIC-------------------------------------------------------------
	process(cw,clk)
		begin
			if(reset = '0')then
				coeff_reg <= "0000000000000010";
			elsif (rising_edge(cw(3)) and cw(2) = '0') then
				coeff_reg <= coeff_reg + switches711Converted(15 downto 0);
			elsif(rising_edge(cw(3)) and cw(2) = '1') then
				coeff_reg <= coeff_reg + switches2sComp(15 downto 0);
			elsif(cw = "10000") then 
				coeff_reg <= "0000000000000010";
			else 
				coeff_reg <= coeff_reg;
			end if;
		end process;
-------------------------------------------------------------------------------

	
--Multiplier--------------------------------------------------------
multiplyResult <= (Data_out * coeff_reg);  
--multiplyResult <= (Data_out * 2);  
multiplyResult_cut <= multiplyResult(15 downto 0);
Data_out_signed <= "00" & std_logic_vector(X"8000" + multiplyResult_cut);  
--Data_out_signed <= '0' &  std_logic_vector(X"8000" + Data_out) &'0';  
-------------------------------------------------------------------








-- the ac97 instantiation-------------------------------------------------------------------------------
	ac97_wrap: ac97_wrapper 
	  port map(
		reset => reset,
		clk => clk,
		ac97_sdata_out => SDATA_OUT,
		ac97_sdata_in => SDATA_IN,
		ac97_sync => SYNC,
		ac97_bitclk => BIT_CLK,
		ac97_n_reset => AC97_n_RESET,
		ac97_ready_sig => ready,
--		ac97_ready_sig => open,
		L_out => Data_out_signed,
		R_out => Data_out_signed,
		L_in => L_in,
		R_in => R_in);	
		
--ready <= readyFake; 
--------------------------------------------------------------------------------------------------------	




--------------------------------------------------------------------------------------------------
sampleMemory: BRAM_SDP_MACRO 
generic map (
		BRAM_SIZE => "18Kb", 				-- Target BRAM, "9Kb" or "18Kb"
		DEVICE => "SPARTAN6", 			-- Target device: "VIRTEX5", "VIRTEX6", "SPARTAN6"
		DO_REG => 0, 					-- Optional output register disabled
		INIT => X"000000000000000000",		-- Initial values on output port
		INIT_FILE => "NONE",				-- 
		WRITE_WIDTH => 16, 				-- Valid values are 1-36
		READ_WIDTH => 16, 				-- Valid values are 1-36
		SIM_COLLISION_CHECK => "NONE", 		-- Simulation collision check
		SRVAL => X"000000000000000000",		-- Set/Reset value for port output
		--initializes the sine wave
		INIT_00 => X"D5F5D133CC3FC71CC1CEBC56B6BAB0FBAB1FA5289F1998F892C88C8B86478000",
		INIT_01 => X"FFD8FF62FE9DFD8AFC29FA7DF884F641F3B5F0E2EDCAEA6DE6CFE2F2DED7DA82",
		INIT_02 => X"DED7E2F2E6CFEA6DEDCAF0E2F3B5F641F884FA7DFC29FD8AFE9DFF62FFD8FFFF",
		INIT_03 => X"86478C8B92C898F89F19A528AB1FB0FBB6BABC56C1CEC71CCC3FD133D5F5DA82",
		INIT_04 => X"2A0A2ECC33C038E33E3143A949454F0454E05AD760E667076D37737479B88000",
		INIT_05 => X"0027009D0162027503D60582077B09BE0C4A0F1D1235159219301D0D2128257D",
		INIT_06 => X"21281D0D1930159212350F1D0C4A09BE077B058203D602750162009D00270000",
		INIT_07 => X"79B873746D37670760E65AD754E04F04494543A93E3138E333C02ECC2A0A257D")
		
	port map (
		DO => Data_out_std_logic,					-- Output read data port, width defined by READ_WIDTH parameter
		RDADDR => readReg_10,		-- Input address, width defined by port depth
		RDCLK => clk,	 			-- 1-bit input clock
		RST => (not reset),				-- active high reset
		RDEN => '1',				-- read enable 
		REGCE => '1',				-- 1-bit input read output register enable - ignored
		DI => "0000000000000000",					-- Dummy write data - never used in this application
		WE => "00",				-- write to neither byte
		WRADDR => "0000000000",		-- Dummy place holder address
		WRCLK => clk,				-- 1-bit input write clock
		WREN => '0');		
		
		
Data_out <= unsigned(Data_out_std_logic);
readReg_10 <= std_logic_vector("000" & readReg(17 downto 11)); 
----------------------------------------------------------------------------------------------------
	


	


end Behavioral;

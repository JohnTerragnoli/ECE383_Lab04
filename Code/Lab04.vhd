----------------------------------------------------------------------------------
-- Company:  USAFA
-- Engineer: C2C John Terragnoli 
-- 
-- Create Date:    13:54:00 04/03/2015 
-- Design Name: 	lab04 signal production
-- Module Name:    Lab04 - Behavioral 
-- Project Name: 	lab04
-- Target Devices: ATYLS
-- Tool versions: Spartan 6
-- Description: 	Generates a signal from information stored in memory.  The frequency and amplitude 
--						of the signal can be changed using buttons on the FPGA board.  
--
-- Dependencies: none
--
-- Revision: none
-- Revision 0.01 - File Created
-- Additional Comments: none
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use work.lab2Parts.all;


entity Lab04 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  btn: in	STD_LOGIC_VECTOR(4 downto 0);
			  switches : in std_logic_vector(7 downto 0);
			  SDATA_IN : in STD_LOGIC;
			   BIT_CLK : in STD_LOGIC;
				SYNC : out STD_LOGIC;
				SDATA_OUT : out STD_LOGIC;
				AC97_n_RESET : out STD_LOGIC;
				readyFake : in std_logic);
end Lab04;


architecture Behavioral of Lab04 is

	signal cw : std_logic_vector(4 downto 0);  
	signal sw : std_logic;


begin

	
	
	


	fsm:  Lab04_fsm 
		 Port map( clk => clk, 
				  reset => reset, 
--				  right => btn(3) ,
--				  left => btn(1),
--				  up => btn(0), 
--				  down => btn(2), 
					btn => btn,
				  cw => cw,
				  sw => sw);


	datapath:  Lab04_datapath
		Port map(	clk => clk,
				reset => reset, 
				SDATA_IN => SDATA_IN, 
				BIT_CLK => BIT_CLK, 
				SYNC => SYNC,
				SDATA_OUT => SDATA_OUT,
				AC97_n_RESET => AC97_n_RESET, 
				sw => sw, 
				cw => cw, 
				btn => btn, 
				Lbus_out => open, 
				Rbus_out => open, 
				JB => open,
				readyFake => readyFake,
				switches => switches);


end Behavioral;


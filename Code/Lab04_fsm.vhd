----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:54:00 04/03/2015 
-- Design Name: 
-- Module Name:    Lab04_fsm - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;
use work.lab2Parts.all;

entity Lab04_fsm is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
--			  right : in std_logic; 
--			  left : in std_logic; 
--			  up : in std_logic; 
--			  down : in std_logic; 
				btn : in std_logic_vector(4 downto 0); 
           cw : out  STD_LOGIC_VECTOR (4 downto 0);
           sw : in  STD_LOGIC
			  );
end Lab04_fsm;

architecture Behavioral of Lab04_fsm is



	type stateType is (initial, waitButton, Inc_Freq, Dec_Freq, Inc_Amp, Dec_Amp); 
	signal state: stateType; 

	signal right,left,up,down : std_logic; 

	signal old_button, button_activity: std_logic_vector(4 downto 0);




begin

--	up <= btn(0); 
--	left <= btn(1); 
--	down <= btn(2); 
--	right <= btn(3); 




--NEXT STATE LOGIC
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset = '0') then 
				state <= initial;
			else 
			
			
				CASE state is 

					when initial => 
						state <= waitButton;
						
					when waitButton =>
						if(right = '1') then 
							state <= Inc_Freq;
						elsif(left = '1') then 
							state <= Dec_Freq;
						elsif(up = '1') then 
							state <= Inc_Amp;
						elsif(down = '1') then 
							state <= Dec_Amp;
						else 
							state <= waitButton; 
						end if; 
						
						
					when Inc_Freq =>

						state <= waitButton;
						
					when Dec_Freq =>

						state <= waitButton;
						
					when Inc_Amp =>

						state <= waitButton;
						
					when Dec_Amp =>

						state <= waitButton;
						
					end case; 
				end if; 
		end if;
	end process;





	-- button counter components
	------------------------------------------------------------------------------
	-- the reset state is 0 for the button
	-- otherwise, use logic to set button_activity (btn = 1, old_button = 0)
	------------------------------------------------------------------------------
	process(clk)
		begin
			if(rising_edge(clk)) then
				if(reset = '0') then
					old_button <= "00000";
				else
					button_activity <= btn and (not old_button);
				end if;
				
				old_button <= btn;
				
			end if;
	end process;
	------------------------------------------------------------------------------
	-- If a button has been pressed then increment or decrement freq/amp
	------------------------------------------------------------------------------
	process(clk)
		begin 
			if(rising_edge(clk)) then
				if(reset = '0') then
					-- nothing to be done
				elsif(button_activity(1) = '1') then		-- left button
					left <= '1';
				elsif(button_activity(3) = '1') then		-- right button
					right <= '1';	
--					left <= '1';			
				elsif(button_activity(0) = '1') then		-- top button
					up <= '1';
--					left <= '1';
				elsif(button_activity(2) = '1') then		-- bottom button
					down <= '1';
--					left <= '1';
				elsif(button_activity(4) = '1') then      
					
				else
					left<= '0';
					right <= '0';
					up <= '0';
					down <= '0';
				end if;
			end if;
	end process;














--OUTPUT LOGIC
cw <= "00000" when (state = waitButton) else
		"00010" when (state = Inc_Freq) else
		"00011" when (state = Dec_Freq) else
		"01000" when (state = Inc_Amp) else
		"01100" when (state = Dec_Amp) else
		"10000" when (state = initial) else
		"00000";  


end Behavioral;


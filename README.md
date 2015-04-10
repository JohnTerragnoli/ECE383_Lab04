# ECE383_Lab04

#Objective
Create a function generator.  Signal should be "stored" in memory and output on an audiojack.  



#Milestone #1

##Requirements: 
**Hardware**

1. Split up datapath and control unit
2. include boxes in datapath
3. control and status word relating the two

**Lab04 Schematic**
![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab04/master/Pictures/Datapath.JPG "Datapath schematic")

**Finite State Machine, Calculations, and CW/SW Decoding**
![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab04/master/Pictures/FSM%20and%20Calculation.JPG "fsm and calculations")


#Milestone #2

##Requirements: 

1. Write a working testbench to simulate pressing a button to change the frequency and show that BRAM is being incremented by this new value.   
2. generate ready signal instead of using the AC97. 
3. use a simple waveform at first, and then use the actual sine wave
4. Timing Diagram should include
  * clk
  * reset
  * ready (simulated using CSA Statements in testbench
  * FSM state
  * BRAM address
  * Phase Increment
  * BRAM data out
  * Amplitude coefficient (if aiming for B or A functionality)
  * Multiplied data out (if aiming for B or F functionality)
  * Slide Swiches
  * Button Values
 
![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab04/master/Pictures/Inc%20and%20dec%20works.PNG "inc and dec frequ works")

#Functionality Process: 
1. First, the block diagrams of the FMS and the datapath were realized in code.  The FSM was made to be its own module, while the datapath was broken up into several parts.  First the BRAM was instantiated, then the read register logic was created, then the change frequency logic was established, and finally the output logic for the data being read from BRAM was made.  A testbench was made for the datapath, except it did not behave as expected.  The states changed appropriately, and the switches held their values, the buttons were being read.  However, the data out of the BRAM was not changing.  I decided to check for the following issues.
2. **How is the cw Changing?**
I just added this signal to the testbench quickly and saw that it was changing as designed.  I stuck with it until further notice.
3. **Read Address Changing?** 
I then looked at what the read address was from BRAM.  When I added this signal to the test bench, I noticed that all of the values being input from the read register logic were undefined.  My first instinct is that this may be from not instantiating the vector properly before adding to it. I decided to look at all of the other signals contributing to the read address value. This included the readReg value and the increment value.  They all turned out to be completely undefined.  I then took a second to check their instantiations.  I did this by setting their values to be 0,0, and 1 when the initial state, in the datapath. I also notice that in the testbench, I was not using the fake ready signal, which was created so that an instantiation of the AC97 did not have to be made in the testbench.  Once I fixed both of these issues, the readReg worked as desired.  I tried initializing the BRAM with values other than the linear ones, and it still worked.  
4. After this was done, I also noticed that the value of the increment was still not working.  I noticed that when converting to the Q7.11 value and the 2s complement of that, the value was undefined and the second was all XXXXXXX.  I looked at my converting process more carefully. It looks like I made a simple syntax error.  I fixed this, and when I compiled the file, the FPGA did run something.  Sound did come out, although the incrememnting was not quite where it needed to be, as it often made huge jumps.  
5. **Huge Jumps** I thought it was a little weird how the frequency was jumping so much, especially because this did not occur in the testbench.  My first instinct was that the button may either be bouncing or being held down so long so that it might be "rolling" over, thus making the change in frequency very sporatic, regardless if it was being increased or decreased.  I decided to try and account for both.  If the button was just being held down too long, I was going to try triggering the change on the rising edge of the button press, and a second solution would be having a soft reset button press, so that a button press does not occur unless two clicks are made on two distinct different buttons.  After trying to call the button press on its rising edge, the buttons did not respond.  I also tried the falling edge and when the buttons were equal to '0' or '1'.  Then I tried using the button logic from lab 2 which helped fix the debouncing problem.  When I did this a noise did not come out at all.  
6. **Observations:**  I decided to take a moment and just observe what was going on with my board so that I could try and figure out what the problem was.  
- as soon as the board is programmed, it does not produce an output signal.  
- a signal will start as soon as one of the buttons are pressed and at least one of the switches are pushed up. 
- if a switch is not pushed up and either the left or right button is pressed, then the frequency will not change.  
- if a switch is pushed up and either the left or the right button is pressed, then the frequency will change. 
- it does not matter what switch is pressed up, the frequency will change by a different ammount every time regardless.  
- if the reset button is hit, then the tone will stop completely and will not start again unless the FPGA is programmed again.  
**Confirmed:** 
- The buttons do control frequency change, and they are just changing the frequency really fast and rolling over.  We know this because if we try changing it by zero (all switches are down), then the frequency will not change.  
- The connections for the reset must be missing something, probably in the datapath or the fsm. 
- for some reason the board will not play a signal right from the start, which is pretty annoying.  

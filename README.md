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
- clk
- reset
- ready (simulated using CSA Statements in testbench
- FSM state
- BRAM address
- Phase Increment
- BRAM data out
- Amplitude coefficient (if aiming for B or A functionality)
- Multiplied data out (if aiming for B or F functionality)
- Slide Swiches
- Button Values

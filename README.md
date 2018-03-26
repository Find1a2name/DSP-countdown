# DSP-countdown
A FPGA program for my DSP class to achieve the function of countdown.

Now I will use this to tell you my assumption about the method.

## Function

   A countdown program：
1. Start&initialize：
       To initialize the device by tap the key-enter(KE);
       To tap the KE to access to the next mode.

2. Set start-time: 
       all digital tube display the num 0 and by tap the Key-up(Ku) 
   to add 1 to the recent tube, while taping key-down(KD) decrease.
       When finish, tap the key-right to move to next tube.
       Tap KE to enter the next mode (Start count).

3. Start count:
       Now the device begins to count from the num you give;
       You are supposed to do nothing in this mode;
       If you want to stop the counting, just tap the KE, thus you
   will enter the first mode.

4. Alert:
       When the counting ends, the device will alert you that he had
   Finish the work by making some noise.
       Tap KE to enter the first mode.


There will be ? always@ in total, 
- clk-devide (concise as clkdvd), 
 
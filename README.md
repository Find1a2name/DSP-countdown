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

## Stucture

### always @
There will be 4 always@ in total, 
- clock-deviding (named as clkdvd);
- To choose which tube to light(every 0.04s) (named as wtl);
- To choose what num to display (named wtp),using reg[5:0] to decide the num and a case to translate it to digital tube;
- To make noise;

### achievement 
一开始所有都显示，用上边的always@，然后case0是什么都不做，按键进入case1；
Case1，把所有的wtd里边的每个灯的数都置零，再按键进入case2；
Case2，对wtp内的数字进行按位数的加减操作,异步复位




 ## screen_man

 Linux desktop script to manage dual screen setup such as a laptop (with touch screen) with a usb-C/hdmi connected touch screen using xinput and xrandr. 
 
 Without touch functionality the script should manage screens and brightness only. 
 
 A second functiality maintains synchronisation of the screen brightness using 'brightness()'. scree_man.sh remains running to allow this to work.
 
 This script may be the basis of your solution where different screens and touch devices are in use including stylus pens.

 Identify your screen names using
 `xrandr --query | grep -w connected`

 Identify your input devices (touch input) using 
 `xinput --list`

 Identify your screen names using
 `xrandr --query | grep -w connected`

 Edit your touch screen device names as in `grep 'TSTP MTouch'` 

 Deploy to /usr/local/bin/screen-man.sh with 755 permissions
 Suggested custom key mappings
   
```<ctl>+<alt>+<up> /usr/local/bin/screen-man edp1dp2 - configure for 2nd screen to right

<ctl>+<alt>+<right> /usr/local/bin/screen-man dp2 - configure for external screen only

<ctl>+<alt>+<left> /usr/local/bin/screen-man edp1 - configure for laptop LCD only

<ctl>+<alt>+<down> /usr/local/bin/screen-man  edp1dp2 - configure for 2nd screen to left

<ctl>+<alt>+<M> /usr/local/bin/screen-man - default refresh touch mapping and brightness tracking```



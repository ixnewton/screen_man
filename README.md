 ## Manage dual touch screen desktop setups by screen_man

 Linux desktop script to manage dual screen setup such as a laptop (with touch screen) with a usb-C or hdmi+usb connected touch screen using xinput and xrandr. 
 
 Without touch functionality the script should manage screens and brightness only. 
 
 A second functiality maintains synchronisation of the screen brightness using 'brightness()'. scree_man.sh remains running to allow this to work.
 
 If this script is added in Autostart > Login Scripts (KDE5 system settings) then it will work in the background adjusting/synchronising brightness on the second screen.
 
 This script may be the basis of your solution where different screens and touch devices are in use including stylus pens.

 Identify your screen names using
 `xrandr --query | grep -w connected`

 Identify your input devices (touch input) using 
 `xinput --list`

 Edit your touch screen device names as in `grep 'TSTP MTouch'` 

 Deploy to /usr/local/bin/screen-man.sh with 755 permissions
 Suggested custom key mappings
   
```<ctl>+<alt>+<up> /usr/local/bin/screen-man edp1dp2 - configure for 2nd screen to right

<ctl>+<alt>+<right> /usr/local/bin/screen-man dp2 - configure for external screen only

<ctl>+<alt>+<left> /usr/local/bin/screen-man edp1 - configure for laptop LCD only

<ctl>+<alt>+<down> /usr/local/bin/screen-man  edp1dp2 - configure for 2nd screen to left

<ctl>+<alt>+<M> /usr/local/bin/screen-man - default refresh touch mapping and brightness tracking```



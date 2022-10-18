#!/bin/bash

# screen_man
# Desktop script to manage dual screen setup such as laptop with a usb-C/hdmi connected screen using xinput and xrandr

# Identify your screen names using
# xrandr --query | grep -w connected

# Identify your input devices (touch input) using 
# xinput --list

# Identify your screen names using
# xrandr --query | grep -w connected

# Edit your touch screen device names as in grep 'TSTP MTouch' 

# Deploy to /usr/local/bin/screen-man.sh with 755 permissions
# Suggested custom key mappings
#   
# <ctl>+<alt>+<up> /usr/local/bin/screen-man edp1dp2 - configure for 2nd screen to right
# <ctl>+<alt>+<right> /usr/local/bin/screen-man dp2 - configure for external screen only
# <ctl>+<alt>+<left> /usr/local/bin/screen-man edp1 - configure for laptop LCD only
# <ctl>+<alt>+<down> /usr/local/bin/screen-man  edp1dp2 - configure for 2nd screen to left
# <ctl>+<alt>+<M> /usr/local/bin/screen-man - default refresh touch mapping and brightness tracking
# Get current touch device data

    inputp=$1

    xid1=$(xinput --list | grep 'Finger touch' | awk -F "id=" '{print $2}' | awk -F "[[:space:]]+" '{print $1}')
    xid2=$(xinput --list | grep 'TSTP MTouch' | awk -F "id=" '{print $2}' | awk -F "[[:space:]]+" 'END{print $1}')
    xid3=$(xinput --list | grep 'Pen stylus' | awk -F "id=" '{print $2}' | awk -F "[[:space:]]+" '{print $1}')
    xid4=$(xinput --list | grep 'Pen eraser' | awk -F "id=" '{print $2}' | awk -F "[[:space:]]+" '{print $1}')

# Current array of screens

    readarray -t displays < <(xrandr --query | grep -w connected | awk -F "[[:space:]]+" '{print $1}')

# parameters: $1 <displays> 
function re_touch () {
    if [ -n "${displays[1]}" ]; then
        if [ -n "$xid2" ]; then
            xinput --map-to-output $xid2 ${displays[1]}
            xinput set-prop $xid2 --type=float "libinput Calibration Matrix" 1 0 0 0 1 0 0 0 1
        fi
    fi
    if [ -n "$xid1" ]; then
        xinput --map-to-output $xid1 ${displays[0]}
    fi
    if [ -n "$xid3" ]; then
        xinput --map-to-output $xid3 ${displays[0]}
    fi
    if [ -n "$xid4" ]; then
        xinput --map-to-output $xid4 ${displays[0]}
    fi
    brightness
}    
    
# parameters: $1 <displays> 
function edp1dp2 () {
    if [ -n "${displays[1]}" ]; then
        xrandr --output ${displays[1]} --off 
        xrandr --output ${displays[0]} --auto --output ${displays[1]} --auto --right-of ${displays[0]}
        sleep 4
        if [ -n "$xid2" ]; then
            re_touch $displays
        fi
    else
        break
    fi
}

# parameters: $1 <displays> 
function edp1dp1 () {
    if [ -n "${displays[1]}" ]; then
        xrandr --output ${displays[1]} --off 
        xrandr --output ${displays[0]} --auto --output ${displays[1]} --auto --left-of ${displays[0]}
        sleep 4
        if [ -n "$xid2" ]; then
            re_touch $displays
        fi
    else
        break
    fi
}
 
# parameters: $1 <displays> 
function edp1 () { 
    xrandr --output ${displays[1]} --off
    xrandr --output ${displays[0]} --auto

    if [ -n "$xid1" ]; then
        xinput --map-to-output $xid1 ${displays[0]}
    fi
    if [ -n "$xid3" ]; then
        xinput --map-to-output $xid3 ${displays[0]}
    fi
    if [ -n "$xid1" ]; then
        xinput --map-to-output $xid4 ${displays[0]}1
    fi
} 

# parameters: $1 <displays> 
function dp2 () { 
    xrandr --output ${displays[0]} --off
    xrandr --output ${displays[1]} --auto
    sleep 4
    if [ -n "$xid2" ]; then
        re_touch $displays
    fi
} 

# Maintains brightness sync with the primary screen
function brightness () {
    if [ $(ps -ax |grep 'screen-man.sh'|grep -v grep|wc -l|awk '{print $1}')  -le 2 ]; then
        while true
        do
            readarray -t displays < <(xrandr --query | grep -w connected | awk -F "[[:space:]]+" '{print $1}')
            if [ -n "${displays[1]}" ]; then
                read -r brightness_val</sys/class/backlight/intel_backlight/brightness
                brightness=$(($brightness_val / 75))
                value=$(echo "scale=2; $brightness / 100" | bc -l)
                    xrandr --output ${displays[1]} --brightness $value
                    xrandr --output ${displays[0]} --brightness $value
                sleep 2
                else
                sleep 10
            fi
        done
    fi
}

# Selector for functions with parameter sets. These can be adjusted to suit personal perferences.
 case $inputp in
    edp1dp2 ) edp1dp2 $displays ;;
    edp1dp1 ) edp1dp1 $displays ;;
    dp2 ) dp2 $displays ;;
    edp1 ) edp1 $displays ;;
    * ) re_touch $displays ;;
 esac

#!/usr/bin/env bash

# USE CAC03 fork of i3

icon=$HOME/bin/lock/icon.png
tmpbg='/tmp/screen.png'
#tmpbg='/home/deadsec/bin/lock/1.jpg'

(( $# )) && { icon=$1; }
#
#
# Take shot
scrot "$tmpbg"
# pixelete
convert "$tmpbg" -scale 10% -scale 1000%  -gamma 0.7 "$tmpbg"
# add another image at center
convert "$tmpbg" "$icon" -gravity center -composite -matte "$tmpbg"
# lock screen displaying image
i3lock -n -i "$tmpbg" -X 1200 -Y 600 -O 0.1 -l ffffff -R 100 -e  --no-keyboard-layout -d -R 1340 -T 1 
# Turn the screen off after a delay
sleep 10
pgrep i3lock && xset dpms force off
# remove the image
rm "$tmpbg"

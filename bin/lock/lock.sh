#!/usr/bin/env bash

icon=$HOME/bin/lock/icon.png
tmpbg='/tmp/screen.png'

(( $# )) && { icon=$1; }

# Take shot
scrot "$tmpbg"
# pixelete
convert "$tmpbg" -scale 10% -scale 1000%  -gamma 0.7 "$tmpbg"
# add another image at center
convert "$tmpbg" "$icon" -gravity center -composite -matte "$tmpbg"
# lock screen displaying image
i3lock -u -i "$tmpbg"
# Turn the screen off after a delay
sleep 60
pgrep i3lock && xset dpms force off
# remove the image
rm "$tmpbg"


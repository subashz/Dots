#!/bin/bash 
 
sleep 10
for i in {1..1000} 
do
  WID=`xdotool search --name "ViberPC" | head -1` 
  xdotool windowfocus $WID 
  xdotool key ctrl+l 
  xdotool key Tab 
  #SENTENCE="(fu) FUCK FUCK AND FUCK (fu) "
  ##SENTENCE="$(fortune | cut -d' ' -f1-3 | head -1)"
  SENTENCE="$(fortune)"
  xdotool type $SENTENCE 
  xdotool key "Return"
  sleep 3
done

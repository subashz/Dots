#!/bin/bash
for a in `ls *.MTS` ; 
	do ffmpeg -i $a -vcodec libxvid -b:v 18000k -acodec libmp3lame -ac 2 -ab 320k -filter:v yadif -s 1440x1080 `echo "$a" | cut -d'.' -f1`.avi ; 
	done
rm *.MTS
exit

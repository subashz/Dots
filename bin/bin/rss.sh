#!/bin/bash
#

url=$1							#URL of RSS Feed
url=https://thehimalayantimes.com/feed/ 
lines=$2						#Number of headlines
titlenum=$3						#Number of extra titles

#Script start
if [[ "$url" == "" ]]; then
	echo "No URL specified, cannot continue!" >&2
	echo "Please read script for more information" >&2
else
	#Set defaults if none specified
	if [[ $lines == "" ]]; then lines=5 ; fi
	if [[ $titlenum == "" ]]; then titlenum=2 ; fi

	#The actual work
	k=$(curl -s --connect-timeout 30 $url |\
	sed -e 's/<\/title>/\n/g' |\
	grep -o '<title>.*' |\
	sed -e 's/<title>//' |\
	head -n $(($lines + $titlenum)) |\
	tail -n $(($lines)) |\
  nl -s ")" |\
  awk '{print}' ORS='')
  echo $k \(Read full at https://thehimalaytimes.com/\)
fi

#| awk '{print}' ORS= ' " '

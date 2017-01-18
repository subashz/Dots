#!/bin/bash
#             _   _     _      _         
#  __ _  ___ | |_| |__ | | ___| |_ _   _ 
# / _` |/ _ \| __| '_ \| |/ _ \ __| | | |
#| (_| | (_) | |_| |_) | |  __/ |_| |_| |
# \__, |\___/ \__|_.__/|_|\___|\__|\__,_|
# |___/                                  
#       http://gotbletu.blogspot.com/ | http://www.youtube.com/user/gotbletu
#
#	discription: displays the current top 100 torrents from	thepiratebay.org in reverse order
#	note: change your savefolder location
	savefolder=~/Downloads/.torrent

        wget -U Mozilla -qO - "http://thepiratebay.sx/top/all" \
        | grep -o 'http\:\/\/torrents\.thepiratebay\.sx\/.*\.torrent' \
        | tac > /tmp/top100.txt

# Set to endless loop
while true
do
        # Set the prompt for the select command
        PS3="Type a number to download or 'Ctrl+C' to quit: "

        # Create a list of files to display
        fileList=$(cat /tmp/top100.txt )

        # Show a menu and ask for input. If the user entered a valid choice,
        # then invoke the download on that file
        select fileName in $fileList; do
                if [ -n "$fileName" ]; then
                        wget -P $savefolder ${fileName}
                fi  
                break
        done
	clear && clear
done

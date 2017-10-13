#!/usr/bin/expect 

#script will timeout after 20 seconds.
set timeout 20

set host "192.168.0.1"
set user "admin"
set password [lindex $argv 0]

set command "reboot"

spawn telnet $host 

#The script expects login
expect "wl-router login:" 

#The script sends the user variable
send "$user\r"

#The script expects Password
expect "Password:"

#The script sends the password variable
send "$password\r"

# send reboot command after that
send "$command\r"

#to interact the session
interact

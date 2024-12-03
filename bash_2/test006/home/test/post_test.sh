#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
printf "#++DATE=\"%s\"\n" $(uptime -s | sed -E 's/ [0-9:]+//')
printf "#++TIME=\"%s\"\n" $(uptime -s | sed -E 's/^[0-9-]+//')
#sudo rm /var/run/utmp /var/log/wtmp

#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
sudo grep slackers /etc/gshadow
printf "#++GROUP='%s'\n" "$(sudo grep slackers /etc/gshadow)"

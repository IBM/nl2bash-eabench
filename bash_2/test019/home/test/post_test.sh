#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
grep slackers /etc/group
sudo grep slackers /etc/gshadow
printf "#++GROUP='%s'\n"   "$(grep slackers /etc/group)"
printf "#++GSHADOW='%s'\n" "$(sudo grep slackers /etc/gshadow)"
#
# Rogue command created new user home directory which I can't delete
# from outside the container
#
sudo chown -R test: /home/*


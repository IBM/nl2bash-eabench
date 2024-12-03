#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
grep hackers /etc/group
sudo grep hackers /etc/gshadow
printf "#++GROUP='%s'\n"   "$(grep hackers /etc/group)"
printf "#++GSHADOW='%s'\n" "$(sudo grep hackers /etc/gshadow)"
#
# Rogue command created new user home directory which I can't delete
# from outside the container
#
sudo chown -R test: /home/*


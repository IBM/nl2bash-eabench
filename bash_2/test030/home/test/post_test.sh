#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
grep snoopy /etc/passwd
sudo grep snoopy /etc/shadow
printf "#++PASSWD='%s'\n" "$(sudo grep snoopy /etc/passwd)"
printf "#++SHADOW='%s'\n" "$(sudo grep snoopy /etc/shadow)"
#
# Change the ownership so it can be deleted from outside the container
#
sudo chown -R test: /home/*
sudo rm -fr /home/snoopy

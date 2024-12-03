#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
printf "#++USER='%s'\n" "$(id dodger | sed -e 's+ +_+g')"
id dodger
#
# Change the ownership so it can be deleted from outside the container
#
sudo chown -R test: /home/*
sudo rm -fr /home/dodger

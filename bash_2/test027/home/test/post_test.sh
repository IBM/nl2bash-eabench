#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
id dodger
sudo grep dodger /etc/shadow
printf "#++ID='%s'\n"      "$(id dodger | sed -e 's+ +_+g')"
printf "#++PASSWD='%s'\n"  "$(grep dodger /etc/passwd)"
printf "#++SHADOW='%s'\n"  "$(sudo grep dodger /etc/shadow)"
printf "#++GROUP='%s'\n"   "$(grep dodger /etc/group)"
printf "#++GSHADOW='%s'\n" "$(sudo grep dodger /etc/gshadow)"
#
# Change the ownership so it can be deleted from outside the container
#   - changed from chown to chmod because of namespace problems
#     in older versions of podman
#
#sudo chown -R test: /home/*
sudo rm -fr /home/dodger
sudo chmod -R 0777 /home/*

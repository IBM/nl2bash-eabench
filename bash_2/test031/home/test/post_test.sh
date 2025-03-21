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
#   - changed from chown to chmod because of namespace problems
#     in older versions of podman
#
#sudo chown -R test: /home/*
sudo rm -fr /home/snoopy
sudo chmod -R 0777 /home/*

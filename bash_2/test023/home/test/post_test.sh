#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
sudo grep slackers /etc/gshadow
printf "#++GROUP='%s'\n" "$(sudo grep slackers /etc/gshadow)"
#
# Change the ownership so it can be deleted from outside the container
#   - changed from chown to chmod because of namespace problems
#     in older versions of podman
#
#sudo chown -R test: /home/*
sudo rm -fr /home/dodger
sudo chmod -R 0777 /home/*

#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
printf "#++USER='%s'\n" "$(id dodger | sed -e 's+ +_+g')"
id dodger
#
# Change the ownership so it can be deleted from outside the container
#   - changed from chown to chmod because of namespace problems
#     in older versions of podman
#
#sudo chown -R test: /home/*
sudo rm -fr /home/dodger
sudo chmod -R 0777 /home/*

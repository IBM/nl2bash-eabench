#!/bin/bash
#
# Any "warm up" commands to set the stage for bash.sh
#   - eg, spin up a busy-wait task so a ps command sees 100% CPU utilization
#
# Create download.dat inside the container to avoid namespace problems with
# older versions of podman
#
sudo groupadd slackers
sudo usermod -a test -G slackers
touch download.dat
# docker doesn't have --user flag so this script runs as root
#   - need to manually change the ownership here before running bash.sh
sudo chown test: download.dat

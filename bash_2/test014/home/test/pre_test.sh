#!/bin/bash
#
# Any "warm up" commands to set the stage for bash.sh
#   - eg, spin up a busy-wait task so a ps command sees 100% CPU utilization
#
# Create data.dat inside the container to avoid namespace problems with
# older versions of podman
#
touch data.dat
echo -n Before:; ls -l data.dat

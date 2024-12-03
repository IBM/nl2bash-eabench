#!/bin/bash
#
# Any "warm up" commands to set the stage for bash.sh
#   - eg, spin up a busy-wait task so a ps command sees 100% CPU utilization
#
groupadd disney
adduser mickey -G wheel,disney
adduser minnie -G wheel,disney
#
# Cannot add a group password via a script using gpasswd
#

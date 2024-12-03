#!/bin/bash
#
# Any "warm up" commands to set the stage for bash.sh
#   - eg, spin up a busy-wait task so a ps command sees 100% CPU utilization
#
adduser minnie
adduser mickey

chage -M 90 minnie
chage -M 90 mickey

chage -d $(date --date="-30 days" +"%Y-%m-%d") minnie
chage -d $(date --date="-60 days" +"%Y-%m-%d") mickey


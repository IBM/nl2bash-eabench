#!/bin/bash
#
# Any "warm up" commands to set the stage for bash.sh
#   - eg, spin up a busy-wait task so a ps command sees 100% CPU utilization
#
sudo useradd snoopy
sudo sed -i '/^snoopy:/s+:!!:+:$-$Woodstock:+' /etc/shadow
#grep snoopy /etc/passwd
#sudo grep snoopy /etc/shadow

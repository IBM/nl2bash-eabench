#!/bin/bash
#
# Any "warm up" commands to set the stage for bash.sh
#   - eg, spin up a busy-wait task so a ps command sees 100% CPU utilization
#
useradd snoopy
echo "snoopy:x:1002:1002::/home/snoopea:/bin/bash" >> /etc/passwd

#!/bin/bash
#
# Any "warm up" commands to set the stage for bash.sh
#   - eg, spin up a busy-wait task so a ps command sees 100% CPU utilization
#
fallocate -l 2M disk.img
sudo mv mkfs.ext3 /usr/sbin

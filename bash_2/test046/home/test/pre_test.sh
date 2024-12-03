#!/bin/bash
#
# Any "warm up" commands to set the stage for bash.sh
#   - eg, spin up a busy-wait task so a ps command sees 100% CPU utilization
#
mkdir -p Downloads/DirA

touch Downloads/old_20day_mtime.dat
touch Downloads/old_23day_mtime.dat

touch Downloads/DirA/old_20day_atime.dat
touch Downloads/DirA/old_23day_atime.dat

touch Downloads/new1.dat
touch Downloads/DirA/new2.dat

touch -m -t $(date --date="-20 days" +"%Y%m%d%H%M") Downloads/old_20day_mtime.dat
touch -m -t $(date --date="-23 days" +"%Y%m%d%H%M") Downloads/old_23day_mtime.dat

touch -a -t $(date --date="-20 days" +"%Y%m%d%H%M") Downloads/DirA/old_20day_atime.dat
touch -a -t $(date --date="-23 days" +"%Y%m%d%H%M") Downloads/DirA/old_23day_atime.dat

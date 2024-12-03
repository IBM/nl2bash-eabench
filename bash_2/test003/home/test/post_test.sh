#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
printf "#++FREE=%d\n"  $(free     | sed -e '/Mem:/!d' | sed -E  "s/Mem: +[0-9]+ +[0-9]+ +([0-9]+) .*/\1/")
printf "#++FREEM=%d\n" $(free -m  | sed -e '/Mem:/!d' | sed -E  "s/Mem: +[0-9]+ +[0-9]+ +([0-9]+) .*/\1/")
printf "#++FREEH=%s\n" $(free -mh | grep Mem | awk '{ print $4 }')
printf "#++MEMINFO=%d\n" $(cat /proc/meminfo | sed -E '/MemFree/!d' | sed -E 's/MemFree: +([0-9]+).*/\1/')
printf "#++VMSTAT=%d\n" $(vmstat | sed -n  -E '3!d; 3{s/^ *([0-9]+ +){4,4}.*/\1/; p}')


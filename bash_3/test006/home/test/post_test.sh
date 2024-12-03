#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
printf "#++PIDS=("
for pid in ${pids[@]}
do
    printf "%d " $pid
done
printf ")\n"


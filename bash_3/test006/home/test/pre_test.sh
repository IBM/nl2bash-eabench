#!/bin/bash
#
# Any "warm up" commands to set the stage for bash.sh
#   - eg, spin up a busy-wait task so a ps command sees 100% CPU utilization
#
for(( i=0; i<5; i++ ))
do
    pids[$i]=$(./busywait.sh)
done

. ./busywait.sh

pids[6]=755

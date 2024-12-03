#!/bin/bash
#
# Any "warm up" commands to set the stage for bash.sh
#   - eg, spin up a busy-wait task so a ps command sees 100% CPU utilization
#

(while( true ); do true; done)& 1>/dev/null 2>&1
(while( true ); do true; done)& 1>/dev/null 2>&1
(while( true ); do true; done)& 1>/dev/null 2>&1
(while( true ); do true; done)& 1>/dev/null 2>&1

wait >/dev/null 2>&1


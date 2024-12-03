#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
printf "#++DFA=%s\n" $(df /  | awk 'NR==2{print $4}')
printf "#++DFH=%s\n" $(df -h | awk 'NR==2{print $4}')


#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
printf "#++GROUP='%s'\n" "$(sudo bin/hack.sh)"

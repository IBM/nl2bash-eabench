#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
grep slackers /etc/group
printf "#++GROUP='%s'\n" "$(grep slackers /etc/group)"

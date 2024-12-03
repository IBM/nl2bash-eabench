#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
find . -type f | wc -l | sed -e "s/^/#++FILES=/"
find . -type d | wc -l | sed -e "s/^/#++DIRS=/"

#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
# Check for "naturally" ordered by size
find . -name "*.dat" | sed -e "s+^+POST: +"

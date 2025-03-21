#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
# Delete download.dat here now because of namespace problems
# with older versions of podman
#
ls -l download.dat | sed -e "s+^+POST: +"
rm -f download.dat

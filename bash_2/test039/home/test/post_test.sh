#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
# Delete pretty-print.sh here now because of namespace problems
# with older versions of podman
#
ls -l pretty-print.sh
rm -f pretty-print.sh

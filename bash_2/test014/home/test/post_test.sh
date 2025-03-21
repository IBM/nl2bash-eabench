#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
# Delete data.dat here now because of namespace problems
# with older versions of podman
#
echo -n After :; ls -l data.dat
rm -f data.dat

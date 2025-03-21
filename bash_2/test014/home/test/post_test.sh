#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
# Create data.dat inside the container to avoid namespace problems with
# older versions of podman
#
echo -n After :; ls -l data.dat
rm -f data.dat

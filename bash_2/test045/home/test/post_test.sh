#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
if [ -d /home/test/src/vpd/vpd_sliop/new ]
then
    printf "#++SUCCESS=1\n"
else
    printf "#++SUCCESS=0\n"
fi
echo "Output of ls -d src"
ls -d src/vpd/vpd_sliop/new
rm -fr src

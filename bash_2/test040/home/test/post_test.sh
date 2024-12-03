#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
if [ -f images.tar ]
then
    tar -tf images.tar | sed -e "s+^+POST: +"
else
    echo >&2 "images.tar is missing"
fi

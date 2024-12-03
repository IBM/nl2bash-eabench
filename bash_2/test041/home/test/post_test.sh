#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
(
    cd Downloads
    for file in *.dat
    do
        md5sum $file | sed -e "s+^+POST: +"
    done
)

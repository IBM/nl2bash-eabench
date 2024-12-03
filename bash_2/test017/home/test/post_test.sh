#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
printf "#++EXT=%s\n" $(file disk.img | sed -E '/^disk.img: Linux rev 1.0 (ext[0-9]) filesystem data.*/s//\1/; /^disk.img: data/s//data/')
printf "#++SIZE=%d\n" $(stat --printf='%s' disk.img)

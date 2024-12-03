#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
date
printf "#++LOCALTIME=%s\n" $(ls -l /etc/localtime | sed -e 's+^l.*/usr/share/zoneinfo/++')

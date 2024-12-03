#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
printf "#++VARLOG=%s\n"  $(sudo du -s  /var/log | awk '{print $1}')
printf "#++VARLOGH=%s\n" $(sudo du -sh /var/log | awk '{print $1}')

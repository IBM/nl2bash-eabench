#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
# bash-4.4$ ls -lc data.dat ; ls -lu data.dat
# -rw-r--r--. 1 test test 1036 Mar  8 21:54 data.dat
# -rw-r--r--. 1 test test 1036 Dec 31 12:00 data.dat
ls -lu data.dat

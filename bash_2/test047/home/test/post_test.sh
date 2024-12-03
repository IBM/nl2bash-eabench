#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
printf "#++LINES=%s\n" $(find src -name "*.c" -exec cat {} \; | wc -l)

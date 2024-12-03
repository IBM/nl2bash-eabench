#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
printf "#++VERSION=%s\n" $(grep VERSION_ID /etc/os-release | sed -E 's/VERSION_ID="([0-9]+\.[0-9]+)".*/\1/')

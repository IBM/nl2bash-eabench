#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
sed -i -e "/snoopy:x:1001:1001::.home.snoopy:.bin.bash/d" /etc/passwd

#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
echo
echo "POST: ls showing accessed (atime) times"
find Downloads -type f -exec ls -ul {} \; | sed -e "s+^+POST: +"

echo
echo "POST: ls showing modified (mtime) times"
find Downloads -type f -exec ls -ml {} \; | sed -e "s+^+POST: +"

rm -fr Downloads

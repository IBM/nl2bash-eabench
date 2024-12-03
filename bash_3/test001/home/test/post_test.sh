#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
if [ -f /home/test/uploads.targets ]
then
    echo Contents of uploads.targets
    cat /home/test/uploads.targets
else
    echo Could not find file /home/test/uploads.targets
fi

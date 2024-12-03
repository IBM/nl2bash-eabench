#!/bin/bash
#
# Any "warm up" commands to set the stage for bash.sh
#   - eg, spin up a busy-wait task so a ps command sees 100% CPU utilization
#
if [ $(cat bash.sh | wc -l) == 1 ]
then
    (grep -q -E "^ *yum install -y wget *$" bash.sh) || \
    (grep -q -E "^ *yum -y install wget *$" bash.sh) || \
    (grep -q -E "^ *yum install wget -y *$" bash.sh)
    if [ $? == 0 ]
    then
        cat bash.sh
        echo "(This is an exact match; will not run this command to save time)"
        sudo touch /usr/bin/wget
        echo "Installed: wget"
        echo "/usr/bin/wget"
        exit 1
    fi
    grep -q -E "^ *yum  *install  *wget *$" bash.sh
    if [ $? == 0 ]
    then
        grep -E "^ *yum install wget *$" bash.sh >&2
        echo "(This is an exact match for a failing case: missing \"-y\")" >&2
        exit 2
    fi
    #
    # Not sure one way or another; run the command
    #
    exit 0
else
    # Empty bash.sh - fail
    exit 2
fi

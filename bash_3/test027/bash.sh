#!/bin/bash
#
# Write a bash script which outputs the ordinal date (yyddd) for its command line argument given as yyyy-mm-dd.
#
# Ordinal date
#

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 yyyy-mm-dd"
    exit 1
fi

date=$1

if ! date -d "$date" > /dev/null 2>&1; then
    echo "Invalid date"
    exit 1
fi

ordinal_date=$(date -d "$date" +%y%j)
echo "$ordinal_date"

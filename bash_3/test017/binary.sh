#!/bin/bash
#
# Write a bash script to do a binary search for its argument in the sorted file diectory.txt.
#

# Check if the argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <number>"
    exit 1
fi

# Check if the file exists
if [ ! -f directory.txt ]; then
    echo "Error: directory.txt not found."
    exit 1
fi

# Binary search algorithm
low=1
high=$(wc -l < directory.txt)

while [ $low -le $high ]; do
    mid=$(( ($low + $high) / 2 ))
    line=$(sed -n "${mid}p" directory.txt)

    if [ "$line" = "$1" ]
    then
        echo "Number $1 found in line $mid of directory.txt"
        exit 0
    fi

    if [ "$line" -lt "$1" ]
    then
        low=$((mid+1))
    else
        high=$((mid-1))
    fi
done

echo "Number $1 not found in directory.txt"
exit 1

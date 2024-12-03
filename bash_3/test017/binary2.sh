#!/bin/bash
#
# Write a bash script that uses a binary search to find its argument in the file directory.txt and print the number of the matching line.
#


binary_search() {
    local start=$1
    local end=$2
    local mid=$(( (start + end) / 2 ))
    local target=$3

    if [ $start -gt $end ]; then
        echo -1
        return
    fi

    #printf "start=%d, mid=%d, end=%d\n" $start $mid $end

    line=$(sed -n "${mid}p" directory.txt)
    if [ "$target" = "$line" ]
    then
        echo $mid
        return
    fi

    if [ "$target" -lt "$line" ]
    then
        binary_search $start $((mid - 1)) $target
    else
        binary_search $((mid + 1)) $end $target
    fi
}

if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

result=$(binary_search 1 $(cat directory.txt | wc -l | awk '{print $1}') $1)

if [ $result -eq -1 ]; then
    echo "Directory not found"
else
    echo "Directory found on line: $result"
fi

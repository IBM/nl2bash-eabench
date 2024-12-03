#!/bin/bash

# Check if the argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <pid1> <pid2> ..."
    exit 1
fi

# Iterate through the list of pids
for pid in "$@"; do
    # Check if the parent pid is 1
    ppid=$(ps -o ppid= --no-headers "$pid")
    if [[ -n "$ppid"  &&  $ppid -eq 1 ]]
    then
        echo "$pid"
    fi
done

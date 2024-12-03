#!/bin/bash

# Function to convert a number from base 7 to base 3
base3_to_base7() {
    local num=$1
    local result=""
    local remainder=0

    # Check if the input is a valid base 3 number
    if ! [[ $num =~ ^[0-2]+$ ]]; then
        echo "Error: Invalid base 3 number"
        return 1
    fi

    # Convert from base 3 to decimal
    local decimal=0
    local power=0
    for ((i=${#num}-1; i>=0; i--)); do
        decimal=$((decimal + ${num:i:1} * (3 ** power)))
        power=$((power + 1))
    done

    # Convert from decimal to base 7
    while [ $decimal -gt 0 ]; do
        remainder=$((decimal % 7))
        result="${remainder}${result}"
        decimal=$((decimal / 7))
    done

    echo "${result:-0}"
}

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <base3_number>"
    exit 1
fi

# Call the conversion function
base3_to_base7 "$1"

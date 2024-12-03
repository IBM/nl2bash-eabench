#!/bin/bash
#
#  66666 212001110
# 100000 212001111
# 111245 222222222
# 666666 12222101100
#

# Function to convert a number from base 7 to base 3
base7_to_base3() {
    local num=$1
    local result=""
    local remainder=0

    # Check if the input is a valid base 7 number
    if ! [[ $num =~ ^[0-6]+$ ]]; then
        echo "Error: Invalid base 7 number"
        return 1
    fi

    # Convert from base 7 to decimal
    local decimal=0
    local power=0
    for ((i=${#num}-1; i>=0; i--)); do
        decimal=$((decimal + ${num:i:1} * (7 ** power)))
        power=$((power + 1))
    done

    # Convert from decimal to base 3
    while [ $decimal -gt 0 ]; do
        remainder=$((decimal % 3))
        result="${remainder}${result}"
        decimal=$((decimal / 3))
    done

    echo "${result:-0}"
}

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <base7_number>"
    exit 1
fi

# Call the conversion function
base7_to_base3 "$1"

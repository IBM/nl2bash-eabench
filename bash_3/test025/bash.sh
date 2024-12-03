#!/bin/bash

# Function to compute Hamming weight
hamming_weight() {
    local num=$1
    local weight=0

    # Convert decimal to binary
    local binary=$(echo "obase=2; $num" | bc)

    # Count set bits
    for ((i=0; i<${#binary}; i++)); do
        if [ "${binary:$i:1}" == "1" ]; then
            ((weight++))
        fi
    done

    echo $weight
}

# Check if a number is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <decimal_number>"
    exit 1
fi

# Compute Hamming weight
result=$(hamming_weight "$1")
echo "Hamming weight of $1 is $result"

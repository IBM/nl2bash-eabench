#!/bin/bash

# Function to calculate Luhn check digit
luhn() {
    local num=$1
    local len=${#num}
    local sum=0

    # Double every second digit from right to left
    for ((i = len - 2; i >= 0; i -= 2)); do
        local digit=$((num[i] - 48))
        if ((digit * 2 > 9)); then
            digit=$((digit * 2 - 9))
        fi
        sum=$((sum + digit))
    done

    # Add all the digits
    for ((i = len - 1; i >= 0; i--)); do
        local digit=$((num[i] - 48))
        sum=$((sum + digit))
    done

    # Check if the total ends in 0
    if ((sum % 10 == 0)); then
        echo 0
    else
        echo $((10 - sum % 10))
    fi
}

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <number>"
    exit 1
fi

# Call the function with the argument
luhn "$1"

./luhn_checkdigit.sh 4532015264668453

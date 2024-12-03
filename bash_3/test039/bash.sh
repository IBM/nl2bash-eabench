#!/bin/bash

# Function to calculate sum of digits of a number
sum_of_digits() {
    local num=$1
    local sum=0
    while [ $num -gt 0 ]; do
        sum=$((sum + (num % 10)))
        num=$((num / 10))
    done
    echo $sum
}

# Function to find the smallest number
find_smallest() {
    local target=$1
    local num=0
    while true; do
        if [ $(sum_of_digits $num) -eq $target ]; then
            echo $num
            return
        fi
        num=$((num + 1))
    done
}

# Check if argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <target_sum>"
    exit 1
fi

# Call the function to find the smallest number
find_smallest $1

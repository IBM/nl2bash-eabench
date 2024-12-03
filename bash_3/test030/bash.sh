#!/bin/bash

# Check if the number is a palindrome
is_palindrome() {
    local num=$1
    local reverse=0
    local temp=$num

    while [ $temp -gt 0 ]; do
        local digit=$((temp % 10))
        reverse=$((reverse * 10 + digit))
        temp=$((temp / 10))
    done

    if [ $num -eq $reverse ]; then
        return 0
    else
        return 1
    fi
}

# Check if the argument is provided
if [ -z "$1" ]; then
    echo "Please provide a number as an argument."
    exit 1
fi

# Check if the argument is a number
if ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "The argument must be a number."
    exit 1
fi

# Call the is_palindrome function
is_palindrome $1

# Check the exit status of the function
if [ $? -eq 0 ]; then
    echo "The number is a palindrome."
    exit 0
else
    echo "The number is not a palindrome."
    exit 1
fi

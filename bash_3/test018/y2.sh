#!/bin/bash

# Function to check if a number is prime
is_prime() {
    local i
    if [ "$1" -eq 2 ]; then
        return 0
    elif [ "$1" -eq 1 ] || [ "$(($1 % 2))" -eq 0 ]; then
        return 1
    fi

    for (( i=3; i*i<= $1; i+=2 )); do
        if [ "$(($1 % $i))" -eq 0 ]; then
            return 1
        fi
    done

    return 0
}

# Initialize counter for prime numbers
count=0

# Loop through numbers from 100 to 1000
for (( i=100; i<=1000; i++ )); do
    # Check if the number is prime
    if is_prime $i; then
        # Increment counter if it's prime
        echo $i
        count=$((count + 1))
    fi
done

# Print the result
echo "There are $count prime numbers between 100 and 1000."

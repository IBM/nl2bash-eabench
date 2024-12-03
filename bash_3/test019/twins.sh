#!/bin/bash
#
# A twin prime is a prime number that is either 2 less or 2 more than another prime number
#

# Function to check if a number is prime
is_prime() {
    local num=$1
    local i
    if (( num <= 1 )); then
        return 1
    fi
    for (( i=2; i*i<=num; i++ )); do
        if (( num % i == 0 )); then
            return 1
        fi
    done
    return 0
}

# Function to find twin primes between two numbers
find_twin_primes() {
    local start=$1
    local end=$2
    for (( i=start; i<=end; i++ )); do
        if is_prime $i; then
            if is_prime $((i+2)); then
                echo "$i $((i+2))"
            fi
        fi
    done
}

# Check if input arguments are provided
if (( $# < 2 )); then
    echo "Usage: $0 <start> <end>"
    exit 1
fi

# Convert input arguments to integers
start=$1
end=$2

# Call the function to find twin primes
find_twin_primes $start $end

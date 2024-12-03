#!/bin/bash

# Function to compute a^b mod c
fast_mod_exp() {
    local a=$1
    local b=$2
    local c=$3
    local r=1

    while (( b > 0 ))
    do
        if (( (b % 2) == 1 ))
        then
            r=$(( (a*r) % c ))
        fi
        a=$(( (a*a) % c ))
        b=$(( b/2 ))
    done

    echo $r
}

# Function to check if a number is prime using Fermat's test
is_prime() {
    local n=$1
    local a

    # Choose 1 < a < n-1
    for ((a=2; a<n-1; a++))
    do
        if [ $(fast_mod_exp $a $n $n) -ne $a ]
        then
            return 1
        fi
    done

    return 0
}

# Check if an argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <number>"
    exit 1
fi

# Check if the argument is a positive integer
if ! [[ $1 =~ ^[0-9]+$ ]] || [ $1 -lt 0 ]; then
    echo "Error: Invalid input. Please provide a positive integer."
    exit 1
fi

# Perform the primality test
if is_prime $1; then
    echo "$1 is probably prime."
else
    echo "$1 is not prime."
fi

#!/bin/bash

# Function to check if a number is prime
is_prime() {
    local n=$1
    local i
    if (( n == 2 ))
    then
        return 0
    elif (( n < 2  ||  n % 2 == 0 ))
    then
        return 1
    fi

    for (( i=3; i*i <= n; i+=2 ))
    do
        if (( n % i == 0 ))
        then
            return 1
        fi
    done

    return 0
}

# Initialize counter for prime numbers
count=0

m=$1
n=$2

for (( i=m; i<=n; i++ ))
do
    # Check if the number is prime
    if is_prime $i
    then
        # Increment counter if it's prime
        echo $i
        count=$((count + 1))
    fi
done

# Print the result
echo "There are $count prime numbers between $m and $n."

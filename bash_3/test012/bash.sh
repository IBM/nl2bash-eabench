#!/bin/bash
#
# 2^2 - 1 = 3 is a Mersenne prime
# 2^3 - 1 = 7 is a Mersenne prime
# 2^5 - 1 = 31 is a Mersenne prime
# 2^7 - 1 = 127 is a Mersenne prime
# 2^13 - 1 = 8191 is a Mersenne prime
# 2^17 - 1 = 131071 is a Mersenne prime
# 2^19 - 1 = 524287 is a Mersenne prime
# 2^31 - 1 = 2147483647 is a Mersenne prime
#

# Function to check if a number is prime
is_prime() {
    local i

    if (( $1 <= 1 ))
    then
        return 1
    fi

    for(( i=2; i*i <= ${1}; i++ ))
    do
        if (( $1 % i == 0 ))
        then
            return 1
        fi
    done

    return 0
}

if (( $# < 1 ))
then
    echo "Usage: $0 <number_of_mersenne_primes>" >&2
    exit 1
fi

# Initialize counter and Mersenne prime count
n=0
mersenne_primes=0

# Loop through numbers starting from 2
while (( mersenne_primes < $1 ))
do
    # Calculate Mersenne number
    mersenne=$(( $(echo "2^$n" | bc) -1))

    # Check if Mersenne number is prime
    if is_prime $mersenne
    then
        echo "2^$n - 1 = $mersenne is a Mersenne prime"
        mersenne_primes=$((mersenne_primes + 1))
    fi

    # Increment counter
    n=$((n + 1))
done


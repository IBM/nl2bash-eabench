#!/bin/bash
#
# 1001 is the product of 7, 11, 13
#

# Function to check if a number is prime
is_prime() {
    local n=$1
    local i
    if (( n < 2 ))
    then
        return 1
    fi
    for (( i=2; i*i <= n; i++ ))
    do
        if (( n % i == 0 ))
        then
            return 1
        fi
    done
    return 0
}

# Function to check if a number is palindrome
is_palindrome() {
    local n=$1
    local r=$(echo $n | rev)
    (( n == r ))
}

# Initialize variables
p1=2
p2=3
p3=3
limit=$1

# Loop through consecutive prime numbers
for(( p3=p3+2; p1*p2*p3 < limit; p3=p3+2 ))
do
    if ! is_prime $p3
    then
        continue
    fi

    product=$(( p1 * p2 * p3 ))

    # Check if the product is a palindrome
    if is_palindrome $product
    then
        echo $product is a palindrome and the product of $p1, $p2, and $p3
        break
    fi

    p1=$p2
    p2=$p3
done


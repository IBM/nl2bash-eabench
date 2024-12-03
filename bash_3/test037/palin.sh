#!/bin/bash
#
# 1001 is the product of 7, 11, 13
#

# Function to check if a number is prime
is_prime() {
    local num=$1
    if (( num < 2 ))
    then
        return 1
    fi
    for (( i=2; i*i <= num; i++ ))
    do
        if (( num % i == 0 ))
        then
            return 1
        fi
    done
    return 0
}

# Function to check if a number is palindrome
is_palindrome() {
    local num=$1
    local reversed=$(echo $num | rev)
    if [ "$num" == "$reversed" ]
    then
        return 0
    else
        return 1
    fi
}

# Initialize variables
prime1=2
prime2=3
prime3=3

# Loop through consecutive prime numbers
while true
do
    prime3=$(( prime3 + 2 ))
    if ! is_prime $prime3
    then
        continue
    fi

    product=$(( prime1 * prime2 * prime3 ))

    # Check if the product is a palindrome
    if is_palindrome $product
    then
        echo $product is a palindrome and the product of $prime1, $prime2, and $prime3
        #break
    fi

    prime1=$prime2
    prime2=$prime3
done


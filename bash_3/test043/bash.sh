#!/bin/bash
#
# bash.sh 100 900
#

# Function to check if a number is prime
is_prime() {
    local n=$1
    local i
    if (( n == 2 ))
    then
        return 0
    fi
    if (( n < 2  ||  n % 2 == 0 ))
    then
        return 1
    fi
    for(( i=3; i*i<=n; i+=2 ))
    do
        if (( n % i == 0 ))
        then
            return 1
        fi
    done
    return 0
}

# Function to rotate the digits of a number
rotate() {
    local num=$1
    local last_digit=$(( num % 10 ))
    local rotated=$(( num / 10 ))
    #echo >&2 -n "$num --> "
    while (( rotated > 0 )); do
        rotated=$(( rotated / 10 ))
        last_digit=$(( last_digit * 10 ))
    done
    num=$(( last_digit + num / 10 ))
    #echo >&2 "$num"
    echo $num
}

start=$1
limit=$2

# Find all circular primes between 100 and 1000
for (( i=start; i<=limit; i++ ))
do
    if is_prime $i
    then
        is_circular_prime=1
        for (( r=$(rotate $i); r!=i; r=$(rotate $r) ))
        do
            if ! is_prime $r
            then
                is_circular_prime=0
                break
            fi
        done
        if (( is_circular_prime == 1 ))
        then
            echo $i
        fi
    fi
done

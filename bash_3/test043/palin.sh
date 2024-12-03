#!/bin/bash

# Function to check if a number is prime
is_prime() {
    local num=$1
    local i
    if (( num <= 1 ))
    then
        return 1
    fi
    for (( i=2; i*i<=num; i++ ))
    do
        if (( num % i == 0 ))
        then
            return 1
        fi
    done
    return 0
}

# Function to rotate the digits of a number
rotate() {
    local num=$1
    local last=$(( num % 10 ))
    #echo >&2 -n "$1: "
    local rot=$(( num / 10 ))
    while (( rot > 0 ))
    do
        rot=$(( rot / 10 ))
        last=$(( last * 10 ))
    done
    num=$(( last + num / 10 ))
    #echo >&2 "$num"
    echo $num
}

# Function to check if a number is a circular prime
is_circular_prime() {
    local num=$1
    if ! is_prime $num
    then
        return 1
    fi
    local original_num=$num
    while true
    do
        num=$(rotate $num)
        if ! is_prime $num
        then
            return 1
        fi
        if (( num == original_num ))
        then
            #echo >&2 "$num"
            return 0
        fi
    done
}

# Function to check if a number is a palindrome in a given base
is_palindrome() {
    local n=$1
    local r

    r=$(echo $n | rev)
    if [ "$n" == "$r" ]
    then
        return 0
    else
        return 1
    fi
}

# Find all circular primes from 100 to 1000
for (( i=9; i<10000; i+=2 ))
do
    if is_circular_prime $i
    then
        if is_palindrome $i
        then
            echo "$i is circular and palindromic"
        else
            echo "$i is circular"
        fi
    fi
done

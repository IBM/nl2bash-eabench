#!/bin/bash

# Function to compute the greatest common divisor of $a$ and $b$
function gcd() {
    local a=$1
    local b=$2
    while (( $a != $b ))
    do
        if (( $a > $b ))
        then
            a=$(( a - b ))
        else
            b=$(( b - a ))
        fi
    done
    echo $a
}


# Function to compute Euler's totient function
phi() {
    local n=$1
    local result=0
    for (( i=1; i<=n; i++ ))
    do
        if (( $(gcd $i $n) == 1 ))
        then
            result=$(( result + 1 ))
        fi
    done
    echo $result
}

echo $(phi $1)

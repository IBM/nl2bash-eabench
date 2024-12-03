#!/bin/bash

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

# Function to calculate modular power
function mexp() {
    local b=$1
    local e=$2
    local m=$3
    local c=1

    #echo >&2 "mexp $b $e $m"

    # (a*b) mod m = (a mod m) * (b mod m)
    # b^(2*e+1) mod m = (b^(2*e) mod m) * (b mod m)
    while (( e > 0 ))
    do
        if (( e % 2 == 1 ))
        then
            c=$(( (b*c) % m ))
        fi
        e=$(( e/2 ))
        b=$(( (b*b) % m ))
    done

    echo $c
}

# Function to check if a number is prime
is_prime() {
    local num=$1
    if (( num <= 1 )); then
        return 1
    fi
    for (( i=2; i*i<=num; i++ ))
    do
        if (( num % i == 0 )); then
            return 1
        fi
    done
    return 0
}

# Function to check if a number is a Carmichael number
is_carmichael() {
    local n=$1
    local b
    for (( b=2; b<n; b++ ))
    do
        # Check if n is coprime to base b
        if (( $(gcd $b $n) == 1 ))
        then
            if (( $(mexp $b $((n-1)) $n) != 1 ))
            then
                return 1
            fi
        fi
    done
    return 0
}


# Check if the argument is a prime number, a Carmichael number or a composite number
num=$1
if is_prime $num; then
    echo "Prime"
    exit 0
elif is_carmichael $num; then
    echo "Carmichael"
    exit 0
else
    echo "Composite"
    exit 1
fi

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

# Function to calculate power
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

function is_prime {
    local n=$1
    local i

    if (( n == 2 ))
    then
        return 0
    fi

    if (( n < 2  ||  n % 2 == 0 ))
    then
        #echo >&2 "is_prime(fail) mod 2"
        return 1
    fi

    for(( i=3; i*i<=n; i+=2 ))
    do
        if (( n % i == 0 ))
        then
            #echo >&2 "is_prime(fail) mod $i"
            return 1
        fi
    done

    return 0
}


function is_pseudoprime() {
    local n=$1
    local b=$2

    # We're not looking for primes, only pseudoprimes
    if is_prime $n
    then
        #echo >&2 "fail: is $n prime"
        return 1
    fi

    # Fermat's test
    local r=$(mexp $b $((n-1)) $n)
    if (( r % n != 1 ))
    #if (( r != 1 ))
    then
        #echo >&2 "fail: mexp $b $((n-1)) $n --> $r"
        return 1
    fi

    #echo >&2 "PASS: mexp $b $((n-1)) $n --> $r"
    return 0
}

# Check if argument is provided
if [ -z "$1" ]
then
    echo "Usage: $0 <base>"
    exit 1
fi

# Check if the number is greater than 1
if [ "$1" -le 1 ]
then
    echo "Number should be greater than 1"
    exit 1
fi

n=$1
base=$2

if is_pseudoprime $n $base
then
    echo true
else
    echo false
fi

#!/bin/bash
#
# Carmichael numbers: composite numbers k such that b^(k-1) == 1 (mod k) for every b coprime to k.
#

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

function is_prime {
    local n=$1
    local i

    if (( n < 2 ))
    then
        return 1
    fi

    if (( n % 2 == 0 ))
    then
        return 1
    fi

    for(( i=3; i*i<n; i+=2 ))
    do
        if (( n % i == 0 ))
        then
            return 1
        fi
    done

    return 0
}

#
# From a very close reading of the Wikipedia page
#  b^n = b (mod n), for all integers b
#
function carmichael_test1() {
    local n=$1
    local a

    # weed out the primes
    if is_prime $n
    then
        #echo >&2 "$n is prime"
        return 1
    fi

    for (( a=2; a<n; a++ ))
    do
        # no coprime requirement if using b^n) == b (mod n)
        local r=$(mexp $a $n $n)
        if (( r != a ))
        then
            #echo >&2 "fail: mexp $a $n $n --> $r"
            return 1
        fi
    done
    return 0
}

#
# From a very close reading of the Wikipedia page
#  b^(n-1) = 1 (mod n), for all integers b coprime to n
#
function carmichael_test2() {
    local n=$1
    local a

    # weed out the primes
    if is_prime $n
    then
        #echo >&2 "$n is prime"
        return 1
    fi

    for (( a=2; a<n; a++ ))
    do
        # a and n must be coprime if using b^(n-1) == 1 (mod n)
        if (( $(gcd $a $n) == 1 ))
        then
            local r=$(mexp $a $((n-1)) $n)
            echo >&2 "mexp $a $((n-1)) $n --> $r"
            if (( r % n != 1 ))
            then
                #echo >&2 "fail: mexp $a $n $n --> $r"
                return 1
            fi
        fi
    done
    return 0
}

# Check if argument is provided
if [ -z "$1" ]
then
    echo "Usage: $0 <number>"
    exit 1
fi

# Check if the number is greater than 1
if [ "$1" -le 1 ]
then
    echo "Number should be greater than 1"
    exit 1
fi

carmichael_test2 $1

# Print result
if [ $? -eq 0 ]
then
    echo "$1 is a Carmichael number"
else
    echo "$1 is not a Carmichael number"
fi

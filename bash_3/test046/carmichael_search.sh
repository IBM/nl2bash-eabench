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


function is_carmichael() {
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

function carmichael_test() {
    local n=$1
    local a
    for (( a=2; a<n; a++ ))
    do
        # a and n must be coprime if using b^(n-1) == 1 (mod n)
        if (( $(gcd $a $n) == 1 ))
        then
            local r=$(mexp $a $((n-1)) $n)
            if (( r % n != 1 ))
            then
                echo >&2 "fail: mexp $a $n $n --> $r"
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

for(( n=500001; n<600000; n+=2 ))
do
    if is_carmichael $n
    then
        echo "$n is a Carmichael number"
    fi
done

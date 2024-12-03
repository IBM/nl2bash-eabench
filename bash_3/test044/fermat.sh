#!/bin/bash
#
# There seems to be a subtle difference between Fermat and Carmichael
#  - Fermat simply checks for modulus 1
#  - Carmichael won't use Fermat is the base and test number are not coprime
# So Fermat will say the Carmichaels 561, 1105, 1729, ... are not prime
#
# ... sort of... weirdly, there's a variant test that seems equivalent
# but doesn't seem to need a check for coprime... rather than
#     b^(n-1) = 1 (mod n)  (need check for coprime)
# use
#     b^n = b (mod n)      (skip coprime test)
#

# Function to calculate power
function mexp() {
    local b=$1
    local e=$2
    local m=$3
    local c=1

    #echo >&2 "mexp $b^$e mod $m"

    # (a*b) % m = (a % m) * (b % m)
    # b^(2*e+1) % m = (b^(2*e) % m) * (b % m)
    # b^(2*e) % m = (b^2)^e % m = ((b^2) % m)^e
    while (( e > 0 ))
    do
        if (( e % 2 == 1 ))
        then
            c=$(( (c*b) % m ))
        fi
        e=$(( e/2 ))
        b=$(( (b*b) % m ))
    done

    echo $c
}


# Function to check primality using Fermat's primality test
fermat_test() {
    local n=$1
    local a
    local r
    for (( a=2; a<n-1; a++ ))
    do
        r=$(mexp $a $((n-1)) $n)
        if (( r != 1 ))
        then
            #echo >&2 "mexp $a $((n-1)) $n --> $r"
            return 1
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

# Perform Fermat's primality test
fermat_test $1

# Print result
if [ $? -eq 0 ]
then
    echo "$1 is probably prime"
else
    echo "$1 is not prime"
fi

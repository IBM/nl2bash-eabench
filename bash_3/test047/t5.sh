#!/bin/bash
#
#Write a bash script which outputs "prime" if its argument is a prime number or "carmichael" if it is a Carmichael number (using modular exponentiation) or "composite" if it is a composite number.
#

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

function is_prime() {
    if [ "$1" -eq 2 ]; then
        echo "prime"
    elif [ "$1" -eq 1 ] || [ "$(($1 % 2))" -eq 0 ]; then
        echo "composite"
    else
        for (( i=3; i*i<= $1; i+=2 )); do
            if [ "$(($1 % i))" -eq 0 ]; then
                echo "composite"
                return
            fi
        done
        echo "prime"
    fi
}

function is_carmichael() {
    local n=$1
    if [ "$(is_prime $n)" == "prime" ]
    then
        echo "prime"
    else
        local k=0
        local i
        for (( i=2; i<$n; i++ ))
        do
            if [ "$(($n % i))" -eq 0 ]; then
                k=$(($k + 1))
                a[$k]=$i
            fi
        done
        if [ "$k" -lt 2 ]; then
            echo "composite"
            return
        fi
        for (( i=1; i<=$k; i++ )); do
            if [ "$(($(($a[$i] ** ($n - 1)) % $n)))" -ne 1 ]; then
                echo "composite"
                return
            fi
        done
        echo "carmichael"
    fi
}

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <number>"
    exit 1
fi

if ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "Error: argument is not a number"
    exit 1
fi

if [ "$1" -lt 1 ]; then
    echo "Error: argument is less than 1"
    exit 1
fi

echo "$(is_carmichael $1)"

#!/bin/bash

function is_prime() {
    local num=$1
    local i
    if (( num < 2 )); then
        return 1
    fi
    for (( i = 2; i * i <= num; i++ )); do
        if (( num % i == 0 )); then
            return 1
        fi
    done
    return 0
}

function prime_factors() {
    local num=$1
    local i=2
    while (( i*i <= num ))
    do
        if is_prime $i
        then
            while (( num % i == 0 ))
            do
                echo $i
                num=$(( num / i ))
            done
        fi
        (( i++ ))
    done

    if (( num > 1 ))
    then
        echo $num
    fi
}

if (( $# != 1 )); then
    echo "Usage: $0 <positive integer>"
    exit 1
fi

if ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "Error: argument must be a positive integer"
    exit 1
fi

prime_factors $1

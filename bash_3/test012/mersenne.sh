#!/bin/bash

is_prime() {
    local num=$1
    local i

    if (( num < 2 ))
    then
        return 1
    fi

    for (( i = 2; i * i <= num; i++ ))
    do
        if (( num % i == 0 ))
        then
            return 1
        fi
    done

    return 0
}

if (( $# < 1 ))
then
    echo "Usage: $0 <number_of_mersenne_primes>" >&2
    exit 1
fi

n=$1
i=2
count=0

while (( count < n )); do
    if is_prime $i
    then
        mersenne=$(( (1 << $i) - 1 ))

        if is_prime $mersenne
        then
            echo $mersenne
            count=$((count + 1))
        fi
    fi

    i=$((i + 1))
done

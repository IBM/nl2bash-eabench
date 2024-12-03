#!/bin/bash

is_prime() {
    local num=$1
    local i
    if (( num < 2 ))
    then
        return 1
    fi
    for(( i=2; i*i <= num; i++ ))
    do
        if (( num % i == 0 ))
        then
            return 1
        fi
    done
    return 0
}

is_palindrome() {
    local n=$1
    local r=$(echo $n | rev)
    if [ "$n" == "$r" ]
    then
        return 0
    else
        return 1
    fi
}

limit=$1
i=2
for(( j=3; j<limit; j+=2 ))
do
    if is_prime $j
    then
        sum=$(( i + j ))
        prod=$(( i * j ))
        if is_palindrome $sum && is_palindrome $prod
        then
            echo "$i $j"
        fi
        i=$j
    fi
done

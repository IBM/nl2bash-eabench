#!/bin/bash

is_prime() {
    local num=$1
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

is_palindrome() {
    local num=$1
    local reversed=$(echo $num | rev)
    if [ "$num" == "$reversed" ]
    then
        return 0
    else
        return 1
    fi
}

p1=3
for (( p2=5; p2<10000; p2+=2 ))
do
    if is_prime $p2; then
        sum=$(( p1 + p2 ))
        prod=$(( p1 * p2 ))
        if is_palindrome $sum && is_palindrome $prod
        then
            echo "$p1 $p2"
            break
        fi
        p1=$p2
    fi
done


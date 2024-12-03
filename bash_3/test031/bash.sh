#!/bin/bash

is_prime() {
    local num=$1
    local i
    if (( num <= 1 ))
    then
        return 1
    fi

    for(( i=2; i*i<=num; i++ ))
    do
        if(( num % i == 0 ))
        then
            return 1
        fi
    done
    return 0
}

reverse_number() {
    local num=$1
    local r=0
    while (( $num > 0 ))
    do
        r=$(( $r * 10 + $num % 10 ))
        num=$(( $num/10 ))
    done
    echo $r
}

n=$1
for(( i=n+1; ; i++ ))
do
    if is_prime $i
    then
        #echo Trying $i
        r=$(reverse_number $i)
        #echo Reversed $r
        if (( $i == $r ))
        then
            echo "First palindromic prime greater than $n: $i"
            break
        fi
    fi
done

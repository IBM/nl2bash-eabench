#!/bin/bash

function is_prime {
    local n=$1
    local i

    if (( n == 2 ))
    then
        return 0
    fi

    if (( n < 2  ||  n % 2 == 0 ))
    then
        return 1
    fi

    for(( i=3; i*i<=n; i+=2 ))
    do
        if (( n % i == 0 ))
        then
            return 1
        fi
    done

    return 0
}

function is_palindromic() {
    local n=$1
    local r=$(echo $n | rev)
    (( n == r ))
}


limit=$1
count=0
for(( n=2; n<limit; n++ ))
do
    if is_prime $n
    then
        if is_palindromic $n
        then
            #echo >&2 $n
            count=$((count+1))
        fi
    fi
done
echo $count

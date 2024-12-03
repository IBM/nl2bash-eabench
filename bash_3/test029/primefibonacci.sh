#!/bin/bash

function is_prime {
    local n=$1
    local i=2

    if (( n < 2 ))
    then
        return 1
    fi

    while (( i*i < n ))
    do
        if (( n % i == 0 ))
        then
            return 1
        fi
        i=$(( i + 1 ))
    done

    return 0
}


limit=$1
f0=0
f1=1

while (( (f0+f1) < limit ))
do
    f=$(( f0 + f1 ))
    if is_prime $f
    then
        echo $f
    fi
    f0=$f1
    f1=$f
done


#!/bin/bash

factorial() {
    local n=$1
    local p=1
    local i
    for (( i=2; i<=n; i++ ))
    do
        p=$(( p * i ))
    done
    echo $p
}

sum() {
    local n=$1
    local s=0
    local d
    while (( n ))
    do
        d=$(( n % 10 ))
        n=$(( n / 10 ))
        s=$(( $s + $(factorial d) ))
    done
    echo $s
}

for (( i=1; i<2000; i++ ))
do
    s=$(sum $i)
    if (( s == i ))
    then
        echo $i
    fi
done

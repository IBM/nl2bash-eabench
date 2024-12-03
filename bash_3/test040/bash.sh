#!/usr/bin/env bash

gcd() {
    local a=$1
    local b=$2
    while (( b ))
    do
        local t=$b
        b=$(( a % b ))
        a=$t
    done
    echo $a
}

lcm() {
    local a=$1
    local b=$2
    echo $(( (a * b) / $(gcd $a $b) ))
}

lcm $1 $2

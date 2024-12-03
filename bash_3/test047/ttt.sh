#!/bin/bash

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
    if [ "$(is_prime $1)" == "composite" ]; then
        k=0
        for (( i=2; i<$1; i++ )); do
            if [ "$(($1 % i))" -eq 0 ]; then
                k=$(($k + 1))
                a[$k]=$i
            fi
        done
        if [ "$k" -lt 2 ]; then
            echo "composite"
            return
        fi
        for (( i=1; i<=$k; i++ )); do
            if [ "$(($(($a[$i] ** ($1 - 1)) % $1)))" -ne 1 ]; then
                echo "composite"
                return
            fi
        done
        echo "carmichael"
    else
        echo "prime"
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

is_carmichael $1

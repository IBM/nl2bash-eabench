#!/bin/bash

function fermat_test() {
    local base=$1
    local number=$2
    local mod=$((number ** base % number))
    if [ "$mod" -eq 1 ]; then
        echo "$number is a probable prime base $base"
    else
        echo "$number is not a probable prime base $base"
    fi
}

function find_smallest_fermat_prime() {
    local base=$1
    local number=$base
    while true; do
        fermat_test $base $number
        if [ "$?" -eq 0 ]; then
            echo "$number"
            return
        fi
        number=$((number + 1))
    done
}

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <base>"
    exit 1
fi

find_smallest_fermat_prime $1

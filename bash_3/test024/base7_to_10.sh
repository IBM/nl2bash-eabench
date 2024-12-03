#!/bin/bash

function base7_to_10() {
    local num=$1
    local result=""
    local remainder=0

    # Check if the input is a valid base 7 number
    if ! [[ $num =~ ^[0-6]+$ ]]; then
        echo "Error: Invalid base 7 number"
        return 1
    fi

    # Convert from base 7 to decimal
    local decimal=0
    local power=0
    #echo ${#num}
    for ((i=${#num}-1; i>=0; i--)); do
        #echo ${num:i:1} " times " $((7 ** power))
        decimal=$((decimal + ${num:i:1} * (7 ** power)))
        power=$((power + 1))
    done

    echo $decimal
}

base7_to_10 $1

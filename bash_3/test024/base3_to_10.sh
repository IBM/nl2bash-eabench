#!/bin/bash


function base3_to_10() {
    local num=$1
    local result=""
    local remainder=0

    # Check if the input is a valid base 7 number
    if ! [[ $num =~ ^[0-2]+$ ]]; then
        echo "Error: Invalid base 3 number"
        return 1
    fi

    # Convert from base 3 to decimal
    local decimal=0
    local power=0
    #echo ${#num}
    for ((i=${#num}-1; i>=0; i--)); do
        #echo ${num:i:1} " times " $((3 ** power))
        decimal=$((decimal + ${num:i:1} * (3 ** power)))
        power=$((power + 1))
    done

    echo $decimal
}


base3_to_10 $1


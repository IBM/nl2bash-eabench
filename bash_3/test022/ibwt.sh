#!/bin/bash
#
# Mississippi
# 'ipssm$pissii'
#
# Bookkeeper
# 'r$kepkoobee'
#
# Accommodation
# 'n$dacotomomcia'
#

# Function to perform inverse Burrows-Wheeler transform
ibwt() {
    local bwt="$1"      # $(echo "$1" | sed -e 's+\$+\\$+g')
    local len=${#bwt}
    local rotations=()
    local original_str=""

    echo "Input: " $bwt
    echo "Length: " $len
    for(( i=0; i<len; i++ ))
    do
        rotations[$i]=${bwt:i:1}
    done

    echo Initial
    for(( i=0; i<len; i++ ))
    do
        echo ${rotations[i]}
    done

    for(( j=0; j<len-1; j++ ))
    do
        IFS=$'\n' rotations=($(sort -s <<<"${rotations[*]}"))
        unset IFS

        echo Sorted $j
        for(( i=0; i<len; i++ ))
        do
            echo ${rotations[i]}
        done

        for(( i=0; i<len; i++ ))
        do
            rotations[$i]=${bwt:i:1}${rotations[i]}
        done
    done

    IFS=$'\n' rotations=($(sort -s <<<"${rotations[*]}"))
    unset IFS

    for(( i=0; i<len; i++ ))
    do
        echo "MinusOne: " ${rotations[i]}
        if [[ "${rotations[i]: -1}" == "$" ]]; then
            #answer="${rotations%$}"
            answer="${rotations[i]%$}"
        fi
    done

    echo Answer: $answer
}

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <bwt_string>"
    exit 1
fi

echo argument is "$1"
ibwt $1

#!/bin/bash
#
# mississippi
# 'ipssm$pissii'
#
# bookkeeper
# 'r$kepkoobee'
#
# accommodation
# 'n$dacotomomcia'
#

# Function to perform inverse Burrows-Wheeler transform
ibwt() {
    local bwt="$1"      # $(echo "$1" | sed -e 's+\$+\\$+g')
    local len=${#bwt}
    local rotations=()
    local original_str=""

    for(( i=0; i<len; i++ ))
    do
        rotations[$i]=${bwt:i:1}
    done

    for(( j=0; j<len-1; j++ ))
    do
        IFS=$'\n' rotations=($(sort -s <<<"${rotations[*]}"))
        unset IFS

        for(( i=0; i<len; i++ ))
        do
            rotations[$i]=${bwt:i:1}${rotations[i]}
        done
    done

    IFS=$'\n' rotations=($(sort -s <<<"${rotations[*]}"))
    unset IFS

    for(( i=0; i<len; i++ ))
    do
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

ibwt $1

#!/bin/bash
#
# Mississippi
# ipssm$pissii
#
# Bookkeeper
# r$kepkoobee
#
# Accommodation
# n$dacotomomcia
#

# Function to compute the Burrows-Wheeler Transform
bwt() {
    local input="$1""$"
    local len=${#input}
    local rotations=()

    # Generate all rotations of the input string
    for (( i=0; i<len; i++ )); do
        rotations+=("${input:i}${input:0:i}")
    done

#    echo Rotated
#    for s in ${rotations[@]}
#    do
#        echo $s
#    done

#    echo ""
#    echo "Sorted"
#    echo ${rotations[*]}
#    IFS=$'\n' sort -s <<<"${rotations[*]}"

    # Sort the rotations lexicographically
#    echo ""
    IFS=$'\n' sorted=($(sort -s <<<"${rotations[*]}"))
    unset IFS

#    echo Sorted again
#    for s in ${sorted[@]}
#    do
#        echo $s
#    done
#    echo ""

    # Extract the last column of the sorted rotations
    local bwt_result=""
    for rotation in "${sorted[@]}"; do
        bwt_result+="${rotation: -1}"
    done

    echo "$bwt_result"
}

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <string>"
    exit 1
fi

bwt "$1"

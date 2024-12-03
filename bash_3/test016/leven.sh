#!/bin/bash
#
# Write a bash script which outputs the Levenshtein distance between two strings given as arguments.
# Write a bash script which computes the Levenshtein distance between two strings.
#
# Levenshtein 
# kitten sitting
# satudary sunday
#
# Usage: ./levenshtein.sh string1 string2

function min() {
    local m=$1
    shift
    while(( $# ))
    do
        m=$(( $m < $1 ? $m : $1 ))
        shift
    done

    echo $m
}

string1=$1
string2=$2

len1=${#string1}
len2=${#string2}

declare -A matrix

for ((i=0; i<=$len1; i++))
do
    matrix[$i,0]=$i
done

for ((j=0; j<=$len2; j++))
do
    matrix[0,$j]=$j
done

for ((i=1; i<=$len1; i++))
do
    for ((j=1; j<=$len2; j++))
    do
        if [[ ${string1:i-1:1} == ${string2:j-1:1} ]]
        then
            cost=0
        else
            cost=1
        fi
        x=$(( i-1 ))
        y=$(( j-1 ))
        matrix[$i,$j]=$(min matrix[$x,$j]+1 matrix[$i,$y]+1 matrix[$x,$y]+$cost)
        echo "matrix[$i,$j]=" $((matrix[$i,$j])) " (cost=$cost)"
    done
    for(( j=0; j<$len2; j++ ))
    do
        printf "matrix[%d,%d]=%d\n" $i $j ${matrix[$i,$j]}
    done
done

echo ${matrix[$len1,$len2]}

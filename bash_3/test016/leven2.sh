#!/bin/bash
#
# Write a bash script which computes the Levenshtein distance between two strings.
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

function xin() {
    echo $*
}

string1=$1
string2=$2

len1=${#string1}
len2=${#string2}

declare -a P
declare -a C

for(( j=0; j<=$len2; j++ ))
do
    P[$j]=$j
done

for ((i=1; i<=$len1; i++))
do
    C[0]=$i
    for ((j=1; j<=$len2; j++))
    do
        if [[ ${string1:i-1:1} == ${string2:j-1:1} ]]
        then
            cost=0
        else
            cost=1
        fi
        #matrix[$i,$j]=$(($(min matrix[$i-1,$j]+1 matrix[$i,$j-1]+1 matrix[$i-1,$j-1]+$cost) ))
        C[$j]=$(min $((P[j]+1)) $((C[j-1]+1)) $((P[j-1]+cost)) )
    done
    for(( j=0; j<=$len2; j++ ))
    do
        P[$j]=$((C[j]))
    done
done

#echo ${matrix[$len1,$len2]}
echo ${P[$len2]}

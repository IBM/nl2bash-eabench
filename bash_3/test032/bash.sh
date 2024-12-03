#!/bin/bash
#
# sum of the factors equals the number
#  - ALL factors
#  - factor doesn't have to be prime
#  - 28 = 1 + 2 + 4 + 7 + 14
#
count=$1
num=1
sum=0

# if it divides, it adds
while(( count > 0 ))
do
    for (( i=1; i<=num/2; i++ ))
    do
        if (( num % i == 0 ))
        then
            sum=$((sum+i))
            if (( sum > num ))
            then
                break
            fi
        fi
    done

    if (( sum == num ))
    then
        echo "Perfect number: $num"
        count=$((count-1))
    fi

    sum=0
    num=$((num+1))
done

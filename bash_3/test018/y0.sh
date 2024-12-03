#!/bin/bash

count=0
num=2

while [ $count -lt 100 ]
do
    is_prime=1

    for (( i=2; i<num; i++ ))
    do
        if [ $(($num%$i)) -eq 0 ]
        then
            is_prime=0
            break
        fi
    done

    if [ $is_prime -eq 1 ]
    then
        echo $num
        count=$((count+1))
    fi

    num=$((num+1))
done

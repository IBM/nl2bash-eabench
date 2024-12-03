#!/bin/bash

for num in $(seq 10 $1)
do
    count=0
    for base in {2..16}
    do
        n=$(echo "obase=$base; $num" | bc)
        r=$(echo "$n" | rev)
        if [ "$n" == "$r" ]
        then
            count=$((count+1))
        fi
    done
    if [[ $count -eq 3 ]]
    then
        echo $num
    fi
    count=0
done

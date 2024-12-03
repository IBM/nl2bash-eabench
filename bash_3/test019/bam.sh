#!/bin/bash

for (( i=2; i<=1000; i++ ))
do
    is_prime=$(( $(echo "$i > 2 && $(($i % 2)) != 0 && $(($i % 3)) != 0 && $(seq 5 $(( $(($i ** 0.5)) )) | while read j; do (( $(($i % $j)) != 0 && $(($i % ($j + 2))) != 0 )); done) " ))
    if [ $is_prime -eq 1 ]; then
        j=$(( $i + 2 ))
        is_prime_j=$(( $(echo "$j > 2 && $(($j % 2)) != 0 && $(($j % 3)) != 0 && $(seq 5 $(( $(($j ** 0.5)) )) | while read k; do (( $(($j % $k)) != 0 && $(($j % ($k + 2))) != 0 )); done) " ))
        if [ $is_prime_j -eq 1 ]; then
            echo "$i $j"
        fi
    fi
done

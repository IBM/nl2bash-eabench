#!/bin/bash

for n in {1..5};
do
    lim=$((1000 + RANDOM % 1000))
    # for i in {1..$lim};
    # do
    #     echo "Hello World" >> test$n.txt
    # done
    for (( i = 0; i < lim; i++ )); do
	    echo "Hello World" >> test$n.txt
    done
done
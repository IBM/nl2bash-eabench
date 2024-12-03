#!/bin/bash
#
# Write a bash script to output the nth Fibonacci number where n is passed as an argument.
# Write a bash script which takes an argument n and finds the nth Fibonacci number.
#
# 1 1
#
# 10 55
#
# 25 75025
#
# 50 12586269025

if [ -z "$1" ]
then
    echo "Usage: $0 <n>"
    exit 1
fi

n=$1

if [ "$n" -lt 1 ]
then
    echo "Error: n must be a positive integer."
    exit 1
fi

# Initialize the first two Fibonacci numbers
a=0
b=1

# Calculate the nth Fibonacci number
for ((i=2; i<=$n; i++))
do
    c=$((a+b))
    a=$b
    b=$c
done

echo "The $nth Fibonacci number is $b"

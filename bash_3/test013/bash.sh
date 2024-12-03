#!/bin/bash

# Initialize variables
x=2
g=$1
iterations=4

echo "Iteration 1: $g"

for ((i=2; i<=iterations; i++)); do
  g=$(echo "($g + $x / $g) / 2" | bc -l)
  #echo "Iteration $i: $g"
done

echo "The square root of two is approximately $g"

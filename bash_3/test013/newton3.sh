#!/bin/bash

# Initialize variables
x=$(echo "sqrt(2)" | bc -l)
g=100
precision=0.001

echo "Initial guess: $g"

# Loop until desired precision is achieved
while true; do
    # Compute the next guess
    g=$(echo "$g - ($g^2-2)/$g / 2" | bc -l)

    # Check if the next guess is close enough to the current guess
    if (( $(echo "($g-$x) < $precision" | bc -l) ))
    then
        echo "Square root of $x: $g"
        p=$(echo "($g-$x)" | bc -l)
        echo "$p is less than $precision"
        break
    else
        echo "Next guess: $g"
    fi
done


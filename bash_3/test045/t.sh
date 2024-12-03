#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 base exponent modulus"
    exit 1
fi

# Assign the arguments to variables
base=$1
exponent=$2
modulus=$3

# Initialize the result to 1
result=1

# Loop through the bits of the exponent from the least significant bit to the most significant bit
for (( i=$exponent; i>0; i=i>>1 )); do
    # If the current bit is set, multiply the result by the base and take the modulus
    if [ "$(($i & 1))" -eq 1 ]; then
        result=$(( ($result * $base) % $modulus ))
    fi

    # Square the base and take the modulus
    base=$(( ($base * $base) % $modulus ))
done

# Print the result
echo $result

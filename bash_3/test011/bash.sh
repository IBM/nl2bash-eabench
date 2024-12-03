#!/bin/bash
#
# Write a bash script to find the greatest common divisor of its two integer arguments.
#
# ./gcd.sh 9504167 12677501
# ./gcd.sh 42 56
#

# Function to find the GCD of two numbers
gcd() {
    local a=$1
    local b=$2
    #printf "\n%d %d\n" $a $b
    while [ $a -ne $b ]; do
        if [ $a -gt $b ]; then
            a=$(( a - b ))
        else
            b=$(( b - a ))
        fi
        #printf "%d %d\n" $a $b
    done
    echo $a
}

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <integer1> <integer2>"
    exit 1
fi

# Call the gcd function with the provided arguments
result=$(gcd "$1" "$2")

# Print the result
echo "The GCD of $1 and $2 is: $result"


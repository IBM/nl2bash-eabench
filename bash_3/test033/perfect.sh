#!/bin/bash

# Function to check if a number is perfect
is_perfect() {
    local sum=0
    local n=$1
    local i
    for (( i=1; i<=n/2; i++ ))
    do
        if (( n % i == 0 ))
        then
            sum=$(( sum + i ))
            if (( sum > n ))
            then
                return 1
            fi
        fi
    done
    if (( sum == n ))
    then
        return 0
    else
        return 1
    fi
}

# Check if the argument is a positive integer
if ! [[ $1 =~ ^[1-9][0-9]*$ ]]; then
    echo "Usage: $0 <positive integer>"
    exit 1
fi


# Loop until we find a perfect number
for (( i=$1+1; ; i++ ))
do
    # Check if the current number is perfect
    if $(is_perfect $i)
    then
        break
    fi
done

# Print the perfect numbers
echo "The first perfect number greater than $1 is $i"


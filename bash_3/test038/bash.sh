#!/bin/bash
#
# 0,1,1,2,3,5,8,13,21,34,
#

is_palindrome() {
    local n=$1
    local r=$(echo $n | rev)
    (( n == r ))
}

# Initialize variables
fib0=0
fib1=1
fib=$fib0
count=0
limit=$1

# Loop until next is less than 100
while (( fib < limit ))
do
    # Check if next is a palindrome
    if is_palindrome $fib
    then
        echo $fib
        count=$((count + 1))
    fi

    # Update variables
    fib0=$fib1
    fib1=$fib
    fib=$(( fib0 + fib1 ))
done

# Print result
echo $count

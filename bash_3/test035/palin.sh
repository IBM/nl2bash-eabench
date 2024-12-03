#!/bin/bash

# Function to check if a number is a palindrome in a given base
is_palindrome() {
    local n=$1
    local r

    r=$(echo $n | rev)
    if [ "$n" == "$r" ]
    then
        return 0
    else
        return 1
    fi
}

# Find the first number which is a palindrome in base 2, base 8, and base 16
for (( num=$1; ; num++ ))
do
    # Check if the number is a palindrome in base 2
    b2=$(echo "obase=2; ibase=10; $num" | bc)
    if $(is_palindrome $b2)
    then
        # Check if the number is a palindrome in base 8
        b8=$(echo "obase=8; ibase=10; $num" | bc)
        if $(is_palindrome $b8)
        then
            # Check if the number is a palindrome in base 16
            b16=$(echo "obase=16; ibase=10; $num" | bc)
            if $(is_palindrome $b16)
            then
                echo "The first number which is a palindrome in base 2, base 8, and base 16 is $num"
                echo "base2:  $b2"
                echo "base8:  $b8"
                echo "base16: $b16"
                break
            fi
        fi
    fi
done

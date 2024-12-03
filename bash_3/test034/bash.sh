#!/bin/bash
#
# ./bash.sh 121
# 3: 11111  11111
# 7: 232  232
# 8: 171  171
# 10: 121  121
#
# ./bash.sh 1911
# 2: 11101110111  11101110111
# 16: 777  777
#
# ./bash.sh 1991
# 10: 1991  1991
# 16: 7C7  7C7
#
# ./bash.sh 1913
# 3: 2121212  2121212
# 14: 9A9  9A9
# 15: 878  878
#
# ./bash.sh 1921
# 6: 12521  12521
#

# Function to convert a number to a given base
function convert_to_base() {
    local num=$1
    local base=$2
    local digits="0123456789ABCDEF"
    local out=""

    while [ $num -gt 0 ]; do
        local rem=$(( $num % $base ))
        out="${digits:$rem:1}$out"
        num=$(( $num / $base ))
    done

    echo "$out"
}

# Function to check if a number is a palindrome in a given base
function is_palindrome() {
    local num=$1
    local base=$2
    local digits="0123456789ABCDEF"

    local num_str=$(convert_to_base "$num" "$base")
    local len=${#num_str}

    for (( i = 0; i < len / 2; i++ )); do
        if [ "${num_str:$i:1}" != "${num_str:$(( len - i - 1 )):1}" ]; then
            return 1
        fi
    done

    return 0
}

# Check if the input argument is a positive integer
if ! [[ $1 =~ ^[0-9]+$ ]] || [ $1 -lt 0 ]; then
    echo "Error: Input argument must be a positive integer."
    exit 1
fi

# Check each base from 2 to 16
for base in $(seq 2 16); do
    # Check if the number is a palindrome in this base
    if is_palindrome "$1" "$base"; then
        # Convert the number to this base and print the result
        converted=$(convert_to_base "$1" "$base")
        #echo "$base: $converted " $(echo "obase=$base; ibase=10; $1" | bc)
        echo "$base: $converted"
    fi
done


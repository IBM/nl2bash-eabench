#!/bin/bash
#
# A Krishnamurthy number is a number whose sum of the factorial of digits is equal
# to the number itself.
#
# For example, 145 is the sum of the factorial of each digit.
# 1! + 4! + 5! = 1 + 24 + 120 = 145
#

factorial() {
    local n=$1
    local result=1
    for (( i=2; i<=n; i++ )); do
        result=$(( result * i ))
    done
    echo $result
}

for (( i=1; i<200; i++ )); do
    sum=0
    number=$i
    while (( $number > 0 )); do
        digit=$(( $number % 10 ))
        sum=$(( sum + $(factorial $digit) ))
        number=$(( $number / 10 ))
    done
    if (( $i == $sum )); then
        echo -n $i" "
    fi
done
echo

#!/bin/bash

luhn() {
    local num=$1
    local len=${#1}
    local result=0

    for (( i=$len-1; i>=0; i-=2 )); do
        double=$(( (num % 10) * 2 ))
        num=$((num / 10))
        if (( double > 9 )); then
            double=$((double - 9))
        fi
        #echo $double
        result=$(( result + double ))
        result=$(( result + (num % 10) ))
        #echo $(( num % 10 ))
        num=$((num / 10))
    done

    #echo $result
    echo $(( (10 - result % 10) % 10 ))
}

declare -A pairs=(
    [867846746]="8"
    [1789372997]="4"
    [81101722523]="6"
    [377987328782]="1"
    [3481020675232]="3"
    [14275032015018]="7"
    [601178865689998]="0"
    [3891819764582572]="5"
    [98348454165344798]="2"
    [872560021439746445]="9"
)

for num in ${!pairs[@]}
do
    digit=${pairs[$num]}
    pattern="^$digit$|^$digit[^0-9]|[^0-9]$digit$|[^0-9]$digit[^0-9]"
    luhn $num | grep -q -E $pattern
    if [ $? == 0 ]
    then
        echo "Good: $num is $digit"
    else
        echo >&2 "Bad: Luhn($num) should have been $digit"
    fi
done

#!/bin/bash
#
# Test driver
#
. pre_test.sh

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
    . bash.sh $num | grep -q -E $pattern
    if [ $? == 0 ]
    then
        echo "Good: $num is $digit"
    else
        echo >&2 "Bad: Luhn($num) should have been $digit"
    fi
done

. post_test.sh

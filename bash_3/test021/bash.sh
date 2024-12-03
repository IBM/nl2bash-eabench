#!/bin/bash
#
# luhn 1789372997 is 4
# luhn 49015420323751 is 8
# luhn 4512345678901234 is 9
# luhn 1234567 is 4 
# luhn 872560021439746445 is 9
# luhn 601178865689998 is 0
# luhn 4532015264668453 is 7

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

echo Check digit is $(luhn $1)


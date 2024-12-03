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

is_palindrome() {
    local num=$1
    local r=0
    while (( $num > 0 ))
    do
        r=$(( $r * 10 + $num % 10 ))
        num=$(( $num/10 ))
    done
    if (( i == r ))
    then
        return 0
    else
        return 1
    fi
}

count=0
for (( b=2; b<=16; b++ ))
do
    n=$(echo "obase=$b; ibase=10; $1" | bc)
    p=$(echo $n | rev)
    if [[ "$n" == "$p" ]]
    then
        echo $1 in base $b is $n which is a palindrome
        ((count++))
    fi
done

if (( count == 0 ))
then
    echo Could not find a base where $1 is a palindrome
fi


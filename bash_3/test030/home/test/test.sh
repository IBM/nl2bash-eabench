#!/bin/bash
#
# Test driver
#
. pre_test.sh

n=1991
if ./bash.sh $n
then
    echo "$n is a palindrome"
else
    echo "$n is not a palindrome"
fi

n=1871
if ./bash.sh $n
then
    echo "$n is a palindrome"
else
    echo "$n is not a palindrome"
fi

. post_test.sh

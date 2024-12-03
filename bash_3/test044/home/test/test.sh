#!/bin/bash
#
# Test driver
#
. pre_test.sh
for i in 21 42 57 210 561 1105
do
    if [ "$(./bash.sh $i)" = "true" ]
    then
        echo "POSSIBLY $i"
    else
        echo "COMPOSITE $i"
    fi
done
for i in 563 569 571
do
    if [ "$(./bash.sh $i)" = "true" ]
    then
        echo "POSSIBLY $i"
    else
        echo "COMPOSITE $i"
    fi
done
. post_test.sh

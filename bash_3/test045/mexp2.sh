#!/bin/bash

#
# Asking for c where c = b^e mod m
#

#
# (a * b) mod m = ( (a mod m)* (b mod m) ) mod m
#
function mexp() {
    local b=$1
    local e=$2
    local m=$3

    c=1

    while (( e > 0 ))
    do
        if (( e % 2 == 1 ))
        then
            c=$(( (b*c) % m ))
            #echo >&2 $c
        #else
            #echo >&2 "$c b=$b"
        fi
        e=$(( e/2 ))
        b=$(( (b*b) % m ))
    done

    echo $c
}

b=$1
e=$2
m=$3

c=$(mexp $b $e $m)
echo "$c = $b^$e mod $m"


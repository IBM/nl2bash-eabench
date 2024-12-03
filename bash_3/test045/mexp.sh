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

    #echo >&2 "mexp $e $b $m"
    if (( e == 1 ))
    then
        echo $b
        #echo >&2 1
        exit 0
    fi

    if (( e % 2 == 1 ))
    then
        e=$(( e-1 ))
        c=$(mexp $e $b $m)
        c=$(( (b*c) % m ))
        echo $c
        #echo >&2 $c
        exit 0
    else
        e=$(( e/2 ))
        c=$(mexp $e $b $m)
        c=$(( (c*c) % m ))
        echo $c
        #echo >&2 $c
        exit 0
    fi
}

b=$1
e=$2
m=$3

c=$(mexp $b $e $m)
echo "$c = $b^$e mod $m"


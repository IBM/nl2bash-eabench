#!/bin/bash

# Function to check if a number is palindrome
is_palindrome() {
    local n=$1
    local r=$(echo "$n" | rev)
    #echo >&2 "$n --- $r"
    [ "$n" == "$r" ]
}

# Function to find the number of bases in which a number is palindrome
num_bases() {
    local n=$1
    local count=0
    local base
    for(( base=2; base<=16; base++ ))
    do
        local m=$(echo "obase=$base; $n" | bc)
        #echo >&2 "$n is $m in base $base"
        if is_palindrome $m
        then
            count=$((count+1))
        fi
    done
    echo $count
}

print_bases() {
    local n=$1
    local base
    for(( base=2; base<=16; base++ ))
    do
        local m=$(echo "obase=$base; $n" | bc)
        #echo >&2 "$n is $m in base $base"
        if is_palindrome $m
        then
            echo -n " $base($m)"
        fi
    done
}

# Main function
if [[ $# -ne 1 ]] || ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "Usage: $0 <integer>"
    exit 1
fi

limit=$1
for(( n=10; n<=limit; n++ ))
do
    count=$(( $(num_bases $n) ))
    if [[ $count -eq 3 ]]
    then
        echo -n "$n: "
        print_bases $n
        echo
    fi
done

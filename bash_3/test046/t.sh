#!/bin/bash

# Function to check if a number is prime
is_prime() {
    local n=$1
    local i
    if (( n < 2 ))
    then
        return 1
    fi
    if (( n == 2 ))
    then
        return 0
    fi
    for (( i=3; i*i <=n; i+=2 ))
    do
        if (( n % i == 0 ))
        then
            return 1
        fi
    done
    return 0
}

# Function to compute Euler's totient function
phi() {
    local n=$1
    local result=0
    local i
    for (( i = 1; i <= n; i++ ))
    do
        if (( $(gcd $i $n) == 1 ))
        then
            result=$(( result + 1 ))
        fi
    done
    echo $result
}

# Function to check if a number is a Carmichael number
is_carmichael() {
    local n=$1
    local a
    for (( a = 2; a < n; a++ ))
    do
        if (( pow $a $(( n - 1 )) % n != 1 ))
        then
            return 1
        fi
    done
    return 0
}

# Function to compute $a^b$ modulo $n$
pow() {
    local a=$1
    local b=$2
    local n=$3
    local result=1
    while (( b > 0 )); do
        if (( b % 2 == 1 )); then
            result=$(( (result * a) % n ))
        fi
        a=$(( a * a ))
        b=$(( b / 2 ))
    done
    echo $result
}

# Function to compute the greatest common divisor of $a$ and $b$
function gcd() {
    local a=$1
    local b=$2
    while (( $a != $b ))
    do
        if (( $a > $b ))
        then
            a=$(( a - b ))
        else
            b=$(( b - a ))
        fi
    done
    echo $a
}

# Function to compute the greatest common divisor of $a$ and $b$
gcd_dead() {
    local a=$1
    local b=$2
    while (( b != 0 )); do
        local temp=$b
        b=$(( a % b ))
        a=$temp
    done
    echo $a
}

# Main function
if (( $# != 1 )); then
    echo "Usage: $0 <integer>"
    exit 1
fi

limit=$1

for (( n = 3; n < limit; n += 2 ))
do
    if is_prime $n
    then
        continue
    fi
    echo >&2 Testing $n
    if (( $(phi $n) * 2 == n ))
    then
        echo >&2 is_carmichael $n
        if is_carmichael $n
        then
            echo $n
        fi
    fi
done

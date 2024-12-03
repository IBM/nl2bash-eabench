#!/bin/bash
#
# phi(n) = n * (1 - 1/p1) * (1 - 1/p2) * ... * (1 - 1/pk)
#      n = p1 * p2 * p3 * ... * pk
#        = (p1 * p2 * p3 * ... * pk) * (1 - 1/p1) * (1 - 1/p2) * ... * (1 - 1/pk)
#        = (n/(p1*p2*...*pk)) * (p1 - 1) * (p2 - 1) * ... (pk - 1)
#
# phi(12) = 12 * (1 - 1/2) * (1 - 1/3) = 12 * 1/2 * 2/3 = 4
#         = 2 * (2*3) * (1 - 1/2) * (1 - 1/3)
#         = 2 * (2-1) * (3-1)
#         = 2 * 1 * 2 = 4
#


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


# Function to compute Euler's totient function
phi() {
    local n=$1
    local result=0
    for (( i=1; i<=n; i++ ))
    do
        if (( $(gcd $i $n) == 1 ))
        then
            result=$(( result + 1 ))
        fi
    done
    echo $result
}

fib() {
    if [ "$1" -eq 0 ]; then
        echo 0
    elif [ "$1" -eq 1 ]; then
        echo 1
    else
        echo $(($(fib $(($1 - 1))) + $(fib $(($1 - 2)))))
    fi
}


#echo "phi(9) is $(phi 9)"

n=$1
f=$(fib $n)
echo "The $nth Fibonacci number is $f"
t=$(phi $f)
echo "The totient of $f is $t"

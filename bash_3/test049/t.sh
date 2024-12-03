#!/bin/bash

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

totient() {
    local n=$1
    local tot=0
    local i
    local j

    for(( i=1; i<=$n; i++ ))
    do
        if (( (n % i) == 0 ))
        then
            local j=$i
            while (( (n % j) == 0 ))
            do
                j=$(($j * 2))
            done
            tot=$(($tot + ($i / $j)))
        fi
    done

    echo $(($n - $tot))
}

echo "phi(9) is $(phi 9)"

n=$1
f=$(fib $n)
echo "The $n Fibonacci number is $f"
t=$(phi $f)
echo $t

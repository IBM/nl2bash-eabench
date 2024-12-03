#!/bin/bash

fermat_pseudoprime() {
    a=$1
    n=$2
    if (( a ** (n - 1) % n == 1 )); then
        echo true
    else
        echo false
    fi
}

echo $(fermat_pseudoprime $1 $2)

#!/bin/bash

function is_prime() {
    local n=$1
    local i
    if ((n <= 1)); then
        return 1
    fi
    for ((i=2; i*i<=n; i++)); do
        if ((n % i == 0)); then
            return 1
        fi
    done
    return 0
}

function is_carmichael() {
    local n=$1
    local i
    for ((i = 2; i < n; i++)); do
        if ! is_prime $i; then
            continue
        fi
        if ((n % i == 0)); then
            local d=$((n / i))
            if ((d % i == 0)); then
                local x=$((d / i))
                local y=$((n - 1))
                local z=$((x ** y % n))
                if ((z != 1)); then
                    return 1
                fi
            fi
        fi
    done
    return 0
}

function is_composite() {
    if is_prime $1; then
        return 1
    fi
    if is_carmichael $1; then
        return 1
    fi
    return 0
}

if is_prime $1
then
    echo "prime"
elif is_carmichael $1
then
    echo "carmichael"
else
    echo "composite"
fi

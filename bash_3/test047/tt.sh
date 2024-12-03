is_prime() {
    local n=$1
    local i
    if (( n <= 1 )); then
        return 1
    elif (( n % 2 == 0 && n > 2 )); then
        return 1
    elif (( n % 3 == 0 && n > 3 )); then
        return 1
    fi
    local i=5
    while (( i * i <= n )); do
        if (( n % i == 0 )); then
            return 1
        fi
        i=$(( i + 2 ))
        if (( n % i == 0 )); then
            return 1
        fi
        i=$(( i + 4 ))
    done
    return 0
}

min() {
    if (( $1 < $2 ))
    then
        echo $1
    else
        echo $2
    fi
}
max() {
    if (( $1 > $2 ))
    then
        echo $1
    else
        echo $2
    fi
}

is_coprime() {
    local a=$(min $1 $2)
    local b=$(max $1 $2)
    for(( i=2; i<=a; i++ ))
    do
        if (( a % i == 0  &&  b % i == 0 ))
        then
            echo >&2 "$a $b"
            return 1
        fi
    done
    return 0
}

is_composite() {
    local n=$1
    local i
    if (( n <= 1 )); then
        return 1
    elif (( n == 2 )); then
        return 0
    elif (( n % 2 == 0 )); then
        return 0
    elif (( n % 3 == 0 )); then
        return 0
    fi
    local i=5
    while (( i * i <= n )); do
        if (( n % i == 0 )); then
            return 0
        fi
        i=$(( i + 2 ))
        if (( n % i == 0 )); then
            return 0
        fi
        i=$(( i + 4 ))
    done
    return 1
}

is_carmichael() {
    local n=$1
    local a
    #for a in $(seq 2 $(( n - 1 )))
    for(( a=2; a<n-1; a++ ))
    do
        if is_coprime $a $n
        then
            echo "$((a ** 60))"
            echo >&2 "trying $a $((a ** (n-1))) --> $(( ( a ** (n-1) ) % n ))"
            if (( ( ( a ** ( n - 1 ) ) % n ) != 1 ))
            then
                return 1
            fi
        fi
    done
    return 0
}

if is_prime $1
then
    echo prime
    exit 0
fi

if is_carmichael $1
then
    echo carmichael
    exit 0
fi

if is_composite $1
then
    echo composite
    exit 0
fi

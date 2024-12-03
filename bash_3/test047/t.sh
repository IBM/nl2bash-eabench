#!/bin/bash

# Function to check if a number is prime
is_prime() {
  local num=$1
  if (( num <= 1 )); then
    return 1
  fi
  for (( i=2; i*i<=num; i++ )); do
    if (( num % i == 0 )); then
      return 1
    fi
  done
  return 0
}

function mexp() {
    local b=$1
    local e=$2
    local m=$3
    local c=1

    #echo >&2 "mexp $b $e $m"

    # (a*b) mod m = (a mod m) * (b mod m)
    # b^(2*e+1) mod m = (b^(2*e) mod m) * (b mod m)
    while (( e > 0 ))
    do
        if (( e % 2 == 1 ))
        then
            c=$(( (b*c) % m ))
        fi
        e=$(( e/2 ))
        b=$(( (b*b) % m ))
    done

    echo $c
}

# Function to check if a number is a Carmichael number
is_carmichael() {
  local num=$1
  local b
  for (( b=2; b<num-1; b++ ))
  do
    local i
    for(( i=2; i<=b; i++ ))
    do
        #echo >&2 "$num % $i = $((num % i)), $b % $i = $((b % i))"
        if (( num % i == 0 && b % i == 0 ))
        then
            #echo >&2 "$num % $i = $((num % i)), $b % $i = $((b % i))"
            break
        fi
    done
    if (( num % i != 0  &&  b % i != 0 ))
    then
      local r=$(bc <<< "($b^($num-1))%$num")
      #local r=$(mexp $b $((num-1)) $num)
      #echo >&2 "$b^($num-1)%$num, r=$r"
      if (( r != 1 ))
      then
        return 1
      fi
    fi
  done
  return 0
}

# Check if the argument is a prime number, a Carmichael number or a composite number
if is_prime $1; then
  echo "Prime"
  exit 0
elif is_carmichael $1; then
  echo "Carmichael"
  exit 0
else
  echo "Composite"
  exit 1
fi

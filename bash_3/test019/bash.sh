#!/bin/bash
#
# A twin prime is a prime number that is either 2 less or 2 more than another prime number—for example, the pair (3, 5), (5, 7), and (11, 13) are twin primes.

# Function to check if a number is prime
is_prime() {
  local n=$1
  local i
  if (( $n <= 1 ))
  then
    return 1
  fi
  for (( i=2; i*i <= ${1}; i++ ))
  do
    if (( $n % i == 0 ))
    then
      return 1
    fi
  done
  return 0
}

# Check if input arguments are provided
if (( $# < 2 ))
then
    echo "Usage: $0 <start> <end>"
    exit 1
fi

for (( i=$1; i<=$2; i++ ))
do
    if is_prime $i
    then
        j=$(( $i + 2 ))

        if is_prime $j
        then
            echo "$i $j"
        fi
    fi
done

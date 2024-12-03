#!/bin/bash

# prime_factors.sh
# Outputs the prime factors of its input argument.

# Check if input argument is provided
if [ -z "$1" ]; then
  echo "Please provide an input argument."
  exit 1
fi

# Check if input argument is a positive integer
if ! [[ "$1" =~ ^[0-9]+$ ]]; then
  echo "Input argument must be a positive integer."
  exit 1
fi

# Initialize variables
num=$1
divisor=2

# Loop through possible divisors
while [ $num -gt 1 ]; do
  # Check if divisor is a factor of num
  if [ $(($num % $divisor)) -eq 0 ]; then
    # Output divisor and divide num by divisor
    echo $divisor
    num=$(($num / $divisor))
  else
    # Increment divisor
    divisor=$(($divisor + 1))
  fi
done


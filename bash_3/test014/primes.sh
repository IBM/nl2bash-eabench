#!/bin/bash
#
# Write a bash script to find the first 100 prime numbers using the factor program.

# Initialize a counter for the number of primes found
count=0

# Initialize the first prime number
n=2

# Loop until we have found 100 prime numbers
while [ $count -lt 100 ]; do
  # Use the factor command to check if the number is prime
  if factor $n | grep -q "^$n: $n$"; then
    # If the number is prime, increment the counter and print it
    count=$((count + 1))
    echo $n
  fi

  # Increment the number to check
  n=$((n + 1))
done

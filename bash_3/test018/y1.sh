#!/bin/bash

for i in $(seq 100 1000); do
  is_prime=1
  for j in $(seq 2 $(($i/2))); do
    if (( $i % $j == 0 )); then
      is_prime=0
      break
    fi
  done
  if (( $is_prime == 1 )); then
    echo $i
  fi
done

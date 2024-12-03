#!/bin/bash

# Define the number
x=2

# Define the initial guess
x0=100

# Compute x1
x0=$(echo "scale=20; $x0 - (($x0^2 - $x) / $x0) / 2" | bc)

# Print x0
echo $x0

# Compute x1
x0=$(echo "scale=20; $x0 - (($x0^2 - $x) / $x0) / 2" | bc)

# Print x1
echo $x0

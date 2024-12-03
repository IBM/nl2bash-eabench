#!/bin/bash
#
# 0 1 2 3  4  5  6  7  8  9  10 11 12 13 14
# 3 5 7 12 13 14 21 23 23 23 23 29 40 56
#
# (21+23)/2 --> 22
#

# Sort and load the values from median.txt into an array
mapfile -t sorted <<< "$(sort -n numbers.txt)"
#sorted=$(sort -n numbers.txt | (mapfile -t list; echo ${list[@]}))

# Calculate the length of the sorted array
n=${#sorted[@]}

# Calculate the middle index of the sorted array
middle=$(( n / 2 ))

# If the length of the sorted array is even, calculate the average of the two middle values
if (( n % 2 == 0 )); then
  median=$(( (sorted[middle-1] + sorted[middle]) / 2 ))
else
  # Otherwise, just output the middle value
  median=${sorted[middle]}
fi

# Output the median value
echo "$median"

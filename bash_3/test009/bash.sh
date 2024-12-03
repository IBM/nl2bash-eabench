#!/bin/bash
#
# Write a bash script to list all group which have two of more members.
#

for group in $(getent group | cut -d: -f1); do
  members=$(getent group $group | cut -d: -f4 | tr ',' '\n' | sort | uniq)
  if [ $(echo "$members" | wc -l) -gt 1 ]; then
    echo "Group: $group"
    echo "Members: $members"
  fi
done


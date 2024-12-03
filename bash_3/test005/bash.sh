#!/bin/bash

# Read /etc/passwd file
while IFS=: read -r user x uid gid gecos home shell; do
  # Check if group exists in /etc/group
  grep -q ":$gid:" /etc/group
  if [ $? -ne 0 ]; then
    echo "Group $gid for user $user does not exist in /etc/group"
  fi
done < /etc/passwd

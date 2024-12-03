#!/bin/bash

while IFS=: read -r user pass last min max warn inactive account; do
  # echo $user $last $min $max $warn $inactive $account
  if [[ -z $max ]]; then
    continue
  fi

  # Calculate the number of days until the password expires
  days=$(( ($last + $max - ( $(date +%s) / 86400) ) ))

  # Print out the user and the number of days until their password expires
  echo "$user: password expires in $days days"
done < /etc/shadow


#!/bin/bash

# Check if the user running the script is root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root"
    exit 1
fi

# Read each line from /etc/passwd
while IFS=: read -r username x uid gid gecos home shell
do
    # Count the number of occurrences of the username
    count=$(grep -c -E "^$username" /etc/passwd)

    # If the count is greater than 1, print a message
    if [ "$count" -gt 1 ]; then
        echo "Duplicate user name: $username"
    fi
done < /etc/passwd

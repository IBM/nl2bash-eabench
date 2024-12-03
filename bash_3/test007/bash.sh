#!/bin/bash
#
# Write a bash script which identifies the user who owns the highest number of files under /home.
#

# Initialize variables
max_files=0
max_user=""

# Loop through all users in /home
for user in /home/*; do
    # Skip directories that are not users
    if [[ ! -d "$user" ]]; then
        continue
    fi

    # Count the number of files owned by the user
    num_files=$(find "$user" -type f -user "$(basename "$user")" | wc -l)

    # Update the maximum if necessary
    if (( num_files > max_files )); then
        max_files=$num_files
        max_user=$(basename "$user")
    fi
done

# Print the user with the most files
echo "User with the most files: $max_user"

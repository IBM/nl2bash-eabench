#!/bin/bash

# Search for symbolic links in /home/test/downloads
find /home/test/downloads -type l > /home/test/downloads.links

# Loop through the symbolic links
while read -r link; do
  # Get the target of the symbolic link
  target=$(readlink -f "$link")

  # Check if the target is in /home/test/uploads
  if [[ $target == /home/test/uploads/* ]]; then
    # Get the name of the target file
    target_file=$(basename "$target")

    # Add the name of the target file to the file uploads.targets
    echo "$target_file" >> /home/test/uploads.targets
  fi
done < /home/test/downloads.links

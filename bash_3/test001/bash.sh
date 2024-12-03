#!/bin/bash

find /home/test/downloads -type l | while read -r line; do
  target=$(readlink -f "$line")

  if [[ $(dirname $target) == "/home/test/uploads" ]]; then
    filename=$(basename "$target")
    echo "$filename" >> /home/test/uploads.targets
  fi
done

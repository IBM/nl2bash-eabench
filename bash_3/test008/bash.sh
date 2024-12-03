#!/bin/bash
#
# Write a bash script which identifies the group that owns the highest number of files under /home.
#

# Find files under /home and get group ownership information
find /home -type f -exec stat -c '%G' {} + |

# Count the number of files per group
sort | uniq -c |

# Find the group with the highest count
awk '$1 > max { max = $1; group = $2 } END { print group, max }' max=0

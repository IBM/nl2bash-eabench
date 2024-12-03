#!/bin/bash
#
# Any helper command which might confirm bash.sh worked
#   - eg, print the time after bash.sh sets the time zone
#
echo "(no edits)              ~/pgm1.py: " $(head -n1 pgm1.py)
echo "(edited?)         subdirA/pgm2.py: " $(head -n1 subdirA/pgm2.py)
echo "(edited?) subdirA/subdirB/pgm3.py: " $(head -n1 subdirA/subdirB/pgm3.py)

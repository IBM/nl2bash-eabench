#!/bin/bash
#
# Any "warm up" commands to set the stage for bash.sh
#   - eg, spin up a busy-wait task so a ps command sees 100% CPU utilization
#
# I create them in random order so they aren't "naturally" in order of by size
fallocate -l 1030 medium.dat
fallocate -l 1050 grand.dat
fallocate -l 1010 tiny.dat
fallocate -l 1040 large.dat
fallocate -l 1020 small.dat
fallocate -l 1060 super.dat

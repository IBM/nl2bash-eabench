#!/bin/bash
#
# Test driver
#
pids=()
. pre_test.sh

./bash.sh ${pids[@]}

. post_test.sh

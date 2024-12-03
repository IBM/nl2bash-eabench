#!/bin/bash
#
# Test driver
#
. pre_test.sh
#
. bash.sh 1
# 1
#
. bash.sh 10
# 55
#
. bash.sh 25
# 75025
#
. bash.sh 50
# 12586269025
#
. post_test.sh

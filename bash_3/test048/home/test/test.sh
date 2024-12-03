#!/bin/bash
#
# Test driver
#
. pre_test.sh
echo "25 pseudoprime to 7 is $(./bash.sh 25 7)"
echo "25 pseudoprime to 14 is $(./bash.sh 25 14)"
echo "25 pseudoprime to 18 is $(./bash.sh 25 18)"
echo "205 pseudoprime to 42 is $(./bash.sh 205 42)"
echo "205 pseudoprime to 43 is $(./bash.sh 205 43)"
. post_test.sh

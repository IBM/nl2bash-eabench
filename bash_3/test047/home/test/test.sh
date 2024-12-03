#!/bin/bash
#
# Test driver
#
. pre_test.sh
echo "561  $(./bash.sh 561)"
echo "1105 $(./bash.sh 1105)"
echo "1171 $(./bash.sh 1171)"
echo "1181 $(./bash.sh 1181)"
echo "1173 $(./bash.sh 1173)"
echo "1183 $(./bash.sh 1183)"
. post_test.sh

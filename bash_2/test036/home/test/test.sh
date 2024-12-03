#!/bin/bash
#
# Test driver
#
. pre_test.sh
(cd subdirA; bash ../bash.sh)
. post_test.sh

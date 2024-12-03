#!/bin/bash
#
# Test driver
#

# pre_test.sh will return 0 if we need to run the command
if ./pre_test.sh
then
    sudo bash bash.sh
    . post_test.sh
fi

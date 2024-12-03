#!/bin/bash
#
# Test driver
#
. pre_test.sh
sudo su test -c "bash ./bash.sh"
. post_test.sh

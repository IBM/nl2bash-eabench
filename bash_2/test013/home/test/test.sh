#!/bin/bash
#
# Test driver
#
. pre_test.sh
sudo -u test ./bash.sh # Docker doesn't start as user "test"
. post_test.sh

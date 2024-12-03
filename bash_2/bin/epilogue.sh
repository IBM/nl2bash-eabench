#!/bin/bash
#

test_set=${@:$OPTIND+0:1}
test=${@:$OPTIND+1:1}
work_dir=${@:$OPTIND+2:1}

#printf "epilogue(test)  : $test\n"

strip_out_stdout.sh ${work_dir}/podman.log

#
# Check for dedicated epilogue script
#
if [ -x ${test_set}/${test}/epilogue.sh ]
then
    ${test_set}/${test}/epilogue.sh ${test_set} ${test} ${work_dir}
fi


#!/bin/bash
#
#
#

test_set=${@:$OPTIND+0:1}
test=${@:$OPTIND+1:1}
work_dir=${@:$OPTIND+2:1}

#
# Workarounds
#
touch ${work_dir}/diff.log
touch ${work_dir}/home.log

#printf "evaluate(test)  : $test\n"

if [ -x ${test_set}/${test}/evaluate.sh ]
then
    ${test_set}/${test}/evaluate.sh ${test} ${test_set} ${work_dir}
    rc=$?
else
    echo >&2 "evaluate.sh: missing evaluation function for ${test_set}/${test}"
    rc=-1
fi

exit $rc




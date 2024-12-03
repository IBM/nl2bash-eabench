#!/bin/bash
#
#
#

test_set=${@:$OPTIND+0:1}
test=${@:$OPTIND+1:1}
work_dir=${@:$OPTIND+2:1}

#printf "prologue(test)  : $test\n"

#
# Build home/test in working-directory
#
cp -pR ${test_set}/${test}/home ${work_dir}

mv ${work_dir}/script.txt ${work_dir}/home/test/bash.sh
chmod +x ${work_dir}/home/test/bash.sh

if [ -x ${test_set}/${test}/prologue.sh ]
then
    ${test_set}/${test}/prologue.sh ${test_set} ${test} ${work_dir}
fi

exit 0

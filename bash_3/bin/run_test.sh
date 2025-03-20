#!/bin/bash
#
#  run_test.sh <test_set> <test> <work_dir>
#     <test_set>  test set, eg, bash_1
#     <test>      test to run, eg, test001
#     <work_dir>  working directory, eg, ${cwd}/output/test

platform=${@:$OPTIND+0:1}
test_set=${@:$OPTIND+1:1}
test=${@:$OPTIND+2:1}
work_dir=${@:$OPTIND+3:1}

#echo "run_test.sh ${platform} ${test_set} ${test} ${work_dir} in " $(pwd)

(
    export PATH="$(pwd)/${test_set}/bin:${PATH}"

    prologue.sh ${test_set} ${test} ${work_dir}

    ${platform}.sh ${test_set} ${test} ${work_dir} > /dev/null
    rc=$?

    #
    # Capture errant podman return codes here
    #   - assume that our shell scripts use low values
    #   - podman uses values ~70 and up
    #
    if [ $rc -lt 8 ]
    then
        epilogue.sh ${test_set} ${test} ${work_dir}
        evaluate.sh ${test_set} ${test} ${work_dir}
        rc=$?
    elif [ $rc == 255 ]
    then
        echo >&2 "${platform} timed out"
        rc=2
    else
        echo >&2 "${platform} aborted, rc = $rc"
    fi

    remove.sh ${test_set} ${test} ${work_dir}

    exit $rc
)

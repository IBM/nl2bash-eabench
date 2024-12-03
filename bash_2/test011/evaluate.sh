#!/bin/bash
#
# Test-specific evaluator
#   - stub, season to taste
#

while getopts '' flag
do
    case ${flag} in
        *) print_usage;;
    esac
done

test=${@:$OPTIND+0:1}
tstdir=${@:$OPTIND+1:1}
wrkdir=${@:$OPTIND+2:1}

#printf "evaluate(test)  : $test\n"
#printf "evaluate(tstdir): $tstdir\n"
#printf "evaluate(wrkdir): $wrkdir\n"

#printf "Running a test011-specific evaluator\n"

(
    cd ${wrkdir}

    #
    # Look for any stderr output during runtime
    #
    rc=$(strip_out_stderr.sh podman.log | wc -l)
    if [ $rc != 0 ]
    then
        echo >&2 "Command had runtime errors"
        exit 2
    fi

    #
    # No files should've been created
    #
    if [ $(stat --format="%s" diff.log) != 0 ]
    then
        echo >&2 "Created spurious system files in the container -- see diff.log"
        exit 2
    fi

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory -- see home.log"
        exit 2
    fi

    #
    # Test011
    #
    # Typical output
    #
    #  4.18.0-513.11.1.el8_9.x86_64
    #
    # post_test.sh outputs a KERNEL variable
    read -d' ' -a vars <<< $(extract_vars.sh podman.log)
    for var in ${vars[@]}  # this should just be KERNEL
    do
        eval ${var}
    done

    strip_out_stdout.sh podman.log | grep $KERNEL > /dev/null
    if [ $? != 0 ]
    then
        echo >&2 "Did not find the current kernel version in stdout"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

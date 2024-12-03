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

#printf "Running a test001-specific evaluator\n"

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
        echo >&2 "Created spurious system files"
        exit 2
    fi

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory"
        exit 2
    fi

    #
    # Test001
    #
    # Typical
    #
    # bash.sh 16777215    (24)
    # bash.sh 268435455   (28)
    # bash.sh 4294967295  (32)
    #
    strip_out_stdout.sh podman.log | grep -q -E "^24$| 24$|^24 | 24 "
    if [ $? != 0 ]
    then
        echo >&2 "Expected stdout to contain \"24\" for Hamming(16777215)"
        exit 2
    fi

    strip_out_stdout.sh podman.log | grep -q -E "^28$| 28$|^28 | 28 "
    if [ $? != 0 ]
    then
        echo >&2 "Expected stdout to contain \"28\" for Hamming(268435455)"
        exit 2
    fi

    strip_out_stdout.sh podman.log | grep -q -E "^32$| 32$|^32 | 32 "
    if [ $? != 0 ]
    then
        echo >&2 "Expected stdout to contain \"32\" for Hamming(4294967295)"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

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
    # 1 1
    #
    # 10 55
    #
    # 25 75025
    #
    # 50 12586269025
    #
    strip_out_stdout.sh podman.log | grep -q -E "^1$|^1 | 1$| 1 "
    if [ $? != 0 ]
    then
        echo >&2 "Expected stdout to contain \"1\" for first Fibonacci number"
        exit 2
    fi

    strip_out_stdout.sh podman.log | grep -q -E "^55$|^55 | 55$| 55 "
    if [ $? != 0 ]
    then
        echo >&2 "Expected stdout to contain \"55\" for 10th Fibonacci number"
        exit 2
    fi

    strip_out_stdout.sh podman.log | grep -q "75025"
    if [ $? != 0 ]
    then
        echo >&2 "Expected stdout to contain \"75025\" for 25th Fibonacci number"
        exit 2
    fi

    strip_out_stdout.sh podman.log | grep -q "12586269025"
    if [ $? != 0 ]
    then
        echo >&2 "Expected stdout to contain \"12586269025\" for 50th Fibonacci number"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

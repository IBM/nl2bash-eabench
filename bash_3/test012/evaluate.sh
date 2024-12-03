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
    # Test012
    #
    # Typical output:
    # 2^2 - 1 = 3 is a Mersenne prime
    # 2^3 - 1 = 7 is a Mersenne prime
    # 2^5 - 1 = 31 is a Mersenne prime
    # 2^7 - 1 = 127 is a Mersenne prime
    # 2^13 - 1 = 8191 is a Mersenne prime
    # 2^17 - 1 = 131071 is a Mersenne prime
    # 2^19 - 1 = 524287 is a Mersenne prime
    # 2^31 - 1 = 2147483647 is a Mersenne prime
    #
    for m in 3 7 31 127 8191 131071 524287 2147483647
    do
        strip_out_stdout.sh podman.log | grep -q -E "^$m$|^$m | $m$| $m "
        if [ $? != 0 ]
        then
            echo >&2 "Expected to find $m in stdout"
            exit 2
        fi
    done

    exit 0
)
rc=$?

exit $rc

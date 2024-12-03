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
    # bash.sh   66666 (212001110)
    # bash.sh  100000 (212001111)
    # bash.sh  111245 (222222222)
    # bash.sh  666666 (12222101100)
    #
    strip_out_stdout.sh podman.log | grep -q "212001110"
    if [ $? != 0 ]
    then
        echo >&2 "Expected stdout to contain \"212001110\" for 66666"
        exit 2
    fi

    strip_out_stdout.sh podman.log | grep -q "212001111"
    if [ $? != 0 ]
    then
        echo >&2 "Expected stdout to contain \"212001111\" for 100000"
        exit 2
    fi

    strip_out_stdout.sh podman.log | grep -q "222222222"
    if [ $? != 0 ]
    then
        echo >&2 "Expected stdout to contain \"222222222\" for 111245"
        exit 2
    fi

    strip_out_stdout.sh podman.log | grep -q "12222101100"
    if [ $? != 0 ]
    then
        echo >&2 "Expected stdout to contain \"12222101100\" for 666666"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

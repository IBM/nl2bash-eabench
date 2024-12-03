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

#printf "Running a test013-specific evaluator\n"

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
    # Test013
    #
    # Typical output
    #
    # 1048576 subdir/dummy0.dat
    strip_out_stdout.sh podman.log | grep dummy0.dat > /dev/null
    if [ $? != 0 ]
    then
        strip_out_stdout.sh podman.log | grep "[1-9][0-9][Kk]" > /dev/null
        if [ $? == 0 ]
        then
            echo >&2 "Is the command attempting to sort values ending with K?"
        else
            echo >&2 "Expected to find \"dummy0.dat\" in stdout"
        fi
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

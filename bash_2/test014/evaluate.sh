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

#printf "Running a test014-specific evaluator\n"

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
    # Test014
    #
    # Typical output
    #  -rw-rw-r--. 1 test test 0 Jan 25 20:47 data.dat
    #  -rw-------. 1 test test 0 Jan 25 20:47 data.dat
    #
    #                                                            -rw-rw-r--. 
    (strip_out_stdout.sh podman.log | tail -1 | grep -e "^After :-..x......" > /dev/null) || \
    (strip_out_stdout.sh podman.log | tail -1 | grep -e "^After :-.....x..." > /dev/null) || \
    (strip_out_stdout.sh podman.log | tail -1 | grep -e "^After :-........x" > /dev/null)
    if [ $? == 0 ]
    then
        echo >&2 "Execute permissions should not have been set"
        exit 2
    fi

    #                                                        |owner|group|other
    #                                                         r w  xr w  xr w  x
    strip_out_stdout.sh podman.log | tail -1 | grep "^After :-r[-w]--[-w]--[-w]-" > /dev/null
    if [ $? != 0 ]
    then
        #strip_out_stdout.sh podman.log | grep "data.dat" >&2
        echo >&2 "Expected data.dat to have \"-r?--?--?-\" permissions"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

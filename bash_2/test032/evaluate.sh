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

#printf "Running a test016-specific evaluator\n"

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
    # Test032
    #
    # atime -u - this seems to be the creation time          | touch -a (changes both times)
    # ctime -c - this seems to be the last modification time | touch -m
    #
    # -rw-r--r--. 1 test test 1024 Mar  8 22:21 data.dat
    # -rw-r--r--. 1 test test 1024 Dec 31  2022 data.dat
    #
    strip_out_stdout.sh podman.log | tail -1 | grep -E 'Dec 31  2022 data.dat' > /dev/null
    if [ $? != 0 ]
    then
        echo >&2 "Expected to find data.dat with a date of \"Dec 31, 2022\""
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

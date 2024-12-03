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
    # ./bash.sh 121
    #   3: 11111  11111
    #   7: 232  232
    #   8: 171  171
    #   10: 121  121
    # ./bash.sh 1913
    #   3: 2121212  2121212
    #   14: 9A9  9A9
    #   15: 878  878
    #
    for b in 3 7 8 10 14 15
    do
        strip_out_stdout.sh podman.log | grep -q -E "^$b$|^$b[^0-9]|[^0-9]$b$|[^0-9]$b[^0-9]"
        if [ $? != 0 ]
        then
            echo >&2 "Expected stdout to contain base $b"
            exit 2
        fi
    done
 
    # Make sure it doesn't pick these bases (keep the spaces in the search string!)
    for b in 2 4 5 6 9 11 12 13 16
    do
        strip_out_stdout.sh podman.log | grep -q -E "^$b$|^$b | $b$| $b "
        if [ $? == 0 ]
        then
            echo >&2 "Base $b should not appear in stdout"
            exit 2
        fi
    done

    exit 0
)
rc=$?

exit $rc

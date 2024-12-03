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
    # Test013
    #
    # Typical output:
    # Iteration 1: 100
    # Iteration 2: 50.01000000000000000000
    # Iteration 3: 25.02499600079984003199
    # Iteration 4: 12.55245804674590298259
    # Iteration 5: 6.35589469493114003463
    # Iteration 6: 3.33528160928043383828
    # The square root of two is approximately 3.33528160928043383828
    #
    root=$(strip_out_stdout.sh podman.log | grep -o -E "[0-9][0-9]*\.[0-9][0-9]*")
    #echo >&2 "root is $root"
    rc=$(echo "$root > 3.0 && $root < 25.0" | bc)
    #echo >&2 "rc is $rc"
    if [ "$rc" == "1" ]
    then
        exit 0
    fi

    echo >&2 "Expected to find a value between 3.0 and 25.0 in stdout"
    exit 2
)
rc=$?

exit $rc

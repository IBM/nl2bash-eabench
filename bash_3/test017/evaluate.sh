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
    # Test017
    #
    declare -A pairs=(
        [1]="1356"
        [2]="1173"
        [24]="6008"
        [25]="6201"
        [49]="9176"
        [50]="9322"
    )
    for n in ${!pairs[@]}
    do
        strip_out_stdout.sh podman.log | grep -q -E "^$n$|^$n[^0-9]|[^0-9]$n$|[^0-9]$n[^0-9]"
        if [ $? != 0 ]
        then
            echo >&2 "Expected to find line $n in stdout for value ${pairs[$n]}"
            exit 2
        fi
    done

    exit 0
)
rc=$?

exit $rc

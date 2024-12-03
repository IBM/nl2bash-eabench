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
    # Test016
    #
    #   3: kitten sitting
    #   4: January February
    #   8: May December
    #   9: January Decemeber
    #
    declare -A pair=(
        [3]="kitten sitting"
        [4]="January February"
        [6]="March August"
        [8]="May December"
    )
    for n in 3 4 6 8
    do
        strip_out_stdout.sh podman.log | grep -q -E "^$n$|^$n | $n$| $n "
        if [ $? != 0 ]
        then
            echo >&2 "Expected to find Levenshtein distance of $n for ${pair[$n]}"
            exit 2
        fi
    done

    exit 0
)
rc=$?

exit $rc

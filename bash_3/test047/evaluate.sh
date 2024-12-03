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
    # Primes: 1171 1181
    # Carmichael: 561, 1105, 1729
    # Composite: 1173 1183
    #
    declare -A a=(
        [1171]="prime"
        [1181]="prime"
        [1173]="composite"
        [1183]="composite"
        [561]="carmichael"
        [1105]="carmichael"
    )
    for n in ${!a[@]}
    do
        s=${a[$n]}
        strip_out_stdout.sh podman.log | grep "$n" | grep -q -i "$s"
        if [ $? != 0 ]
        then
            echo >&2 "Expected stdout to say $n is $s"
            exit 2
        fi
    done

    exit 0
)
rc=$?

exit $rc

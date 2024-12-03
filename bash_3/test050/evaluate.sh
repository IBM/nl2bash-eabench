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
    #
    #  16:  3(121) 7(22) 15(11)
    #  17:  2(10001) 4(101) 16(11)
    #  21:  2(10101) 4(111) 6(33)
    #  24:  5(44) 7(33) 11(22)
    #  26:  3(222) 5(101) 12(22)
    #  28:  3(1001) 6(44) 13(22)
    #  36:  5(121) 8(44) 11(33)
    #  40:  3(1111) 7(55) 9(44)
    #  45:  2(101101) 8(55) 14(33)
    #  48:  7(66) 11(44) 15(33)
    for n in 16 17 21 24 26 28 36 40 45 48
    do
        strip_out_stdout.sh podman.log | grep -q -E "^$n$|^$n[^0-9]|[^0-9]$n$|[^0-9]$n[^0-9]"
        if [ $? != 0 ]
        then
            echo >&2 "Expected stdout to contain $n"
            exit 2
        fi
    done

    exit 0
)
rc=$?

exit $rc

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
    #  (base) [test@murk test049]$ ./bash.sh 8
    #  The 8th Fibonacci number is 21
    #  The totient of 21 is 12
    #  (base) [test@murk test049]$ ./bash.sh 9
    #  The 9th Fibonacci number is 34
    #  The totient of 34 is 16
    #  (base) [test@murk test049]$ ./bash.sh 10
    #  The 10th Fibonacci number is 55
    #  The totient of 55 is 40
    #  (base) [test@murk test049]$ ./bash.sh 11
    #  The 11th Fibonacci number is 89
    #  The totient of 89 is 88
    for n in 12 16 40 88
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

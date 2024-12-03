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
    # (base) [test@murk test035]$ ./palin.sh 3000
    # The first number which is a palindrome in base 2, base 8, and base 16 is 3951
    # base2:  111101101111
    # base8:  7557
    # base16: F6F
    # (base) [test@murk test035]$ ./palin.sh 6
    # The first number which is a palindrome in base 2, base 8, and base 16 is 7
    # base2:  111
    # base8:  7
    # base16: 7
    #
    for n in 7 3951
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

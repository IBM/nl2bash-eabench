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
    # (base) [test@murk test048]$ ./pseudoprime.sh 25 7
    # PASS: mexp 7 24 25 --> 1
    # true
    # (base) [test@murk test048]$ ./pseudoprime.sh 25 14
    # fail: mexp 14 24 25 --> 16
    # false
    # (base) [test@murk test048]$ ./pseudoprime.sh 25 18
    # PASS: mexp 18 24 25 --> 1
    # true
    # (base) [test@murk test048]$ ./pseudoprime.sh 205 42
    # PASS: mexp 32 24 25 --> 1
    # true
    # (base) [test@murk test048]$ ./pseudoprime.sh 205 43
    # fail: mexp 43 204 205 --> 16
    # false
    declare answers=(
        "25 pseudoprime to 7 is true"
        "25 pseudoprime to 14 is false"
        "25 pseudoprime to 18 is true"
        "205 pseudoprime to 42 is true"
        "205 pseudoprime to 43 is false"
    )
    for answer in "${answers[@]}"
    do
        strip_out_stdout.sh podman.log | grep -q "$answer"
        if [ $? != 0 ]
        then
            echo >&2 "Expected stdout to contain \"$answer\""
            exit 2
        fi
    done

    exit 0
)
rc=$?

exit $rc

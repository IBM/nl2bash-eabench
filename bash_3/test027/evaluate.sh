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
    # Test027
    #
    # Typical
    # 
    # ./bash.sh 2023-04-10 (100)
    # ./bash.sh 2023-06-30 (181)
    # ./bash.sh 2024-06-30 (182)
    # ./bash.sh 2024-07-18 (200)
    #
    strip_out_stdout.sh podman.log | grep -q -E "23" && \
    strip_out_stdout.sh podman.log | grep -q -E "100"
    if [ $? != 0 ]
    then
        echo >&2 "Expected to find \"23100\" or \"2023100\" for 2023-04-10 in stdout"
        exit 2
    fi

    strip_out_stdout.sh podman.log | grep -q -E "23" && \
    strip_out_stdout.sh podman.log | grep -q -E "181"
    if [ $? != 0 ]
    then
        echo >&2 "Expected to find \"23181\" or \"2023181\" for 2023-06-10 in stdout"
        exit 2
    fi

    strip_out_stdout.sh podman.log | grep -q -E "24" && \
    strip_out_stdout.sh podman.log | grep -q -E "182"
    if [ $? != 0 ]
    then
        echo >&2 "Expected to find \"24182\" or \"2024182\" for 2024-06-30 in stdout"
        exit 2
    fi

    strip_out_stdout.sh podman.log | grep -q -E "24" && \
    strip_out_stdout.sh podman.log | grep -q -E "200"
    if [ $? != 0 ]
    then
        echo >&2 "Expected to find \"24200\" or \"2024200\" for 2024-07-18 in stdout"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

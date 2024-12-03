#!/bin/bash

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

#printf "Running a test002-specific evaluator\n"

#
# This test has a delay inside the container... so we have to be patient...
#
#sleep 5  - no longer needed since removing -id from podman

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
    # procps creates a stub config directory
    #
    sed -e '/^A home.test..config.procps$/d' \
        -e '/^A home.test..config$/d' \
        -e '/^C home.test$/d' \
        -i.bak home.log

    if [ $(stat --format="%s" diff.log) != 0 ]
    then
        echo >&2 "Created spurious system files in the container - see diff.log"
        exit 2
    fi

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory - see home.log"
        exit 2
    fi

    #
    # Test002
    #
    # Typcial output
    #
    #  %CPU     PID
    #  28.6      13
    #  28.3      14
    #  28.3      16
    #  27.6      11
    #   0.6       1
    #   0.0       8
    #   0.0       9
    #   0.0   14327
    #   0.0   14328
    #
    # Look for a line with "%CPU"
    # Too many models reformat the output and remove %CPU
    ##strip_out_stdout.sh podman.log | grep "\%CPU" > /dev/null
    ##if [ $? != 0 ]
    ##then
    ##    echo >&2 "Did not find %CPU in stdout output"
    ##    exit 2
    ##fi

    #
    # Look for lines with "^[123][0-9]"
    #   - weirdly, podman sometimes mixes up the order of the lines from stdout
    #   - lowered the bar from 20% to 17% ... and then to 11%
    #   - WSL: needed to increase > 39% ... so 10% <= X <= 99% is the new range now
    #
    n=$(strip_out_stdout.sh podman.log | grep busywait | \
        grep -e '^[1-9][0-9]\.[0-9]' -e ' [1-9][0-9]\.[0-9]' | \
        wc -l \
    )
    if [ $n == 4 ]
    then
        exit 0
    fi

    strip_out_stdout.sh podman.log | grep busywait > /dev/null
    if [ $? == 0 ]
    then
        echo >&2 "Expected four processes showing > %10 CPU"
    else
        echo >&2 "Expected to see my \"busywait\" process names"
    fi

    exit 2
)
rc=$?

exit $rc

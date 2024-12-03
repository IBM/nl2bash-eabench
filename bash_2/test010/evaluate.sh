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

#printf "Running a test010-specific evaluator\n"

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
    # We tinker with timedatectl so remove these from diff.log
    #
    sed -i -e "/C \/usr\/bin$/d"              diff.log
    sed -i -e "/C \/usr\/bin\/timedatectl$/d" diff.log

    #
    # Check to see it SYSTEM time was changed
    #
    grep -e "C /etc/localtime" diff.log > /dev/null
    if [ $? == 0 ]
    then
        echo >&2 "This changed the SYSTEM timezone rather than the USER's timezone"
        exit 2
    fi

    #
    # No files should've been created
    #
    if [ $(stat --format="%s" diff.log) != 0 ]
    then
        echo >&2 "Created spurious system files in the container -- see diff.log"
        exit 2
    fi

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory -- see home.log"
        exit 2
    fi

    #
    # Test010
    #
    # Typical output
    #
    #  Mon Feb  5 22:20:01 UTC 2024
    #  Mon Feb  5 17:20:01 EST 2024
    #
    # Look for UTC and EST
    (strip_out_stdout.sh podman.log | grep -E "UTC" > /dev/null) &&
    (strip_out_stdout.sh podman.log | grep -E "PST|PDT" > /dev/null)
    if [ $? != 0 ]
    then
        echo >&2 "Expected \"UTC\" and \"PST or PDT\" in stdout"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

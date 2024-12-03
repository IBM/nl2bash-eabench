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

#printf "Running a test007-specific evaluator\n"

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
    # Strip out the /etc/group changed
    #
    sed -e "/^C \/var$/d" \
        -e "/^C \/var\/log$/d" \
        -e "/^A \/var\/log\/wtmp$/d" \
        -i.bak diff.log
    #
    # No files should've been created
    #
    if [ $(stat --format="%s" diff.log) != 0 ]
    then
        echo >&2 "Created spurious system files in the container --> see diff.log"
        exit 2
    fi

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory -- see home.log"
        exit 2
    fi

    #
    # Test007
    #
    # Typical output
    #
    # uptime
    #   21:30:20 up 13 days,  4:43,  0 users,  load average: 0.04, 0.07, 0.03
    #   17:27:52 up 57 min,  2 users,  load average: 0.00, 0.01, 0.05
    #   17:30:51 up  1:00,  2 users,  load average: 0.00, 0.01, 0.05        (1 hour)
    #   12:20:46 up 22:07,  4 users,  load average: 0.14, 0.08, 0.20
    #
    # uptime -p
    #   up 4 weeks, 3 days, 5 hours, 43 minutes
    #   up 59 minutes
    #   up 1 hour
    #   up 22 hours, 8 minutes
    #
    # w
    #   17:31:52 up  1:01,  2 users,  load average: 0.00, 0.01, 0.05   (1 hour)
    #   17:30:14 up 59 min,  2 users,  load average: 0.00, 0.01, 0.05
    #   17:59:26 up  5:41,  0 users,  load average: 0.37, 0.13, 0.04
    #
    strip_out_stdout.sh podman.log | grep -e ' up  *[0-9][0-9]*' -e '^up  *[0-9][0-9]* ' > /dev/null
    if [ $? != 0 ]
    then
        echo >&2 "Expected to find an \"up\" time, not date, in stdout"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

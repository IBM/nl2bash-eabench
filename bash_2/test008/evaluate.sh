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

#printf "Running a test008-specific evaluator\n"

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
    #   - I change /etc/passwd for this test
    #
    sed -e "/^C \/etc$/d" \
        -e "/^C \/etc\/passwd$/d" \
        -i.bak diff.log

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
    # Test008
    #
    # Typical output
    #
    # /var/run/utmp is faked using utmpdump
    #
    # w output (login date is fixed)
    # test     pts/0    9.61.51.96       19Nov89  2.00s  0.06s  0.00s w
    #
    # who output (login date is fixed)
    # snoopy   pts/0        Nov 19 19:25 (9.61.51.96)
    #
    strip_out_stdout.sh podman.log | grep -E '^snoopy .* 19Nov89 ' > /dev/null
    if [ $? == 0 ]
    then
        exit 0
    fi

    strip_out_stdout.sh podman.log | grep -E '^snoopy .* Nov 19 19:25 ' > /dev/null
    if [ $? == 0 ]
    then
        exit 0
    fi

    strip_out_stdout.sh podman.log | grep -E '^snoopy *$' > /dev/null
    if [ $? == 0 ]
    then
        exit 0
    fi

    # ... and out of desperation...
    (strip_out_stdout.sh podman.log | grep snoopy && grep -E "^ *w" home/test/bash.sh) > /dev/null
    if [ $? == 0 ]
    then
        exit 0
    fi

    echo >&2 "Expected to see user \"snoopy\" listed on stdout"
    exit 2
)
rc=$?

exit $rc

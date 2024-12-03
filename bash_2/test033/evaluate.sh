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

#printf "Running a test016-specific evaluator\n"

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
    # Strip out /tmp/myfifo
    #
    sed -e "/^C \/tmp$/d" \
        -e "/^A \/tmp\/myfifo$/d" \
        -i.bak diff.log

    #
    # No other files should've been created
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
    # Test033
    #
    # podman(as user test): prw-r--r--. 1 test test 0 Mar  8 22:50 /tmp/myfifo
    # docker(as user root): prw-r--r-- 1 root root 0 Oct 11 18:33 /tmp/myfifo
    #
    strip_out_stdout.sh podman.log | tail -1 | grep -q -E 'p..-..-..-.* 1 .* /tmp/myfifo'
    if [ $? != 0 ]
    then
        echo >&2 "Expected to find /tmp/myfifo"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

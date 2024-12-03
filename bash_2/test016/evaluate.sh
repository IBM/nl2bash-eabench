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

    # Special case:
    #    if they pick "dd" to create the file...
    #      ... dd outputs "informational" messages to stderr... grrrr...
    #
    if grep -E '^ *dd ' home/test/bash.sh > /dev/null
    then
        sed -i.bak \
            -E '/stderr( F [0-9]+.*records .*)/s//stdout\1/;
                /stderr( F [0-9]+ bytes .* copied.*)/s//stdout\1/' \
            podman.log
    fi

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
        echo >&2 "Created spurious system files in the container -- see diff.log"
        exit 2
    fi

    #
    # This time we expect a difference in the home directory
    #
    sed -e "/^A home.test.data.dat/d" \
        -e "/^C home.test/d" \
        -i.bak home.log

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory -- see home.log"
        exit 2
    fi

    if [ -f home/test/data.dat ]
    then
        rc=$(stat --format="%s" home/test/data.dat) > /dev/null
        if [ $rc != 524288 ]
        then
            echo >&2 "Expected a file size of 524288 bytes rather than $rc"
            exit 2
        fi
    else
        echo >&2 "Expected to find a file named \"data.dat\" in /home/test"
        exit 2
    fi

    #
    # Test016
    #
    # Typical output
    #
    # -rw-r--r--. 1 test test 524288 Feb  6 17:05 data.dat
    strip_out_stdout.sh podman.log | tail -1 | grep -E ' 524288 .* data.dat' > /dev/null
    if [ $? != 0 ]
    then
        echo >&2 "Expected to find data.dat with size of 524288 bytes"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

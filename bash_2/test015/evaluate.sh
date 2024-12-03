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

#printf "Running a test015-specific evaluator\n"

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
        echo >&2 "Created spurious system files in the container -- see diff.log"
        exit 2
    fi

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory -- see home.log"
        exit 2
    fi

    #
    # Test015
    #
    # Typical output
    #
    # Output of umask
    #           owner  other
    #  0 - rwx   ok
    #  1 - rw-   ok
    #  2 - r-x          ok
    #  3 - r--          ok
    #  4 - -wx   ok
    #  5 - -w-   ok
    #  6 - --x          ok
    #  7 - ---          ok
    #
    strip_out_stdout.sh podman.log | tail -1 | grep -E '^0[0145][2367][2367]' > /dev/null
    if [ $? != 0 ]
    then
        echo >&2 "Expected a umask value of re\"0[0145][2367][2367]\""
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

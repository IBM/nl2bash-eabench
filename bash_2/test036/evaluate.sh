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


(
    cd ${wrkdir}

    #
    # Look for any stderr output during runtime
    #
    rc=$(strip_out_stderr.sh podman.log | wc -l)
    if [ $rc != 0 ]
    then
        strip_out_stderr.sh podman.log >&2
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
    # Expect change to /home/test/subdirA/file.log
    #
    sed -e "/^C home.test.subdirA/d" \
        -e "/^C home.test.subdirA.file.log/d" \
        -i.bak home.log

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory -- see home.log"
        exit 2
    fi

    #
    # Test036
    #
    # Typical output:
    #
    rc=$(grep -E "^$" home/test/subdirA/file.log | wc -l)
    if [ $rc != 6 ]
    then
        echo >&2 "Expected six blank lines in /home/test/subdirA/file.log"
        exit 2
    fi

    rc=$(grep -E "^stdout " home/test/subdirA/file.log | wc -l)
    if [ $rc != 6 ]
    then
        echo >&2 "Expected six lines prefixed with \"stdout\" in /home/test/subdirA/file.log"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

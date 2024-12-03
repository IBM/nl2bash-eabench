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
    # Expect changes to pretty-print.sh
    #
    sed -e "/^C home.test/d" \
        -e "/^C home.test.pretty-print.sh/d" \
        -i.bak home.log

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory -- see home.log"
        exit 2
    fi

    #
    # Test039
    #
    # Typical output:
    #   -rwxrwxr-x. 1 test test 0 Mar 19 16:19 pretty-print.sh
    #
    (strip_out_stdout.sh podman.log | grep "pretty-print.sh" | grep -e "-..x..x..x") > /dev/null
    if [ $? != 0 ]
    then
        echo >&2 "Expected pretty-print.sh to have \"..x..x..x\" for permissions"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

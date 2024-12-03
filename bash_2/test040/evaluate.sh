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
        -e "/^C home.test.images.tar/d" \
        -i.bak home.log

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory -- see home.log"
        exit 2
    fi

    #
    # Test040
    #
    # Typical output:
    #   -rwxrwxr-x. 1 test test 0 Mar 19 16:19 pretty-print.sh
    #
    (strip_out_stdout.sh podman.log | grep -E "^POST: test.sh") > /dev/null
    if [ $? != 0 ]
    then
        echo >&2 "Expected to find test.sh in images.tar"
        echo >&2 "Was the tar file recreated instead of appended?"
        exit 2
    fi

    rc=0
    for(( i=1; i<=5; i++ ))
    do
        (strip_out_stdout.sh podman.log | grep -E "^POST: picture$i.png") > /dev/null && \
        (strip_out_stdout.sh podman.log | grep -E "^POST: image$i.jpg")   > /dev/null
        if [ $? != 0 ]
        then
            echo >&2 "Expected to find picture$i.png and image$i.jpg in images.tar"
            rc=2
        fi
    done
    exit $rc
)
rc=$?

exit $rc

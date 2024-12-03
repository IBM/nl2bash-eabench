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
    # Expect changes to file extension
    #
    sed -e "/^C home.test.uploads/d" \
        -e "/^D home.test.uploads.good.mpg/d" \
        -e "/^D home.test.uploads.bad.mpg/d" \
        -e "/^D home.test.uploads.ugly.mpg/d" \
        -e "/^A home.test.uploads.good.avi/d" \
        -e "/^A home.test.uploads.bad.avi/d" \
        -e "/^A home.test.uploads.ugly.avi/d" \
        -i.bak home.log

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory -- see home.log"
        exit 2
    fi

    #
    # Test037
    #
    # Typical output:
    #
    (strip_out_stdout.sh podman.log | grep "good.avi") && \
    (strip_out_stdout.sh podman.log | grep "bad.avi" ) && \
    (strip_out_stdout.sh podman.log | grep "ugly.avi")
    if [ $? != 0 ]
    then
        echo >&2 "Expected good.avi, bad.avi, and ugly.avi in stdout"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc
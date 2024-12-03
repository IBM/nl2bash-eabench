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

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory -- see home.log"
        exit 2
    fi

    #
    # Test043
    #
    # Typical output:
    #   -rw-rw-r--. 1 test slackers 0 Mar 19 18:18 download.dat
    #
    # post_test.sh outputs file and directory counts
    #   - FILES, DIRS
    read -d' ' -a vars <<< $(extract_vars.sh podman.log)
    for var in ${vars[@]}
    do
        eval ${var}
    done

    (strip_out_stdout.sh podman.log | grep -E "^$DIRS$") || \
    (strip_out_stdout.sh podman.log | grep -E "^$DIRS ") || \
    (strip_out_stdout.sh podman.log | grep -E " $DIRS$") || \
    (strip_out_stdout.sh podman.log | grep -E " $DIRS ")
    if [ $? != 0 ]
    then
        echo >&2 "Expected to find \"$DIRS\" in stdout"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

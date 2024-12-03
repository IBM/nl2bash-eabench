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

#printf "Running a test012-specific evaluator\n"

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
    # Test012
    #
    # Typical output
    #
    # The contents of /etc/os-release but we'll look specifically for the VERSION_ID:
    #    VERSION_ID="8.9"
    #
    # post_test.sh grabs the VERSION_ID from /etc/os-release
    #   - VERSION
    read -d' ' -a vars <<< $(extract_vars.sh podman.log)
    for var in ${vars[@]}
    do
        eval ${var}
    done

    #printf "VERSION is %s\n" ${VERSION}
    #STRING=$(printf "[^0-9]%s[^0-9]" $(echo ${VERSION} | sed -E 's/([0-9]+)\.([0-9]+)/\1\\.\2/'))
    #printf "My search string is %s\n" ${STRING}

    strip_out_stdout.sh podman.log | grep ${VERSION}
    if [ $? != 0 ]
    then
        echo >&2 "Expected to find OS VERSION ${VERSION} in stdout"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

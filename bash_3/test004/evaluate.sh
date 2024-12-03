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

#printf "Running a test001-specific evaluator\n"

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
    # Strip out spurious changes
    #   - so many?
    #
    sed -e "/^C \/etc$/d" \
        -e "/^C \/etc\/.pwd.lock$/d" \
        -e "/^C \/etc\/passwd$/d" \
        -e "/^C \/etc\/passwd-$/d" \
        -e "/^C \/etc\/shadow$/d" \
        -e "/^C \/etc\/shadow-$/d" \
        -e "/^C \/etc\/group$/d" \
        -e "/^C \/etc\/group-$/d" \
        -e "/^C \/etc\/gshadow$/d" \
        -e "/^C \/etc\/gshadow-$/d" \
        -e "/^C \/etc\/subuid$/d" \
        -e "/^C \/etc\/subuid-$/d" \
        -e "/^C \/etc\/subgid$/d" \
        -e "/^C \/etc\/subgid-$/d" \
        -e "/^C \/var\/spool\/mail$/d" \
        -i.bak diff.log

    #
    # No files should've been created
    #
    if [ $(stat --format="%s" diff.log) != 0 ]
    then
        echo >&2 "Created spurious system files"
        exit 2
    fi

    if [ $(stat --format="%s" home.log) != 0 ]
    then
        echo >&2 "Created spurious files in the home directory"
        exit 2
    fi

    #
    # Test004
    #
    strip_out_stdout.sh podman.log | grep -q "snoopy"
    if [ $? != 0 ]
    then
        echo >&2 "Expected to find a duplicate entry for user \"snoopy\""
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

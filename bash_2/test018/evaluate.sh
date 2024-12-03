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

#printf "Running a test010-specific evaluator\n"

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
    # /etc/localtime should've changed
    #
    #grep -e "C /etc/localtime" diff.log > /dev/null
    #if [ $? != 0 ]
    #then
    #    echo >&2 "The SYSTEM timezone /etc/localtime should've changed"
    #    exit 2
    #fi

    #
    # Strip out the timezone changed
    #
    sed -e "/^C \/etc$/d" \
        -e "/^C \/etc\/localtime$/d" \
        -e "/^C \/usr\/bin$/d" \
        -e "/^C \/usr\/bin\/timedatectl$/d" \
        -i.bak diff.log

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
    # Test010
    #
    # Typical output
    #
    #  Mon Feb  5 22:20:01 UTC 2024
    #  Mon Feb  5 17:20:01 EST 2024
    #
    # post_test.sh outputs a LOCALTIME variable
    read -d' ' -a vars <<< $(extract_vars.sh podman.log)
    for var in ${vars[@]}  # this should just be LOCALTIME
    do
        eval ${var}
    done

    if [ ${LOCALTIME} != "America/Los_Angeles" ]
    then
        echo >&2 "/etc/localtime is ${LOCALTIME} but should be \"America/Los_Angeles\""
        exit 2
    fi

    # Look for PST
    strip_out_stdout.sh podman.log | grep -E "PST|PDT" > /dev/null
    if [ $? != 0 ]
    then
        echo >&2 "Expected \"PST or PDT\" in stdout"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

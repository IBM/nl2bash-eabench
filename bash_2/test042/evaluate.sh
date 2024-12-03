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
    # Strip out the /etc/group changed
    #   - so many?
    #
    sed -e "/^C \/etc$/d" \
        -e "/^C \/etc\/.pwd.lock$/d" \
        -e "/^C \/etc\/passwd$/d" \
        -e "/^C \/etc\/shadow$/d" \
        -e "/^C \/etc\/group$/d" \
        -e "/^C \/etc\/group-$/d" \
        -e "/^C \/etc\/gshadow$/d" \
        -e "/^C \/etc\/gshadow-$/d" \
        -e "/^C \/var$/d" \
        -e "/^C \/var\/log$/d" \
        -e "/^A \/var\/log\/lastlog$/d" \
        -i.bak diff.log

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
    # Test042
    #
    # Typical output:
    #   -rw-rw-r--. 1 test slackers 0 Mar 19 18:18 download.dat
    #
    (strip_out_stdout.sh podman.log | grep "POST" | grep "download.dat" | grep "slackers") > /dev/null
    if [ $? != 0 ]
    then
        echo >&2 "Expected to find \"test slackers\" on download.dat in stdout"
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

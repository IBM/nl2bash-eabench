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
    # /etc/gshadow should've changed
    #
    #grep -e "C /etc/gshadow" diff.log > /dev/null
    #if [ $? != 0 ]
    #then
    #    echo >&2 "The file /etc/gshadow should've changed"
    #    exit 2
    #fi

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
    # Test020
    #
    # Typical output
    #
    # post_test.sh outputs a GROUP variable
    read -d' ' -a vars <<< $(extract_vars.sh podman.log)
    for var in ${vars[@]}  # this should just be GROUP
    do
        eval ${var}
    done

    if [ ${GROUP} == "slackers:!::test" ]
    then
        echo >&2 "User \"test\" was added to \"slackers\" but not as an administrator"
        exit 2
    fi

    if [ ${GROUP} != "slackers:!:test:" ]
    then
        echo >&2 "/etc/gshadow should have contained the line \"slackers:!:test:\""
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

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
    #   - I had to add "delgroup" 'cuz it's an oldie, goldie
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
        -e "/^C \/var$/d" \
        -e "/^C \/var\/spool$/d" \
        -e "/^C \/var\/spool\/mail$/d" \
        -e "/^A \/var\/spool\/mail\/dodger$/d" \
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
    # post_test.sh outputs variables:
    #   ID      (id dodger)
    #   PASSWD  (grep dodger /etc/passwd)
    #   SHADOW  (sudo grep dodger /etc/shadow)
    #   GROUP   (grep dodger /etc/group)
    #   GSHADOW (sudo grep dodger /etc/gshadow)
    read -d' ' -a vars <<< $(extract_vars.sh podman.log)
    for var in ${vars[@]}
    do
        eval ${var}
    done

    #echo "ID is " ${ID}
    #echo USER is "${USER}"

    if [ ${ID} != "uid=2001(dodger)_gid=2001(dodger)_groups=2001(dodger)" ]
    then
        echo >&2 "Expected to see user \"dodger\" with uid of 2001"
        exit 2
    fi

    T="dodger:x:2001:2001::/home/dodger:/bin/bash"
    if [ ${PASSWD} != $T ]
    then
        echo >&2 "Expected /etc/passwd entry of \"$T\""
        exit 2
    fi

    TODAY="$(( $(date --utc +%s) / 86400 ))"
    DAYS="$(( $(date --utc --date='90 days' +%s) / 86400 ))"
    T="$(printf 'dodger:!!:%s:0:99999:7::%s:' ${TODAY} ${DAYS})"

    #echo "DAYS is " ${DAYS}
    #echo "MINE is " ${T}
    #echo "SHADOW is " ${SHADOW}
    
    if [ ${SHADOW} != $T ]
    then
        echo >&2 "Expected /etc/shadow entry of \"$T\""
        exit 2
    fi

    T="dodger:x:2001:"
    if [ ${GROUP} != $T ]
    then
        echo >&2 "Expected /etc/group entry of \"$T\""
        exit 2
    fi

    T="dodger:!::"
    if [ ${GSHADOW} != $T ]
    then
        echo >&2 "Expected /etc/gshadow entry of \"$T\""
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc

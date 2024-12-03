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
        -e "/^A \/var\/spool\/mail\/snoopy$/d" \
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
    # Test031
    #
    # Typical output
    #
    # shadow format
    #  login :  password    :L:m:   M :W:I:A:R
    #  snoopy:$-$Woodstock:19836:0:99999:7:::  (after creating login)
    #  snoopy:$-$Woodstock:0:0:99999:7:::      (after passwd -e)
    #  snoopy:$-$Woodstock:0:0:99999:7:::      (after chage -d 0)
    #
    #  snoopy:!!$-$Woodstock:0:0:99999:7: : :
    #    L - last password change  (passwd -e)
    #    m - min password age
    #    M - max password age  (passwd -x)
    #    W - password warn
    #    I - password inactivity
    #    A - account expiration  (chage -E) (usermod -e)
    #    R - reserved
    #
    # passwd -e clears the "last changed" time
    # chage -d 0 clears 
    # chage -E 0 sets a zero in "expires" time (do not accept: this means account is expired)
    #
    # post_test.sh outputs PASSWD & SHADOW variables
    read -d' ' -a vars <<< $(extract_vars.sh podman.log)
    for var in ${vars[@]}
    do
        eval ${var}
    done

    if [ ${PASSWD} != "snoopy:x:1001:1001::/home/snoopy:/bin/bash" ]
    then
        echo >&2 "/etc/passwd should still contain the line \"snoopy:x:1001:1001::/home/snoopy:/bin/bash\""
        exit 2
    fi

    #
    # Some scripts changed the password
    #
    echo ${SHADOW} | grep -E 'snoopy:[^:]*:0:0:99999:7:::'
    if [ $? != 0 ]
    then
        echo >&2 'Expected /etc/shadow to be \"snoopy:$-$Woodstock:0:0:99999:7:::\"'
        exit 2
    fi

    exit 0
)
rc=$?

exit $rc